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

declare -A SMB_INFO_USAGE=(
    [USAGE_TOOL]="__smb_info"
    [USAGE_ARG1]="[TOOL PATH] Tool systemctl path"
    [USAGE_EX_PRE]="# Check Samba status"
    [USAGE_EX]="__smb_info \$SMBSTATUS"
)

#
# @brief  Get samba server info
# @param  Required SMB status tool path
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __smbinfo 
# local STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#    # true
#    # notify admin | user
# else
#    # false
#    # return $NOT_SUCCESS
#    # or
#    # exit 128
# fi
#
function __smb_info {
    local SMBSTATUS=$1
    if [ -z "${SMBSTATUS}" ]; then
        usage SMB_INFO_USAGE
        return $NOT_SUCCESS
    fi
    local FUNC=${FUNCNAME[0]} MSG=""
    check_tool "${SMBSTATUS}"
    local STATUS=$?
    if [ $STATUS -eq $SUCCESS ]; then
        eval "${SMBSTATUS} -v"
        return $SUCCESS
    fi
    MSG="Missing external tool ${SMBSTATUS}"
    info_debug_message "$MSG" "$FUNC" "$SAMBA_MANAGER_TOOL"
    MSG="Force exit!"
    info_debug_message_end "$MSG" "$FUNC" "$SAMBA_MANAGER_TOOL"
    return $NOT_SUCCESS
}

