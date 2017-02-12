

#
# @brief  Get samba server info
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __smbinfo 
# local STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#	# true
#	# notify admin | user
# else
#	# false
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __smbinfo() {
	local FUNC=${FUNCNAME[0]}
	local MSG=""
    __checktool "${configsmbmanagerutil[SMBSTATUS]}"
    local STATUS=$?
    if [ $STATUS -eq $SUCCESS ]; then
		if [ "$TOOL_DBG" == "true" ]; then
			MSG="Get samba info"
			printf "$DSTA" "$SMBMANAGER_TOOL" "$FUNC" "$MSG"
		fi
        eval "${configsmbmanagerutil[SMBSTATUS]} -v"
        return $SUCCESS
    fi
	MSG="Missing external tool ${configsmbmanagerutil[SMBSTATUS]}"
	if [ "${configsmbmanager[LOGGING]}" == "true" ]; then
		OSSL_LOGGING[LOG_MSGE]="$MSG"
		OSSL_LOGGING[LOG_FLAG]="error"
		__logging OSSL_LOGGING
	fi
	if [ "${configsmbmanager[EMAILING]}" == "true" ]; then
		__sendmail "$MSG" "${configsmbmanager[ADMIN_EMAIL]}"
	fi
	return $NOT_SUCCESS
}

