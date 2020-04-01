#!/bin/bash
#
# @brief   List samba db
# @version ver.1.0.0
# @date    Mon Jun 02 13:36:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#

#
# @brief  List samba db
# @param  None
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __smb_list
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
    local FUNC=${FUNCNAME[0]} MSG="None" STATUS
    MSG="List samba"
    info_debug_message "$MSG" "$FUNC" "$SAMBA_MANAGER_TOOL"
    local PDBEDIT=${config_samba_manager_util[PDBEDIT]}
    check_tool "${PDBEDIT}"
    STATUS=$?
    if [ $STATUS -eq $SUCCESS ]; then
        eval "${PDBEDIT} -L -v"
        info_debug_message_end "Done" "$FUNC" "$SAMBA_MANAGER_TOOL"
        return $SUCCESS
    fi 
    MSG="Install tool ${PDBEDIT}"
    info_debug_message "$MSG" "$FUNC" "$SAMBA_MANAGER_TOOL"
    MSG="Force exit!"
    info_debug_message_end "$MSG" "$FUNC" "$SAMBA_MANAGER_TOOL"
    return $NOT_SUCCESS
}

