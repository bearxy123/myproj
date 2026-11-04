
#!/bin/bash

# ============================================================
# Linux SSH公钥批量分发脚本
#
# 功能：
# 1. 自动检查SSH密钥
# 2. 支持混合SSH账号
# 3. 支持不同SSH端口
# 4. 并发分发公钥
# 5. SSH密码认证重试
# 6. 自动配置authorized_keys
# 7. 验证免密登录
# 8. 生成TXT和CSV报告
#
# 运行环境：Bash 4.3+
# ============================================================


# ==================== 1. 基础配置 ====================

BASE_DIR="/opt/linux_inspection"

HOSTS_FILE="${BASE_DIR}/config/servers.txt"

SSH_DIR="${BASE_DIR}/ssh"

PRIVATE_KEY="${SSH_DIR}/linux_inspection"

PUBLIC_KEY="${SSH_DIR}/linux_inspection.pub"

DATE_TAG=$(date +"%Y%m%d_%H%M%S")

RESULT_DIR="${BASE_DIR}/results/deploy/${DATE_TAG}"

SUMMARY_FILE="${RESULT_DIR}/summary.txt"

CSV_FILE="${RESULT_DIR}/summary.csv"

STATUS_DIR="${RESULT_DIR}/.status"


# ==================== 2. 执行参数 ====================

# 最大并发数量
MAX_JOBS=5

# SSH连接超时
CONNECT_TIMEOUT=10

# 公钥分发超时
DEPLOY_TIMEOUT=60

# 免密验证超时
VERIFY_TIMEOUT=20

# 失败重试次数
RETRY_COUNT=2

# 重试间隔
RETRY_INTERVAL=3

# 是否自动生成密钥
AUTO_GENERATE_KEY=true

# 是否允许首次连接自动接受主机密钥
# 生产环境建议 false，预先核验known_hosts
TRUST_NEW_HOST=false


# ==================== 3. 初始化 ====================

mkdir -p "${RESULT_DIR}" "${STATUS_DIR}" "${SSH_DIR}"

# 检查必要命令
for CMD in ssh ssh-keygen timeout ssh-keyscan; do

    if ! command -v "${CMD}" >/dev/null 2>&1; then
        echo "错误：缺少命令 ${CMD}"
        exit 1
    fi

done

if [[ ! -f "${HOSTS_FILE}" ]]; then
    echo "错误：服务器配置文件不存在"
    exit 1
fi

# 自动生成密钥对
if [[ ! -f "${PRIVATE_KEY}" || ! -f "${PUBLIC_KEY}" ]]; then

    if [[ "${AUTO_GENERATE_KEY}" != "true" ]]; then
        echo "错误：SSH密钥不存在"
        exit 1
    fi

    echo "正在生成SSH密钥对..."

    if [[ -e "${PRIVATE_KEY}" || -e "${PUBLIC_KEY}" ]]; then
        echo "错误：检测到密钥文件不完整，请先检查现有密钥"
        exit 1
    fi

    ssh-keygen -q -t ed25519 \
        -N "" \
        -f "${PRIVATE_KEY}" \
        -C "linux-inspection"

fi

chmod 700 "${SSH_DIR}"
chmod 600 "${PRIVATE_KEY}"
chmod 644 "${PUBLIC_KEY}"

# 验证公钥与私钥是否匹配
PRIVATE_FP=$(ssh-keygen -y -f "${PRIVATE_KEY}" |
    ssh-keygen -lf /dev/stdin 2>/dev/null | awk '{print $2}')

PUBLIC_FP=$(ssh-keygen -lf "${PUBLIC_KEY}" 2>/dev/null |
    awk '{print $2}')

if [[ -z "${PRIVATE_FP}" || "${PRIVATE_FP}" != "${PUBLIC_FP}" ]]; then
    echo "错误：公钥与私钥不匹配"
    exit 1
fi

# 初始化报告
echo '"服务器","IP","账号","端口","分发状态","验证状态","说明"' \
    > "${CSV_FILE}"

{
    echo "Linux SSH公钥分发报告"
    echo "执行时间：$(date '+%F %T')"
    echo "公钥指纹：${PUBLIC_FP}"
    echo "========================================"
} > "${SUMMARY_FILE}"


# ==================== 4. CSV处理函数 ====================

csv_escape() {

    local VALUE="$1"

    VALUE="${VALUE//\"/\"\"}"

    printf '"%s"' "${VALUE}"

}


# ==================== 5. 单机公钥部署函数 ====================

