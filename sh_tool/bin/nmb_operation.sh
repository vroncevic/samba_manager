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

.    ${UTIL}/bin/check_tool.sh

SAMBA_MANAGER_TOOL=samba_manager

declare -A NMB_OPERATION_USAGE=(
    [USAGE_TOOL]="__nmb_operation"
    [USAGE_ARG1]="[OPERATION] start | stop | restart | status | version"
    [USAGE_ARG2]="[TOOL PATH] Tool systemctl path"
    [USAGE_EX_PRE]="# Restart nmb service"
    [USAGE_EX]="__nmb_operation restart"
)

#
# @brief  Run operation with nmb service
# @parmas Values required cmd (start | stop | restart | status) and systemctl path
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __nmb_operation $OP $SYSCTL
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#    # true
#    # notify admin | user
# else
#    # false
#    # return $NOT_SUCCESS
#    # or
#    # exit 128
# fi
#
function __nmb_operation {
    local OP=$1 SYSCTL=$2
    if [[ -z "${OP}" || -z "${SYSCTL}" ]]; then
        usage NMB_OPERATION_USAGE
        return $NOT_SUCCESS
    fi
    local FUNC=${FUNCNAME[0]} MSG="None" STATUS
    check_tool "${SYSCTL}"
    local STATUS=$?
    if [ $STATUS -eq $SUCCESS ]; then
        MSG="Operatoin [${OP}] nmb service"
        info_debug_message "$MSG" "$FUNC" "$SAMBA_MANAGER_TOOL"
        eval "${SYSCTL} ${OP} nmb.service"
        info_debug_message_end "Done" "$FUNC" "$SAMBA_MANAGER_TOOL"
        return $SUCCESS
    fi
    MSG="Missing external tool ${SYSCTL}"
    info_debug_message "$MSG" "$FUNC" "$SAMBA_MANAGER_TOOL"
    MSG="Force exit!"
    info_debug_message_end "$MSG" "$FUNC" "$SAMBA_MANAGER_TOOL"
    return $NOT_SUCCESS
}

