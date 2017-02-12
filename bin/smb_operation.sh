#!/bin/bash
#
# @brief   Run operation with smb service
# @version ver.1.0
# @date    Mon Jun 02 13:36:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#

declare -A SMB_OPERATION_USAGE=(
	[USAGE_TOOL]="__smb_operation"
	[USAGE_ARG1]="[OPERATION] start | stop | restart | status | version"
	[USAGE_EX_PRE]="# Restart smb service"
	[USAGE_EX]="__smb_operation restart"
)

#
# @brief  Run operation with smb service
# @parm   Value required cmd (start | stop | restart | status)
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __smb_operation $OP
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#	# true
#	# notify admin | user
# else
#	# false
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __smb_operation() {
	local OP=$1
	if [ -n "${OP}" ]; then
		local FUNC=${FUNCNAME[0]} MSG="None" STATUS
		local SYSCTL=${config_sambamanager_util[SYSTEMCTL]}
		MSG="Operatoin [${OP}] smb service"
		__info_debug_message "$MSG" "$FUNC" "$SAMBAMANAGER_TOOL"
		eval "${SYSCTL} ${OP} smb.service"
		__info_debug_message_end "Done" "$FUNC" "$SAMBAMANAGER_TOOL"
		return $SUCCESS
	fi
	__usage SMB_OPERATION_USAGE
	return $NOT_SUCCESS
}

