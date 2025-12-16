#!/bin/bash
#
# @brief   Samba Server Manager
# @version ver.3.0
# @date    Thu 25 Nov 2021 08:28:58 PM CET
# @company None, free software to use 2021
# @author  Vladimir Roncevic <elektron.ronca@gmail.com>
#
UTIL_ROOT=/root/scripts
UTIL_VERSION=ver.1.0
UTIL=${UTIL_ROOT}/sh_util/${UTIL_VERSION}
UTIL_LOG=${UTIL}/log

.    ${UTIL}/bin/check_root.sh
.    ${UTIL}/bin/check_op.sh
.    ${UTIL}/bin/logging.sh
.    ${UTIL}/bin/load_conf.sh
.    ${UTIL}/bin/load_util_conf.sh
.    ${UTIL}/bin/progress_bar.sh
.    ${UTIL}/bin/display_logo.sh

SAMBA_MANAGER_TOOL=samba_manager
SAMBA_MANAGER_VERSION=ver.3.0
SAMBA_MANAGER_HOME=${UTIL_ROOT}/${SAMBA_MANAGER_TOOL}/${SAMBA_MANAGER_VERSION}
SAMBA_MANAGER_CFG_DIR=${SAMBA_MANAGER_HOME}/conf
SAMBA_MANAGER_CFG=${SAMBA_MANAGER_CFG_DIR}/${SAMBA_MANAGER_TOOL}.cfg
SAMBA_MANAGER_UTIL_CFG=${SAMBA_MANAGER_CFG_DIR}/${SAMBA_MANAGER_TOOL}_util.cfg
SAMBA_MANAGER_LOGO=${SAMBA_MANAGER_HOME}/conf/${SAMBA_MANAGER_TOOL}.logo
SAMBA_MANAGER_LOG=${SAMBA_MANAGER_HOME}/log

.    ${SAMBA_MANAGER_HOME}/bin/nmb_operation.sh
.    ${SAMBA_MANAGER_HOME}/bin/smb_operation.sh
.    ${SAMBA_MANAGER_HOME}/bin/winbind_operation.sh
.    ${SAMBA_MANAGER_HOME}/bin/smb_version.sh
.    ${SAMBA_MANAGER_HOME}/bin/smb_info.sh
.    ${SAMBA_MANAGER_HOME}/bin/smb_list.sh

declare -A SAMBA_MANAGER_USAGE=(
    [USAGE_TOOL]="${SAMBA_MANAGER_TOOL}"
    [USAGE_ARG1]="[PR] smb | nmb | winbind | all"
    [USAGE_ARG2]="[OP] start | stop | restart | status | version"
    [USAGE_EX_PRE]="# Restart smb service"
    [USAGE_EX]="${SAMBA_MANAGER_TOOL} smb restart"
)

declare -A SAMBA_MANAGER_LOGGING=(
    [LOG_TOOL]="${SAMBA_MANAGER_TOOL}"
    [LOG_FLAG]="info"
    [LOG_PATH]="${SAMBA_MANAGER_LOG}"
    [LOG_MSGE]="None"
)

declare -A PB_STRUCTURE=(
    [BW]=50
    [MP]=100
    [SLEEP]=0.01
)

declare -A SAMBA_LOGO_DATA=(
    [OWNER]="vroncevic"
    [REPO]="${SAMBA_MANAGER_TOOL}"
    [VERSION]="${SAMBA_MANAGER_VERSION}"
    [LOGO]="${SAMBA_MANAGER_LOGO}"
)

TOOL_DBG="false"
TOOL_LOG="false"
TOOL_NOTIFY="false"