deploy_key() {

    local ALIAS="$1"
    local USER="$2"
    local HOST="$3"
    local PORT="$4"

    local TARGET="${USER}@${HOST}"

    local HOST_DIR="${RESULT_DIR}/${ALIAS}"

    local LOG_FILE="${HOST_DIR}/deploy.log"

    local STATUS_FILE="${STATUS_DIR}/${ALIAS}.status"

    local DEPLOY_STATUS="FAILED"
    local VERIFY_STATUS="FAILED"

    local MESSAGE="未知错误"

    local ATTEMPT=0
    local CONNECT_OK=0

    mkdir -p "${HOST_DIR}"

    # SSH主机密钥策略
    local HOST_KEY_OPTION="yes"

    if [[ "${TRUST_NEW_HOST}" == "true" ]]; then
        HOST_KEY_OPTION="accept-new"
    fi

    local -a SSH_CMD=(
        ssh
        -p "${PORT}"
        -o ConnectTimeout="${CONNECT_TIMEOUT}"
        -o StrictHostKeyChecking="${HOST_KEY_OPTION}"
        -o PreferredAuthentications=publickey,password,keyboard-interactive
        -o PubkeyAuthentication=yes
        -o NumberOfPasswordPrompts=1
    )

    local -a SSH_COPY_CMD=(
        ssh-copy-id
        -i "${PUBLIC_KEY}"
        -p "${PORT}"
        -o ConnectTimeout="${CONNECT_TIMEOUT}"
        -o StrictHostKeyChecking="${HOST_KEY_OPTION}"
        -o PreferredAuthentications=publickey,password,keyboard-interactive
        -o PubkeyAuthentication=yes
        -o NumberOfPasswordPrompts=1
    )

    {
        echo "服务器：${ALIAS}"
        echo "IP地址：${HOST}"
        echo "账号：${USER}"
        echo "端口：${PORT}"
        echo "开始时间：$(date '+%F %T')"
        echo "========================================"
    } > "${LOG_FILE}"

    echo "[INFO] 开始部署：${TARGET}:${PORT}"

    # 1. 测试原有登录方式
    # 首次部署需要通过密码或已有密钥认证
    while (( ATTEMPT <= RETRY_COUNT )); do

        if timeout "${CONNECT_TIMEOUT}s" \
            "${SSH_CMD[@]}" \
            "${TARGET}" "hostname" \
            >> "${LOG_FILE}" 2>&1; then

            CONNECT_OK=1
            break

        fi

        ATTEMPT=$((ATTEMPT + 1))

        if (( ATTEMPT > RETRY_COUNT )); then
            MESSAGE="无法通过现有认证方式登录"
            break
        fi

        echo "[WARN] 登录失败，准备重试 ${ATTEMPT}" \
            >> "${LOG_FILE}"

        sleep "${RETRY_INTERVAL}"

    done

    if (( CONNECT_OK == 1 )); then

        # 2. 分发公钥
        ATTEMPT=0

        while (( ATTEMPT <= RETRY_COUNT )); do

            echo "[INFO] 正在分发公钥" >> "${LOG_FILE}"

            if timeout "${DEPLOY_TIMEOUT}s" \
                "${SSH_COPY_CMD[@]}" \
                "${TARGET}" \
                >> "${LOG_FILE}" 2>&1; then

                DEPLOY_STATUS="SUCCESS"
                break

            fi

            ATTEMPT=$((ATTEMPT + 1))

            if (( ATTEMPT > RETRY_COUNT )); then
                MESSAGE="公钥分发失败"
                break
            fi

            sleep "${RETRY_INTERVAL}"

        done

        # 3. 使用专用私钥验证免密登录
        if [[ "${DEPLOY_STATUS}" == "SUCCESS" ]]; then

            echo "[INFO] 正在验证免密登录" >> "${LOG_FILE}"

            if timeout "${VERIFY_TIMEOUT}s" \
                ssh -i "${PRIVATE_KEY}" \
                -p "${PORT}" \
                -o BatchMode=yes \
                -o IdentitiesOnly=yes \
                -o ConnectTimeout="${CONNECT_TIMEOUT}" \
                -o StrictHostKeyChecking=yes \
                "${TARGET}" "hostname" \
                >> "${LOG_FILE}" 2>&1; then

                VERIFY_STATUS="SUCCESS"
                MESSAGE="公钥部署成功，免密登录验证通过"

            else

                VERIFY_STATUS="FAILED"
                MESSAGE="公钥已分发，但免密验证失败"

            fi

        fi

    fi

    # 4. 记录结果
    printf '%s\t%s\t%s\t%s\t%s\t%s\n' \
        "${ALIAS}" \
        "${HOST}" \
        "${USER}" \
        "${DEPLOY_STATUS}" \
        "${VERIFY_STATUS}" \
        "${MESSAGE}" > "${STATUS_FILE}"

    echo "[${VERIFY_STATUS}] ${ALIAS} (${HOST}) ${MESSAGE}"

}


