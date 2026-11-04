
#!/bin/bash
# ============================================================
# Linux 日常系统巡检脚本
# 适用系统：
# Ubuntu / Debian / RHEL / CentOS / Rocky / AlmaLinux / openEuler
#
# 巡检内容：
# CPU、内存、磁盘、Inode、系统负载、网络、Systemctl、
# 进程、端口、系统日志
#
# 功能：
# 1. 自动识别操作系统
# 2. 自动检查系统资源状态
# 3. 自动统计正常、警告、异常、未检查项目
# 4. 输出巡检汇总报表
# 5. 自动保存巡检日志
#
# 注意：本脚本只进行只读巡检，不修改系统配置
# ============================================================

# -------------------- 1. 基础配置 ----------------------------

SCRIPT_NAME="Linux日常巡检"

DATE_TIME=$(date '+%Y-%m-%d %H:%M:%S')
DATE_TAG=$(date '+%Y%m%d_%H%M%S')

HOSTNAME=$(hostname 2>/dev/null || echo "Unknown")
IP_ADDR=$(hostname -I 2>/dev/null | awk '{print $1}')
KERNEL=$(uname -r)
ARCH=$(uname -m)

# 巡检阈值
CPU_WARN=80
MEM_WARN=80
DISK_WARN=80
INODE_WARN=80
LOAD_WARN=1.0

# 日志检查数量
LOG_LIMIT=50

# 日志目录
LOG_DIR="/var/log/linux_inspection"

if ! mkdir -p "$LOG_DIR" 2>/dev/null; then
    LOG_DIR="/tmp/linux_inspection"
    mkdir -p "$LOG_DIR" || exit 1
fi

LOG_FILE="${LOG_DIR}/inspection_${DATE_TAG}.log"

# 统计变量
REPORT_ITEMS=()
REPORT_STATUS=()
REPORT_DETAILS=()

CURRENT_INDEX=-1

NORMAL_COUNT=0
WARNING_COUNT=0
ERROR_COUNT=0
UNKNOWN_COUNT=0

OVERALL_STATUS="正常"

# 输出同时保存到日志
exec > >(tee -a "$LOG_FILE") 2>&1

# -------------------- 2. 通用函数 ----------------------------

