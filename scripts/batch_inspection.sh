
#!/bin/bash

# ============================================================
# Linux 批量巡检管理脚本
#
# 功能：
# 1. 多服务器并发巡检
# 2. 混合SSH账号和端口
# 3. 统一SSH私钥认证
# 4. SSH连接重试及超时控制
# 5. 远程脚本分发
# 6. 远程巡检执行
# 7. 自动回收巡检日志
# 8. 生成TXT和CSV汇总报告
#
# 运行环境：Bash 4.3+
# ============================================================


# ==================== 1. 基础配置 ====================

BASE_DIR="/opt/linux_inspection"

SCRIPT_FILE="${BASE_DIR}/scripts/linux_daily_inspection.sh"
HOSTS_FILE="${BASE_DIR}/config/servers.txt"

SSH_KEY="${BASE_DIR}/ssh/linux_inspection"

DATE_TAG=$(date +"%Y%m%d_%H%M%S")
RUN_ID="${DATE_TAG}_$$"

RESULT_DIR="${BASE_DIR}/results/${RUN_ID}"

SUMMARY_FILE="${RESULT_DIR}/summary.txt"
CSV_FILE="${RESULT_DIR}/summary.csv"

STATUS_DIR="${RESULT_DIR}/.status"


# ==================== 2. 执行参数 ====================

# 最大并发数量
MAX_JOBS=10

# SSH连接超时
CONNECT_TIMEOUT=10

# SSH连接重试次数
RETRY_COUNT=2

# 重试间隔
RETRY_INTERVAL=3

# 单台服务器巡检超时时间
EXEC_TIMEOUT=600

# 脚本分发超时时间
TRANSFER_TIMEOUT=60

# 日志下载超时时间
DOWNLOAD_TIMEOUT=120

# 远程临时脚本目录
REMOTE_SCRIPT_DIR="/tmp"

# 远程巡检日志目录
REMOTE_LOG_DIR="/var/log/linux_inspection"


# ==================== 3. 初始化 ====================

mkdir -p "${RESULT_DIR}" "${STATUS_DIR}"

# 检查必要文件
for FILE in "${SCRIPT_FILE}" "${HOSTS_FILE}" "${SSH_KEY}"; do

    if [[ ! -f "${FILE}" ]]; then
        echo "错误：文件不存在：${FILE}"
        exit 1
    fi

done

# 检查必要命令
for CMD in ssh scp timeout awk sort; do

    if ! command -v "${CMD}" >/dev/null 2>&1; then
        echo "错误：缺少命令 ${CMD}"
        exit 1
    fi

done

# 检查Bash版本
if (( BASH_VERSINFO[0] < 4 ||
      (BASH_VERSINFO[0] == 4 && BASH_VERSINFO[1] < 3) )); then

    echo "错误：需要 Bash 4.3 或更高版本"
    exit 1

fi

# 检查私钥权限
if [[ "$(stat -c '%a' "${SSH_KEY}")" != "600" ]]; then
    echo "警告：SSH私钥权限不是600"
    echo "建议执行 chmod 600 ${SSH_KEY}"
fi

# 初始化汇总报告
{
    echo "Linux批量巡检报告"
    echo "执行时间：$(date '+%F %T')"
    echo "最大并发数：${MAX_JOBS}"
    echo "=========================================="
} > "${SUMMARY_FILE}"

echo '"服务器别名","IP地址","SSH账号","执行状态","耗时(秒)","说明"' \
    > "${CSV_FILE}"


# ==================== 4. CSV处理函数 ====================

csv_escape() {

    local VALUE="$1"

    VALUE="${VALUE//\"/\"\"}"

    printf '"%s"' "${VALUE}"

}


# ==================== 5. 单机巡检函数 ====================

