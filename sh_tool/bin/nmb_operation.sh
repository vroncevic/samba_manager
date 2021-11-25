#!/bin/bash
#
# @brief   Samba Server Manager
# @version ver.2.0
# @date    Thu 25 Nov 2021 08:28:58 PM CET
# @company None, free software to use 2021
# @author  Vladimir Roncevic <elektron.ronca@gmail.com>
#

declare -A NMB_OPERATION_USAGE=(
    [USAGE_TOOL]="__nmb_operation"
    [USAGE_ARG1]="[OPERATION] start | stop | restart | status | version"
    [USAGE_EX_PRE]="# Restart nmb service"
    [USAGE_EX]="__nmb_operation restart"
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