# ==================== 6. 并发分发 ====================

TOTAL=0
INVALID=0

echo
echo "========================================"
echo "开始批量分发SSH公钥"
echo "最大并发数：${MAX_JOBS}"
echo "========================================"
echo

while IFS=$'\t' read -r ALIAS USER HOST PORT EXTRA ||
      [[ -n "${ALIAS}" ]]; do

    ALIAS="${ALIAS%$'\r'}"
    USER="${USER%$'\r'}"
    HOST="${HOST%$'\r'}"
    PORT="${PORT%$'\r'}"

    [[ -z "${ALIAS}" ]] && continue
    [[ "${ALIAS}" =~ ^[[:space:]]*# ]] && continue

    # 检查配置
    if [[ -n "${EXTRA}" ||
          -z "${USER}" ||
          -z "${HOST}" ||
          -z "${PORT}" ||
          ! "${PORT}" =~ ^[0-9]+$ ||
          ! "${ALIAS}" =~ ^[a-zA-Z0-9_.-]+$ ||
          ! "${USER}" =~ ^[a-zA-Z0-9_.-]+$ ||
          ! "${HOST}" =~ ^[a-zA-Z0-9_.:-]+$ ]]; then

        echo "[INVALID] 配置错误：${ALIAS}"
        INVALID=$((INVALID + 1))
        continue

    fi

    # 检查重复别名
    if [[ -e "${STATUS_DIR}/${ALIAS}.status" ||
          -d "${RESULT_DIR}/${ALIAS}" ]]; then

        echo "[INVALID] 别名重复：${ALIAS}"
        INVALID=$((INVALID + 1))
        continue

    fi

    TOTAL=$((TOTAL + 1))

    # 控制并发
    while (( $(jobs -rp | wc -l) >= MAX_JOBS )); do
        wait -n || true
    done

    deploy_key "${ALIAS}" "${USER}" "${HOST}" "${PORT}" &

done < "${HOSTS_FILE}"

# 等待所有任务完成
wait


# ==================== 7. 生成汇总报告 ====================

SUCCESS=0
FAILED=0
COMPLETED=0

{
    echo
    echo "服务器部署明细"
    echo "========================================"
} >> "${SUMMARY_FILE}"

for STATUS_FILE in "${STATUS_DIR}"/*.status; do

    [[ -f "${STATUS_FILE}" ]] || continue

    IFS=$'\t' read -r \
        ALIAS HOST USER DEPLOY_STATUS VERIFY_STATUS MESSAGE \
        < "${STATUS_FILE}"

    COMPLETED=$((COMPLETED + 1))

    printf '%-15s %-18s %-10s %-12s %-12s\n' \
        "${ALIAS}" "${HOST}" "${USER}" \
        "${DEPLOY_STATUS}" "${VERIFY_STATUS}" \
        >> "${SUMMARY_FILE}"

    {
        csv_escape "${ALIAS}"
        printf ','
        csv_escape "${HOST}"
        printf ','
        csv_escape "${USER}"
        printf ','
        csv_escape "${PORT:-}"
        printf ','
        csv_escape "${DEPLOY_STATUS}"
        printf ','
        csv_escape "${VERIFY_STATUS}"
        printf ','
        csv_escape "${MESSAGE}"
        printf '\n'
    } >> "${CSV_FILE}"

    if [[ "${DEPLOY_STATUS}" == "SUCCESS" &&
          "${VERIFY_STATUS}" == "SUCCESS" ]]; then

        SUCCESS=$((SUCCESS + 1))

    else

        FAILED=$((FAILED + 1))

    fi

done

{
    echo
    echo "========================================"
    echo "计划部署数量：${TOTAL}"
    echo "已完成任务：${COMPLETED}"
    echo "部署及验证成功：${SUCCESS}"
    echo "失败：${FAILED}"
    echo "配置错误：${INVALID}"
    echo "公钥指纹：${PUBLIC_FP}"
    echo "========================================"
    echo "TXT报告：${SUMMARY_FILE}"
    echo "CSV报告：${CSV_FILE}"
} >> "${SUMMARY_FILE}"

echo
cat "${SUMMARY_FILE}"

if (( FAILED > 0 || INVALID > 0 || COMPLETED != TOTAL )); then
    exit 1
fi

exit 0