run_inspection() {

    local ALIAS="$1"
    local USER="$2"
    local HOST="$3"
    local PORT="$4"

    local TARGET="${USER}@${HOST}"

    local HOST_DIR="${RESULT_DIR}/${ALIAS}"

    local EXEC_LOG="${HOST_DIR}/execution.log"

    local STATUS_FILE="${STATUS_DIR}/${ALIAS}.status"

    local REMOTE_SCRIPT="${REMOTE_SCRIPT_DIR}/inspection_${RUN_ID}_${ALIAS}.sh"

    local REMOTE_LOG=""

    local START_TIME
    START_TIME=$(date +%s)

    local END_TIME
    local COST

    local STATUS="FAILED"
    local MESSAGE="未知错误"

    local EXEC_RC=1
    local DOWNLOAD_OK=0

    local ATTEMPT=0

    mkdir -p "${HOST_DIR}"

    # SSH参数
    local -a SSH_CMD=(
        ssh
        -i "${SSH_KEY}"
        -p "${PORT}"
        -o BatchMode=yes
        -o ConnectTimeout="${CONNECT_TIMEOUT}"
        -o StrictHostKeyChecking=yes
        -o ServerAliveInterval=15
        -o ServerAliveCountMax=2
    )

    # SCP参数
    local -a SCP_CMD=(
        scp
        -i "${SSH_KEY}"
        -P "${PORT}"
        -o BatchMode=yes
        -o ConnectTimeout="${CONNECT_TIMEOUT}"
        -o StrictHostKeyChecking=yes
    )

    {
        echo "=========================================="
        echo "服务器：${ALIAS}"
        echo "IP地址：${HOST}"
        echo "登录账号：${USER}"
        echo "SSH端口：${PORT}"
        echo "开始时间：$(date '+%F %T')"
        echo "=========================================="
    } > "${EXEC_LOG}"

    echo "[INFO] 开始连接服务器 ${HOST}"

    # ---------------- SSH连接测试 ----------------

    while (( ATTEMPT <= RETRY_COUNT )); do

        if timeout 20s "${SSH_CMD[@]}" \
            "${TARGET}" "hostname" \
            >> "${EXEC_LOG}" 2>&1; then

            break

        fi

        ATTEMPT=$((ATTEMPT + 1))

        if (( ATTEMPT > RETRY_COUNT )); then

            MESSAGE="SSH连接失败"
            break

        fi

        echo "[WARN] SSH连接失败，准备第 ${ATTEMPT} 次重试" \
            >> "${EXEC_LOG}"

        sleep "${RETRY_INTERVAL}"

    done

    # ---------------- 开始远程巡检 ----------------

    if (( ATTEMPT <= RETRY_COUNT )); then

        # 生成本次任务唯一标识
        local REMOTE_LOG_MARKER
        REMOTE_LOG_MARKER="inspection_${RUN_ID}_${ALIAS}"

        REMOTE_SCRIPT="${REMOTE_SCRIPT_DIR}/${REMOTE_LOG_MARKER}.sh"

        # 远程巡检日志目录必须存在
        if timeout 20s "${SSH_CMD[@]}" "${TARGET}" \
            "mkdir -p '${REMOTE_LOG_DIR}'" \
            >> "${EXEC_LOG}" 2>&1; then

            # 分发脚本
            echo "[INFO] 正在分发巡检脚本" >> "${EXEC_LOG}"

            if timeout "${TRANSFER_TIMEOUT}s" \
                "${SCP_CMD[@]}" \
                "${SCRIPT_FILE}" \
                "${TARGET}:${REMOTE_SCRIPT}" \
                >> "${EXEC_LOG}" 2>&1; then

                echo "[INFO] 脚本分发成功" >> "${EXEC_LOG}"

                # 记录执行前时间
                local START_EPOCH
                START_EPOCH=$(date +%s)

                # 远程执行命令
                #
                # 通过独立日志名称标识本次巡检。
                # 巡检脚本原本的日志文件仍然保留。
                #
                local REMOTE_CMD

                REMOTE_CMD="
                    export INSPECTION_RUN_ID='${REMOTE_LOG_MARKER}'
                    chmod 700 '${REMOTE_SCRIPT}' &&
                    bash '${REMOTE_SCRIPT}'
                    rc=\$?

                    printf '__INSPECTION_RC__=%s\n' \"\$rc\"

                    find '${REMOTE_LOG_DIR}' \
                        -maxdepth 1 \
                        -type f \
                        -name 'inspection_*.log' \
                        -newermt '@${START_EPOCH}' \
                        -printf '%T@ %p\n' 2>/dev/null |
                        sort -nr |
                        head -n 1 |
                        cut -d ' ' -f 2- |
                        while IFS= read -r logfile; do
                            printf '__INSPECTION_LOG__=%s\n' \"\$logfile\"
                        done

                    exit \"\$rc\"
                "

                echo "[INFO] 开始远程巡检" >> "${EXEC_LOG}"

                timeout \
                    --signal=TERM \
                    --kill-after=10s \
                    "${EXEC_TIMEOUT}s" \
                    "${SSH_CMD[@]}" \
                    "${TARGET}" "${REMOTE_CMD}" \
                    >> "${EXEC_LOG}" 2>&1

                EXEC_RC=$?

                # 提取远程日志路径
                REMOTE_LOG=$(
                    grep '^__INSPECTION_LOG__=' "${EXEC_LOG}" |
                    tail -n 1 |
                    sed 's/^__INSPECTION_LOG__=//'
                )

                # 提取远程退出码
                local REMOTE_RC

                REMOTE_RC=$(
                    grep '^__INSPECTION_RC__=' "${EXEC_LOG}" |
                    tail -n 1 |
                    sed 's/^__INSPECTION_RC__=//'
                )

                # 判断是否超时
                if (( EXEC_RC == 124 || EXEC_RC == 137 )); then

                    STATUS="TIMEOUT"
                    MESSAGE="巡检执行超时"

                elif (( EXEC_RC != 0 )); then

                    STATUS="FAILED"
                    MESSAGE="SSH或远程执行失败，退出码=${EXEC_RC}"

                elif [[ "${REMOTE_RC}" != "0" ]]; then

                    STATUS="FAILED"
                    MESSAGE="远程巡检脚本返回异常退出码"

                elif [[ -z "${REMOTE_LOG}" ]]; then

                    STATUS="DOWNLOAD_FAILED"
                    MESSAGE="没有找到本次巡检日志"

                else

                    # 下载巡检日志
                    echo "[INFO] 正在回收巡检日志" >> "${EXEC_LOG}"

                    if timeout "${DOWNLOAD_TIMEOUT}s" \
                        "${SCP_CMD[@]}" \
                        "${TARGET}:${REMOTE_LOG}" \
                        "${HOST_DIR}/inspection.log" \
                        >> "${EXEC_LOG}" 2>&1; then

                        DOWNLOAD_OK=1

                        STATUS="SUCCESS"
                        MESSAGE="巡检执行成功，日志已回收"

                    else

                        STATUS="DOWNLOAD_FAILED"
                        MESSAGE="巡检日志回收失败"

                    fi

                fi

            else

                STATUS="FAILED"
                MESSAGE="巡检脚本分发失败"

            fi

        else

            STATUS="FAILED"
            MESSAGE="远程日志目录创建失败"

        fi

    fi

    # ---------------- 记录结果 ----------------

    END_TIME=$(date +%s)

    COST=$((END_TIME - START_TIME))

    {
        echo
        echo "巡检状态：${STATUS}"
        echo "巡检说明：${MESSAGE}"
        echo "执行耗时：${COST}秒"
        echo "结束时间：$(date '+%F %T')"
    } >> "${EXEC_LOG}"

    # 写入状态文件
    printf '%s\t%s\t%s\t%s\t%s\t%s\n' \
        "${ALIAS}" \
        "${HOST}" \
        "${USER}" \
        "${STATUS}" \
        "${COST}" \
        "${MESSAGE}" > "${STATUS_FILE}"

    echo "[${STATUS}] ${ALIAS} (${HOST}) 耗时 ${COST}s"

}


