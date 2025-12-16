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
    [USAGE_TOOL]="__smb_list"
    [USAGE_ARG1]="[TOOL PATH] Tool pdbedit path"
    [USAGE_EX_PRE]="# Check Samba status"
    [USAGE_EX]="__smb_list \$PDBEDIT"
)

#
# @brief  List samba db
# @param  None
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __smb_list $PDBEDIT
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
function __smb_list {
    local PDBEDIT=$1
    if [ -z "${PDBEDIT}" ]; then
        usage SMB_INFO_USAGE
        return $NOT_SUCCESS
    fi
    local FUNC=${FUNCNAME[0]} MSG="None" STATUS
    MSG="List samba"
    info_debug_message "$MSG" "$FUNC" "$SAMBA_MANAGER_TOOL"
    check_tool "${PDBEDIT}"
    STATUS=$?
    if [ $STATUS -eq $SUCCESS ]; then
        eval "${PDBEDIT} -L -v"
        info_debug_message_end "Done" "$FUNC" "$SAMBA_MANAGER_TOOL"
        return $SUCCESS
    fi 
    MSG="Missing external tool ${PDBEDIT}"
    info_debug_message "$MSG" "$FUNC" "$SAMBA_MANAGER_TOOL"
    MSG="Force exit!"
    info_debug_message_end "$MSG" "$FUNC" "$SAMBA_MANAGER_TOOL"
    return $NOT_SUCCESS
}

