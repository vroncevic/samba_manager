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

declare -A SMB_VERSION_USAGE=(
    [USAGE_TOOL]="__smb_version"
    [USAGE_ARG1]="[TOOL PATH] Tool SMBD path"
    [USAGE_EX_PRE]="# Check Samba status"
    [USAGE_EX]="__smb_version \$SMBD"
)

#
# @brief  Get samba version
# @param  Required SMBD tool path
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __smb_version $SMBD
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
function __smb_version {
    local SMBD=$1
    if [ -z "${SMBD}" ]; then
        usage SMB_VERSION_USAGE
        return $NOT_SUCCESS
    fi
    local FUNC=${FUNCNAME[0]} MSG="None" STATUS
    MSG="Version of samba server"
    info_debug_message "$MSG" "$FUNC" "$SAMBA_MANAGER_TOOL"
    check_tool "${SMBD}"
    STATUS=$?
    if [ $STATUS -eq $SUCCESS ]; then
        eval "${SMBD} -V"
        info_debug_message_end "Done" "$FUNC" "$SAMBA_MANAGER_TOOL"
        return $SUCCESS
    fi
    MSG="Missing external tool ${SMBD}"
    info_debug_message "$MSG" "$FUNC" "$SAMBA_MANAGER_TOOL"
    MSG="Force exit!"
    info_debug_message_end "$MSG" "$FUNC" "$SAMBA_MANAGER_TOOL"
    return $NOT_SUCCESS
}

