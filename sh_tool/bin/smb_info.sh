#!/bin/bash
#
# @brief   Show samba info
# @version ver.1.0
# @date    Mon Jun 02 13:36:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#

#
# @brief  Get samba server info
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
function __smbinfo {
    local FUNC=${FUNCNAME[0]}
    local MSG=""
    checktool "${config_samba_manager_util[SMBSTATUS]}"
    local STATUS=$?
    if [ $STATUS -eq $SUCCESS ]; then
        if [ "$TOOL_DBG" == "true" ]; then
            MSG="Get samba info"
            printf "$DSTA" "$SAMBA_MANAGER_TOOL" "$FUNC" "$MSG"
        fi
        eval "${config_samba_manager_util[SMBSTATUS]} -v"
        return $SUCCESS
    fi
    MSG="Missing external tool ${config_samba_manager_util[SMBSTATUS]}"
    if [ "${config_samba_manager[LOGGING]}" == "true" ]; then
        SAMBA_MANAGER_LOGGING[LOG_MSGE]="$MSG"
        SAMBA_MANAGER_LOGGING[LOG_FLAG]="error"
        logging SAMBA_MANAGER_LOGGING
    fi
    if [ "${config_samba_manager[EMAILING]}" == "true" ]; then
        sendmail "$MSG" "${config_samba_manager[ADMIN_EMAIL]}"
    fi
    return $NOT_SUCCESS
}

