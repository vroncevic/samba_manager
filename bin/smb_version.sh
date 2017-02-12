#!/bin/bash
#
# @brief   Get samba version
# @version ver.1.0
# @date    Mon Jun 02 13:36:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#

#
# @brief  Get samba version
# @param  None
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __smb_version
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
function __smb_version() {
	local FUNC=${FUNCNAME[0]} MSG="None" STATUS
	MSG="Version of samba server"
	__info_debug_message "$MSG" "$FUNC" "$SAMBAMANAGER_TOOL"
	local SMBD=${config_sambamanager_util[SMBD]}
	__check_tool "${SMBD}"
	STATUS=$?
	if [ $STATUS -eq $SUCCESS ]; then
		eval "${SMBD} -V"
		__info_debug_message_end "Done" "$FUNC" "$SAMBAMANAGER_TOOL"
		return $SUCCESS
	fi
	MSG="Install tool ${SMBD}"
	__info_debug_message "$MSG" "$FUNC" "$SAMBAMANAGER_TOOL"
	MSG="Force exit!"
	__info_debug_message_end "$MSG" "$FUNC" "$SAMBAMANAGER_TOOL"
	return $NOT_SUCCESS
}

