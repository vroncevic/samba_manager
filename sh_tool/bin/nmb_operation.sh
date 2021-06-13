#!/bin/bash
#
# @brief   Run operation with nmb service
# @version ver.1.0
# @date    Mon Jun 02 13:36:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#

declare -A NMB_OPERATION_USAGE=(
    [Usage_TOOL]="__nmb_operation"
    [Usage_ARG1]="[OPERATION] start | stop | restart | status | version"
    [Usage_EX_PRE]="# Restart nmb service"
    [Usage_EX]="__nmb_operation restart"
)

#
# @brief  Run operation with nmb service
# @parm   Value required cmd (start | stop | restart | status)
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __nmb_operation $OP
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
    local OP=$1
    if [ -n "${OP}" ]; then
        local FUNC=${FUNCNAME[0]} MSG="None" STATUS
        local SYSCTL=${config_samba_manager_util[SYSTEMCTL]}
        MSG="Operatoin [${OP}] nmb service"
        info_debug_message "$MSG" "$FUNC" "$SAMBA_MANAGER_TOOL"
        eval "${SYSCTL} ${OP} nmb.service"
        info_debug_message_end "Done" "$FUNC" "$SAMBA_MANAGER_TOOL"
        return $SUCCESS
    fi
    usage NMB_OPERATION_USAGE
    return $NOT_SUCCESS
}