# ==================== 6. 并发调度 ====================

echo
echo "=========================================="
echo "开始 Linux 批量巡检"
echo "执行时间：$(date '+%F %T')"
echo "最大并发数：${MAX_JOBS}"
echo "=========================================="
echo

TOTAL=0
INVALID=0

# 逐行读取服务器配置
while IFS=$'\t' read -r ALIAS USER HOST PORT EXTRA ||
      [[ -n "${ALIAS}" ]]; do

    # 去除 Windows 换行符
    ALIAS="${ALIAS%$'\r'}"
    USER="${USER%$'\r'}"
    HOST="${HOST%$'\r'}"
    PORT="${PORT%$'\r'}"

    # 跳过空行和注释
    [[ -z "${ALIAS}" ]] && continue
    [[ "${ALIAS}" =~ ^[[:space:]]*# ]] && continue

    # 检查配置格式
    if [[ -n "${EXTRA}" ||
          -z "${USER}" ||
          -z "${HOST}" ||
          -z "${PORT}" ||
          ! "${PORT}" =~ ^[0-9]+$ ||
          ! "${ALIAS}" =~ ^[a-zA-Z0-9_.-]+$ ||
          ! "${USER}" =~ ^[a-zA-Z0-9_.-]+$ ||
          ! "${HOST}" =~ ^[a-zA-Z0-9_.:-]+$ ]]; then

        echo "[INVALID] 配置格式错误：${ALIAS}"
        INVALID=$((INVALID + 1))
        continue

    fi

    # 避免重复别名覆盖结果
    if [[ -e "${STATUS_DIR}/${ALIAS}.status" ||
          -d "${RESULT_DIR}/${ALIAS}" ]]; then

        echo "[INVALID] 服务器别名重复：${ALIAS}"
        INVALID=$((INVALID + 1))
        continue

    fi

    TOTAL=$((TOTAL + 1))

    # 控制最大并发数
    while (( $(jobs -rp | wc -l) >= MAX_JOBS )); do

        wait -n || true

    done

    # 后台执行
    run_inspection \
        "${ALIAS}" \
        "${USER}" \
        "${HOST}" \
        "${PORT}" &

done < "${HOSTS_FILE}"

# 等待全部后台任务完成
wait


# ==================== 7. 统计巡检结果 ====================

SUCCESS=0
FAILED=0
TIMEOUT=0
DOWNLOAD_FAILED=0

COMPLETED=0

{
    echo
    echo "服务器巡检明细"
    echo "=========================================="
} >> "${SUMMARY_FILE}"

for STATUS_FILE in "${STATUS_DIR}"/*.status; do

    [[ -f "${STATUS_FILE}" ]] || continue

    IFS=$'\t' read -r \
        ALIAS HOST USER STATUS COST MESSAGE \
        < "${STATUS_FILE}"

    COMPLETED=$((COMPLETED + 1))

    printf '%-15s %-18s %-10s %-18s %ss\n' \
        "${ALIAS}" "${HOST}" "${USER}" \
        "${STATUS}" "${COST}" >> "${SUMMARY_FILE}"

    # 生成CSV
    {
        csv_escape "${ALIAS}"
        printf ','
        csv_escape "${HOST}"
        printf ','
        csv_escape "${USER}"
        printf ','
        csv_escape "${STATUS}"
        printf ','
        csv_escape "${COST}"
        printf ','
        csv_escape "${MESSAGE}"
        printf '\n'
    } >> "${CSV_FILE}"

    case "${STATUS}" in

        SUCCESS)
            SUCCESS=$((SUCCESS + 1))
            ;;

        TIMEOUT)
            TIMEOUT=$((TIMEOUT + 1))
            ;;

        DOWNLOAD_FAILED)
            DOWNLOAD_FAILED=$((DOWNLOAD_FAILED + 1))
            ;;

        *)
            FAILED=$((FAILED + 1))
            ;;

    esac

done


# ==================== 8. 输出最终报告 ====================

{
    echo
    echo "=========================================="
    echo "Linux 批量巡检最终统计"
    echo "=========================================="
    echo "计划巡检数量：${TOTAL}"
    echo "已完成任务数：${COMPLETED}"
    echo "执行成功：${SUCCESS}"
    echo "执行失败：${FAILED}"
    echo "执行超时：${TIMEOUT}"
    echo "日志回收失败：${DOWNLOAD_FAILED}"
    echo "配置错误：${INVALID}"
    echo "=========================================="
    echo "巡检结束时间：$(date '+%F %T')"
    echo "结果目录：${RESULT_DIR}"
    echo "TXT报告：${SUMMARY_FILE}"
    echo "CSV报告：${CSV_FILE}"
} >> "${SUMMARY_FILE}"

echo
cat "${SUMMARY_FILE}"

echo
echo "批量巡检任务全部结束"

if (( FAILED > 0 || TIMEOUT > 0 ||
      DOWNLOAD_FAILED > 0 || INVALID > 0 ||
      COMPLETED != TOTAL )); then
    exit 1
fi

exit 0