section() {

    echo
    echo "============================================================"
    echo "【$1】"
    echo "============================================================"

    REPORT_ITEMS+=("$1")
    REPORT_STATUS+=("正常")
    REPORT_DETAILS+=("检查完成")

    CURRENT_INDEX=$((${#REPORT_ITEMS[@]} - 1))
}

info() {
    echo "[INFO] $1"
}

ok() {
    echo "[正常] $1"
}

warn() {

    echo "[警告] $1"

    if [ "$CURRENT_INDEX" -ge 0 ]; then

        if [ "${REPORT_STATUS[$CURRENT_INDEX]}" != "异常" ]; then
            REPORT_STATUS[$CURRENT_INDEX]="警告"
        fi

        REPORT_DETAILS[$CURRENT_INDEX]="${REPORT_DETAILS[$CURRENT_INDEX]}；$1"
    fi
}

error() {

    echo "[异常] $1"

    if [ "$CURRENT_INDEX" -ge 0 ]; then

        REPORT_STATUS[$CURRENT_INDEX]="异常"

        REPORT_DETAILS[$CURRENT_INDEX]="${REPORT_DETAILS[$CURRENT_INDEX]}；$1"
    fi
}

unknown() {

    echo "[未检查] $1"

    if [ "$CURRENT_INDEX" -ge 0 ]; then

        REPORT_STATUS[$CURRENT_INDEX]="未检查"

        REPORT_DETAILS[$CURRENT_INDEX]="$1"
    fi
}

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# -------------------- 3. 系统基本信息 ------------------------

section "系统基本信息"

PRETTY_NAME="Unknown"

if [ -f /etc/os-release ]; then
    . /etc/os-release
    PRETTY_NAME="${PRETTY_NAME:-Unknown}"
fi

CPU_CORES=$(nproc 2>/dev/null || grep -c '^processor' /proc/cpuinfo)

info "操作系统：$PRETTY_NAME"
info "主机名称：$HOSTNAME"
info "IP地址：${IP_ADDR:-Unknown}"
info "内核版本：$KERNEL"
info "系统架构：$ARCH"
info "CPU核心数：$CPU_CORES"
info "巡检时间：$DATE_TIME"
info "系统运行时间：$(uptime -p 2>/dev/null || uptime)"

ok "系统基本信息获取完成"

# -------------------- 4. CPU检查 -----------------------------

section "CPU使用率检查"

if [ -r /proc/stat ]; then

    read -r _ u1 n1 s1 i1 w1 irq1 sirq1 st1 _ < /proc/stat

    idle1=$((i1 + w1))
    total1=$((u1 + n1 + s1 + i1 + w1 + irq1 + sirq1 + st1))

    sleep 1

    read -r _ u2 n2 s2 i2 w2 irq2 sirq2 st2 _ < /proc/stat

    idle2=$((i2 + w2))
    total2=$((u2 + n2 + s2 + i2 + w2 + irq2 + sirq2 + st2))

    total_diff=$((total2 - total1))
    idle_diff=$((idle2 - idle1))

    if [ "$total_diff" -gt 0 ]; then

        CPU_USAGE=$(( (total_diff - idle_diff) * 100 / total_diff ))

        info "CPU使用率：${CPU_USAGE}%"

        if [ "$CPU_USAGE" -ge "$CPU_WARN" ]; then
            warn "CPU使用率超过阈值 ${CPU_WARN}%"
        else
            ok "CPU使用率正常"
        fi

    else
        unknown "无法计算CPU使用率"
    fi

else
    unknown "无法读取 /proc/stat"
fi

# -------------------- 5. 内存检查 ----------------------------

section "内存使用情况"

if command_exists free; then

    MEM_INFO=$(free -m | awk '
    /^Mem:/ {
        total=$2
        used=$3
        available=$7

        if(total>0) {
            usage=int((total-available)*100/total)
            printf "%d %d %d %d",total,used,available,usage
        }
    }')

    if [ -n "$MEM_INFO" ]; then

        read -r MEM_TOTAL MEM_USED MEM_AVAILABLE MEM_USAGE <<< "$MEM_INFO"

        info "总内存：${MEM_TOTAL} MB"
        info "已用内存：${MEM_USED} MB"
        info "可用内存：${MEM_AVAILABLE} MB"
        info "内存使用率（按可用内存计算）：${MEM_USAGE}%"

        if [ "$MEM_USAGE" -ge "$MEM_WARN" ]; then
            warn "内存使用率超过阈值 ${MEM_WARN}%"
        else
            ok "内存使用率正常"
        fi

    else
        unknown "无法获取内存数据"
    fi

else
    unknown "未找到 free 命令"
fi

# -------------------- 6. 磁盘检查 ----------------------------

section "磁盘空间检查"

if command_exists df; then

    df -hP -x tmpfs -x devtmpfs -x squashfs

    DISK_PROBLEM=0

    while read -r usage mount; do

        [ -z "$usage" ] && continue

        percent=${usage%\%}

        if [ "$percent" -ge "$DISK_WARN" ]; then

            warn "磁盘使用率偏高：${mount} ${usage}"
            DISK_PROBLEM=1

        fi

    done < <(
        df -P -x tmpfs -x devtmpfs -x squashfs 2>/dev/null |
        awk 'NR>1 {print $5, $6}'
    )

    if [ "$DISK_PROBLEM" -eq 0 ]; then
        ok "磁盘空间使用率正常"
    fi

else
    unknown "未找到 df 命令"
fi

# -------------------- 7. Inode检查 ---------------------------

section "Inode使用情况"

if command_exists df; then

    df -Pi -x tmpfs -x devtmpfs -x squashfs

    INODE_PROBLEM=0

    while read -r usage mount; do

        [ -z "$usage" ] && continue

        percent=${usage%\%}

        if [ "$percent" -ge "$INODE_WARN" ]; then

            warn "Inode使用率偏高：${mount} ${usage}"
            INODE_PROBLEM=1

        fi

    done < <(
        df -Pi -x tmpfs -x devtmpfs -x squashfs 2>/dev/null |
        awk 'NR>1 {print $5, $6}'
    )

    if [ "$INODE_PROBLEM" -eq 0 ]; then
        ok "Inode使用率正常"
    fi

else
    unknown "未找到 df 命令"
fi

# -------------------- 8. 系统负载检查 ------------------------

section "系统负载检查"

if [ -r /proc/loadavg ]; then

    read -r LOAD1 LOAD5 LOAD15 _ < /proc/loadavg

    info "1分钟负载：$LOAD1"
    info "5分钟负载：$LOAD5"
    info "15分钟负载：$LOAD15"
    info "CPU核心数：$CPU_CORES"

    LOAD_LIMIT=$(awk -v c="$CPU_CORES" -v w="$LOAD_WARN" \
        'BEGIN {printf "%.2f", c*w}')

    if awk -v l="$LOAD1" -v limit="$LOAD_LIMIT" \
        'BEGIN {exit !(l>=limit)}'; then

        warn "1分钟系统负载达到预警阈值：$LOAD_LIMIT"

    else

        ok "系统负载正常"

    fi

else
    unknown "无法读取 /proc/loadavg"
fi

# -------------------- 9. 网络检查 ----------------------------

section "网络状态检查"

if command_exists ip; then

    info "网卡及IP地址："

    ip -br addr 2>/dev/null

    echo
    info "默认路由："

    ROUTE_INFO=$(ip route show default 2>/dev/null)

    if [ -n "$ROUTE_INFO" ]; then
        echo "$ROUTE_INFO"
    else
        warn "未发现默认路由"
    fi

    echo
    info "网卡流量及错误统计："

    NET_PROBLEM=0

    for iface in /sys/class/net/*; do

        [ -d "$iface" ] || continue

        name=$(basename "$iface")

        [ "$name" = "lo" ] && continue

        state=$(cat "$iface/operstate" 2>/dev/null)
        rx=$(cat "$iface/statistics/rx_bytes" 2>/dev/null)
        tx=$(cat "$iface/statistics/tx_bytes" 2>/dev/null)
        rx_err=$(cat "$iface/statistics/rx_errors" 2>/dev/null)
        tx_err=$(cat "$iface/statistics/tx_errors" 2>/dev/null)
        rx_drop=$(cat "$iface/statistics/rx_dropped" 2>/dev/null)
        tx_drop=$(cat "$iface/statistics/tx_dropped" 2>/dev/null)

        info "网卡：$name 状态：$state"
        info "接收流量：${rx:-0} Bytes"
        info "发送流量：${tx:-0} Bytes"
        info "接收错误：${rx_err:-0}"
        info "发送错误：${tx_err:-0}"
        info "接收丢包：${rx_drop:-0}"
        info "发送丢包：${tx_drop:-0}"

        if [ "$state" = "down" ]; then

            warn "网卡 $name 状态为 DOWN"
            NET_PROBLEM=1

        fi

        if [ "${rx_err:-0}" -gt 0 ] || [ "${tx_err:-0}" -gt 0 ]; then

            warn "网卡 $name 存在错误包"
            NET_PROBLEM=1

        fi

    done

    if [ "$NET_PROBLEM" -eq 0 ]; then
        ok "网卡状态及错误统计正常"
    fi

else
    unknown "未找到 ip 命令"
fi

# -------------------- 10. Systemctl检查 ---------------------

section "Systemctl服务检查"

if command_exists systemctl && [ -d /run/systemd/system ]; then

    info "检查失败的 systemd 服务："

    FAILED_SERVICES=$(systemctl --failed --no-legend --no-pager 2>/dev/null)

    if [ -n "$FAILED_SERVICES" ]; then

        echo "$FAILED_SERVICES"

        error "发现失败的 systemd 服务"

    else

        ok "未发现失败的 systemd 服务"

    fi

    echo
    info "当前运行中的服务数量："

    RUNNING_COUNT=$(systemctl list-units \
        --type=service \
        --state=running \
        --no-legend \
        --no-pager 2>/dev/null | wc -l)

    info "运行中的服务数量：$RUNNING_COUNT"

else
    unknown "当前系统未检测到 systemd 运行环境"
fi

# -------------------- 11. 进程检查 ---------------------------

section "进程状态检查"

if command_exists ps; then

    PROCESS_COUNT=$(ps -e --no-headers 2>/dev/null | wc -l)

    info "系统进程总数：$PROCESS_COUNT"

    echo
    info "CPU占用最高的前10个进程："

    ps -eo pid,ppid,user,%cpu,%mem,stat,comm \
        --sort=-%cpu 2>/dev/null | head -11

    echo
    info "内存占用最高的前10个进程："

    ps -eo pid,ppid,user,%cpu,%mem,stat,comm \
        --sort=-%mem 2>/dev/null | head -11

    echo
    ZOMBIE_COUNT=$(ps -eo stat= 2>/dev/null |
        awk '$1 ~ /^Z/ {count++} END {print count+0}')

    info "僵尸进程数量：$ZOMBIE_COUNT"

    if [ "$ZOMBIE_COUNT" -gt 0 ]; then

        warn "系统存在僵尸进程"

        info "僵尸进程详细信息："

        ps -eo pid,ppid,stat,comm |
            awk 'NR==1 || $3 ~ /^Z/'

    else

        ok "未发现僵尸进程"

    fi

else
    unknown "未找到 ps 命令"
fi

# -------------------- 12. 端口检查 ---------------------------

section "端口监听检查"

if command_exists ss; then

    info "TCP监听端口："

    ss -lntp 2>/dev/null

    echo
    info "UDP监听端口："

    ss -lnup 2>/dev/null

    ok "端口监听信息获取完成"

elif command_exists netstat; then

    netstat -lntup 2>/dev/null

    ok "端口监听信息获取完成"

else

    unknown "未找到 ss 或 netstat 命令"

fi

# -------------------- 13. 日志检查 ---------------------------

section "系统日志检查"

if command_exists journalctl && [ -d /run/systemd/system ]; then

    info "最近24小时系统错误日志，最多显示${LOG_LIMIT}条："

    JOURNAL_LOG=$(journalctl \
        --since "24 hours ago" \
        -p err..alert \
        --no-pager \
        -n "$LOG_LIMIT" 2>/dev/null)

    if [ -n "$JOURNAL_LOG" ]; then

        echo "$JOURNAL_LOG"

        warn "发现系统错误级别日志，需要进一步确认"

    else

        ok "最近24小时未发现错误级别日志"

    fi

elif [ -f /var/log/syslog ]; then

    info "最近系统日志（syslog）："

    tail -n 100 /var/log/syslog

    warn "已读取传统系统日志，请结合内容检查"

elif [ -f /var/log/messages ]; then

    info "最近系统日志（messages）："

    tail -n 100 /var/log/messages

    warn "已读取传统系统日志，请结合内容检查"

else

    unknown "未找到可读取的系统日志"

fi

# -------------------- 14. 巡检统计报表 -----------------------

section "巡检统计报表"

NORMAL_COUNT=0
WARNING_COUNT=0
ERROR_COUNT=0
UNKNOWN_COUNT=0

echo
echo "============================================================"
echo "                 Linux 日常巡检统计报告"
echo "============================================================"

echo "主机名称：$HOSTNAME"
echo "IP地址：${IP_ADDR:-Unknown}"
echo "操作系统：$PRETTY_NAME"
echo "内核版本：$KERNEL"
echo "系统架构：$ARCH"
echo "巡检时间：$DATE_TIME"

echo
echo "------------------------------------------------------------"
printf "%-20s %-14s %-45s\n" "巡检项目" "巡检状态" "检查结果"
echo "------------------------------------------------------------"

for i in "${!REPORT_ITEMS[@]}"; do

    ITEM="${REPORT_ITEMS[$i]}"
    STATUS="${REPORT_STATUS[$i]}"
    DETAIL="${REPORT_DETAILS[$i]}"

    case "$STATUS" in

        正常)

            SYMBOL="[√ 正常]"
            NORMAL_COUNT=$((NORMAL_COUNT + 1))
            ;;

        警告)

            SYMBOL="[! 警告]"
            WARNING_COUNT=$((WARNING_COUNT + 1))
            ;;

        异常)

            SYMBOL="[X 异常]"
            ERROR_COUNT=$((ERROR_COUNT + 1))
            ;;

        *)

            SYMBOL="[- 未检查]"
            UNKNOWN_COUNT=$((UNKNOWN_COUNT + 1))
            ;;

    esac

    printf "%-20s %-14s %-45.45s\n" \
        "$ITEM" "$SYMBOL" "$DETAIL"

done

TOTAL_COUNT=${#REPORT_ITEMS[@]}

echo "------------------------------------------------------------"

echo
echo "【巡检统计】"

echo "巡检项目总数：$TOTAL_COUNT"
echo "正常项目数量：$NORMAL_COUNT"
echo "警告项目数量：$WARNING_COUNT"
echo "异常项目数量：$ERROR_COUNT"
echo "未检查项目数：$UNKNOWN_COUNT"

echo
echo "【异常及警告项目汇总】"

PROBLEM_COUNT=0

for i in "${!REPORT_ITEMS[@]}"; do

    STATUS="${REPORT_STATUS[$i]}"

    if [ "$STATUS" = "异常" ] || [ "$STATUS" = "警告" ]; then

        echo
        echo "[${STATUS}] ${REPORT_ITEMS[$i]}"
        echo "原因：${REPORT_DETAILS[$i]}"

        PROBLEM_COUNT=$((PROBLEM_COUNT + 1))

    fi

done

if [ "$PROBLEM_COUNT" -eq 0 ]; then
    echo "未发现需要关注的项目"
fi

echo
echo "------------------------------------------------------------"

if [ "$ERROR_COUNT" -gt 0 ] || [ "$UNKNOWN_COUNT" -gt 0 ]; then

    OVERALL_STATUS="异常"
    echo "巡检最终结论：X 异常，存在异常或未完成的检查项目"

elif [ "$WARNING_COUNT" -gt 0 ]; then

    OVERALL_STATUS="警告"
    echo "巡检最终结论：! 警告，存在需要关注的项目"

else

    OVERALL_STATUS="正常"
    echo "巡检最终结论：√ 正常，所有巡检项目通过"

fi

echo
echo "巡检日志文件：$LOG_FILE"
echo "============================================================"
echo "                 巡检任务执行完毕"
echo "============================================================"

# -------------------- 15. 脚本退出状态 -----------------------

if [ "$ERROR_COUNT" -gt 0 ] || [ "$UNKNOWN_COUNT" -gt 0 ]; then
    exit 2
elif [ "$WARNING_COUNT" -gt 0 ]; then
    exit 1
else
    exit 0
fi