#
# @brief   Main function
# @params  Values required process name and operation
# @exitval Function __smbmanger exit with integer value
#            0   - success operation
#            128 - missing argument(s)
#            129 - failed to load tool script configuration from files
#            130 - wrong second argument
#            131 - failed to process command
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __samba_manager "$PR" "$OP"
#
function __samba_manager {
    local PR=$1 OP=$2
    if [[ -z "${PR}" || -z "${OP}" ]]; then
        usage SAMBA_MANAGER_USAGE
        exit 128
    fi
    display_logo SAMBA_LOGO_DATA
    local FUNC=${FUNCNAME[0]} MSG="None"
    local STATUS_CONF STATUS_CONF_UTIL STATUS
    MSG="Loading basic and util configuration!"
    info_debug_message "$MSG" "$FUNC" "$SAMBA_MANAGER_TOOL"
    progress_bar PB_STRUCTURE
    declare -A config_samba_manager=()
    load_conf "$SAMBA_MANAGER_CFG" config_samba_manager
    STATUS_CONF=$?
    declare -A config_samba_manager_util=()
    load_util_conf "$SAMBA_MANAGER_UTIL_CFG" config_samba_manager_util
    STATUS_CONF_UTIL=$?
    declare -A STATUS_STRUCTURE=([1]=$STATUS_CONF [2]=$STATUS_CONF_UTIL)
    check_status STATUS_STRUCTURE
    STATUS=$?
    if [ $STATUS -eq $NOT_SUCCESS ]; then
        MSG="Force exit!"
        info_debug_message_end "$MSG" "$FUNC" "$SAMBA_MANAGER_TOOL"
        exit 129
    fi
    TOOL_DBG=${config_samba_manager[DEBUGGING]}
    TOOL_LOG=${config_samba_manager[LOGGING]}
    TOOL_NOTIFY=${config_samba_manager[EMAILING]}
    local OPERATIONS=${config_samba_manager_util[SAMBA_OPERATIONS]}
    IFS=' ' read -ra OPS <<< "${OPERATIONS}"
    check_op "${OP}" "${OPS[*]}"
    STATUS=$?
    if [ $STATUS -eq $SUCCESS ]; then
        case "${PR}" in
            "smb")
                local SYSCTL=${config_samba_manager_util[SYSTEMCTL]}
                __smb_operation $OP $SYSCTL
                ;;
            "nmb")
                local SYSCTL=${config_samba_manager_util[SYSTEMCTL]}
                __nmb_operation $OP $SYSCTL
                ;;
            "winbind")
                local SYSCTL=${config_samba_manager_util[SYSTEMCTL]}
                __winbind_operation $OP $SYSCTL
                ;;
            "all")
                MSG="All samba service [${OP}]"
                info_debug_message_end "$MSG" "$FUNC" "$SAMBA_MANAGER_TOOL"
                local SYSCTL=${config_samba_manager_util[SYSTEMCTL]}
                __nmb_operation $OP $SYSCTL
                __smb_operation $OP $SYSCTL
                __winbind_operation $OP $SYSCTL
                ;;
            "info")
                local SMBSTATUS=${config_samba_manager_util[SMBSTATUS]}
                __smb_info $SMBSTATUS
                ;;
            "list")
                local PDBEDIT=${config_samba_manager_util[PDBEDIT]}
                __smb_list $PDBEDIT
                ;;
            "version")
                local SMBD=${config_samba_manager_util[SMBD]}
                __smb_version $SMBD
                ;;
        esac
        STATUS=$?
        if [ $STATUS -eq $NOT_SUCCESS ]; then
            exit 131
        fi
        MSG="Operation: ${OP} with service(s): ${PR} done"
        info_debug_message "$MSG" "$FUNC" "$SAMBA_MANAGER_TOOL"
        SAMBA_MANAGER_LOGGING[LOG_MSGE]=$MSG
        SAMBA_MANAGER_LOGGING[LOG_FLAG]="info"
        logging SAMBA_MANAGER_LOGGING
        info_debug_message_end "Done" "$FUNC" "$SAMBA_MANAGER_TOOL"
        exit 0
    fi
    usage SAMBA_MANAGER_USAGE
    exit 130
}

#
# @brief   Main entry point
# @params  Value required process and operation
# @exitval Script tool smbmanger exit with integer value
#            0   - success operation
#            127 - run as root user
#            128 - missing argument(s)
#            129 - failed to load tool script configuration from files
#            130 - wrong second argument
#            131 - failed to process command
#
printf "\n%s\n%s\n\n" "${SAMBA_MANAGER_TOOL} ${SAMBA_MANAGER_VERSION}" "`date`"
check_root
STATUS=$?
if [ $STATUS -eq $SUCCESS ]; then
    __samba_manager $1 $2
fi

exit 127

