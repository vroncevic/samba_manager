#!/bin/bash
#
# @brief   Samba Server Manager (wrapper)
# @version ver.1.0
# @date    Mon Jun 02 13:36:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#  
UTIL_ROOT=/root/scripts
UTIL_VERSION=ver.1.0
UTIL=$UTIL_ROOT/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/devel.sh
. $UTIL/bin/usage.sh
. $UTIL/bin/checkroot.sh
. $UTIL/bin/checktool.sh
. $UTIL/bin/checkop.sh
. $UTIL/bin/logging.sh
. $UTIL/bin/sendmail.sh
. $UTIL/bin/loadconf.sh
. $UTIL/bin/loadutilconf.sh
. $UTIL/bin/progressbar.sh

SMBMANAGER_TOOL=smbmanager
SMBMANAGER_VERSION=ver.1.0
SMBMANAGER_HOME=$UTIL_ROOT/$SMBMANAGER_TOOL/$SMBMANAGER_VERSION
SMBMANAGER_CFG=$SMBMANAGER_HOME/conf/$SMBMANAGER_TOOL.cfg
SMBMANAGER_UTIL_CFG=$SMBMANAGER_HOME/conf/${SMBMANAGER_TOOL}_util.cfg
SMBMANAGER_LOG=$SMBMANAGER_HOME/log

declare -A SMBMANAGER_USAGE=(
	[USAGE_TOOL]="__$SMBMANAGER_TOOL"
	[USAGE_ARG1]="[PROCESS]   smb | nmb | winbind | all"
	[USAGE_ARG2]="[OPERATION] start | stop | restart | status | version"
	[USAGE_EX_PRE]="# Restart smb service"
	[USAGE_EX]="__$SMBMANAGER_TOOL smb restart"
)

declare -A SMBMANAGER_LOG=(
	[LOG_TOOL]="$SMBMANAGER_TOOL"
	[LOG_FLAG]="info"
	[LOG_PATH]="$SMBMANAGER_LOG"
	[LOG_MSGE]="None"
)

declare -A PB_STRUCTURE=(
	[BAR_WIDTH]=50
	[MAX_PERCENT]=100
	[SLEEP]=0.01
)

TOOL_DBG="false"

#
# @brief  Get samba version
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __smbversion 
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
function __smbversion() {
	local FUNC=${FUNCNAME[0]}
	local MSG="None"
	__checktool "${configsmbmanagerutil[SMBD]}"
	local STATUS=$?
	if [ $STATUS -eq $SUCCESS ]; then
		if [ "$TOOL_DBG" == "true" ]; then
			MSG="Version of samba server"
			printf "$DSTA" "$SMBMANAGER_TOOL" "$FUNC" "$MSG"
		fi
		eval "${configsmbmanagerutil[SMBD]} -V"
		return $SUCCESS
	fi
	MSG="Missing external tool ${configsmbmanagerutil[SMBD]}"
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

#
# @brief  List samba db
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __smblist
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
function __smblist() {
	local FUNC=${FUNCNAME[0]}
	local MSG=""
    __checktool "${configsmbmanagerutil[PDBEDIT]}"
    local STATUS=$?
    if [ $STATUS -eq $SUCCESS ]; then
		if [ "$TOOL_DBG" == "true" ]; then
			MSG="List samba"
			printf "$DSTA" "$SMBMANAGER_TOOL" "$FUNC" "$MSG"
		fi
        eval "${configsmbmanagerutil[PDBEDIT]} -L -v"
        return $SUCCESS
    fi 
	MSG="Missing external tool ${configsmbmanagerutil[PDBEDIT]}"
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

#
# @brief  Run operation with smb service
# @parm   Value required cmd (start | stop | restart | status)
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __smboperation $OPERATION
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
function __smboperation() {
    local OPERATION=$1
    if [ -n "$OPERATION" ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG=""
		__checktool "${configsmbmanagerutil[SYSTEMCTL]}"
    	local STATUS=$?
		if [ $STATUS -eq $SUCCESS ]; then
			if [ "$TOOL_DBG" == "true" ]; then
				MSG="smb service [$OPERATION]"
				printf "$DSTA" "$SMBMANAGER_TOOL" "$FUNC" "$MSG"
			fi
		    eval "${configsmbmanagerutil[SYSTEMCTL]} $OPERATION smb.service"
		    return $SUCCESS 
		fi
		MSG="Missing external tool ${configsmbmanagerutil[SYSTEMCTL]}"
		if [ "${configsmbmanager[LOGGING]}" == "true" ]; then
			OSSL_LOGGING[LOG_MSGE]="$MSG"
			OSSL_LOGGING[LOG_FLAG]="error"
			__logging OSSL_LOGGING
		fi
		if [ "${configsmbmanager[EMAILING]}" == "true" ]; then
			__sendmail "$MSG" "${configsmbmanager[ADMIN_EMAIL]}"
		fi
		return $NOT_SUCCESS
    fi 
    return $NOT_SUCCESS
}

#
# @brief  Run operation with nmb service
# @parm   Value required cmd (start | stop | restart | status)
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __nmboperation $OPERATION
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
function __nmboperation() {
    local OPERATION=$1
    if [ -n "$OPERATION" ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG="None"
		__checktool "${configsmbmanagerutil[SYSTEMCTL]}"
    	local STATUS=$?
		if [ $STATUS -eq $SUCCESS ]; then
			if [ "$TOOL_DBG" == "true" ]; then
				MSG="nmb service [$OPERATION]"
				printf "$DSTA" "$SMBMANAGER_TOOL" "$FUNC" "$MSG"
			fi
		    eval "${configsmbmanagerutil[SYSTEMCTL]} $OPERATION nmb.service"
		    return $SUCCESS 
		fi
		MSG="Missing external tool ${configsmbmanagerutil[SYSTEMCTL]}"
		if [ "${configsmbmanager[LOGGING]}" == "true" ]; then
			OSSL_LOGGING[LOG_MSGE]="$MSG"
			OSSL_LOGGING[LOG_FLAG]="error"
			__logging OSSL_LOGGING
		fi
		if [ "${configsmbmanager[EMAILING]}" == "true" ]; then
			__sendmail "$MSG" "${configsmbmanager[ADMIN_EMAIL]}"
		fi
		return $NOT_SUCCESS
    fi 
    return $NOT_SUCCESS
}

#
# @brief  Run operation with winbind service
# @parm   Value required cmd (start | stop | restart | status)
# @retval Success return 0, else return 1 
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __winbindoperation $OPERATION
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
function __winbindoperation() {
    local OPERATION=$1
    if [ -n "$OPERATION" ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG="None"
		__checktool "${configsmbmanagerutil[SYSTEMCTL]}"
    	local STATUS=$?
		if [ $STATUS -eq $SUCCESS ]; then
			if [ "$TOOL_DBG" == "true" ]; then
				MSG="winbind service [$OPERATION]"
				printf "$DSTA" "$SMBMANAGER_TOOL" "$FUNC" "$MSG"
			fi
		    eval "${configsmbmanagerutil[SYSTEMCTL]} $OPERATION winbind.service"
		    return $SUCCESS 
		fi
		MSG="Missing external tool ${configsmbmanagerutil[SYSTEMCTL]}"
		if [ "${configsmbmanager[LOGGING]}" == "true" ]; then
			OSSL_LOGGING[LOG_MSGE]="$MSG"
			OSSL_LOGGING[LOG_FLAG]="error"
			__logging OSSL_LOGGING
		fi
		if [ "${configsmbmanager[EMAILING]}" == "true" ]; then
			__sendmail "$MSG" "${configsmbmanager[ADMIN_EMAIL]}"
		fi
		return $NOT_SUCCESS
    fi 
    return $NOT_SUCCESS
}

#
# @brief   Main function 
# @params  Values required process name and operation
# @exitval Function __smbmanger exit with integer value
#			0   - success operation 
#			128 - missing argument(s)
#			129 - wrong second argument
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __smbmanager "$PROCESS" "$OPERATION"
#
function __smbmanager() {
    local PROCESS=$1
    local OPERATION=$2
    if [ -n "$PROCESS" ] && [ -n "$OPERATION" ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG="Loading basic and util configuration"
		printf "$SEND" "$SMBMANAGER_TOOL" "$MSG"
		__progressbar PB_STRUCTURE
		printf "%s\n\n" ""
		declare -A configsmbmanager=()
		__loadconf $SMBMANAGER_CFG configsmbmanager
		local STATUS=$?
		if [ $STATUS -eq $NOT_SUCCESS ]; then
			MSG="Failed to load tool script configuration"
			if [ "$TOOL_DBG" == "true" ]; then
				printf "$DSTA" "$SMBMANAGER_TOOL" "$FUNC" "$MSG"
			else
				printf "$SEND" "$SMBMANAGER_TOOL" "$MSG"
			fi
			exit 129
		fi
		declare -A configsmbmanagerutil=()
		__loadutilconf $SMBMANAGER_UTIL_CFG configsmbmanagerutil
		STATUS=$?
		if [ $STATUS -eq $NOT_SUCCESS ]; then
			MSG="Failed to load tool script utilities configuration"
			if [ "$TOOL_DBG" == "true" ]; then
				printf "$DSTA" "$SMBMANAGER_TOOL" "$FUNC" "$MSG"
			else
				printf "$SEND" "$SMBMANAGER_TOOL" "$MSG"
			fi
			exit 130
		fi
		if [ "$TOOL_DBG" == "true" ]; then
			MSG="Samba Server Manager"
			printf "$DSTA" "$SMBMANAGER_TOOL" "$FUNC" "$MSG"
		fi
		SMB_OP_LIST=( start stop restart status version )
        __checkop "$OPERATION" "${SMB_OP_LIST[*]}"
        local STATUS=$?
        if [ $STATUS -eq $SUCCESS ]; then
            case "$PROCESS" in
                "smb")
		                    __smboperation $OPERATION
		                    ;;
                "nmb")
		                    __nmboperation $OPERATION
		                    ;;
                "winbind")
		                    __winbindoperation $OPERATION 
		                    ;;
                "all")
		                    if [ "$TOOL_DBG" == "true" ]; then
		                    	MSG="All samba service [$OPERATION]"
								printf "$DSTA" "$SMBMANAGER_TOOL" "$FUNC" "$MSG"
		                    fi
		                    __nmboperation $OPERATION
		                    __smboperation $OPERATION
		                    __winbindoperation $OPERATION
		                    ;;
                "info")
		                    __smbinfo
		                    ;;
                "list")
		                    __smblist
							;;
				"version")
							__smbversion
							;;
            esac
			MSG="Operation: $OPERATION with service(s): $PROCESS done"
			if [ "${configsmbmanager[LOGGING]}" == "true" ]; then
				OSSL_LOGGING[LOG_MSGE]="$MSG"
				OSSL_LOGGING[LOG_FLAG]="info"
				__logging OSSL_LOGGING
			fi
			if [ "$TOOL_DBG" == "true" ]; then
				printf "$DEND" "$SMBMANAGER_TOOL" "$FUNC" "Done"
			fi
			exit 0 
        fi
		exit 129
    fi 
	__usage SMBMANAGER_USAGE
	exit 128
}

#
# @brief   Main entry point
# @params  Value required process and operation
# @exitval Script tool smbmanger exit with integer value
#			0   - success operation 
# 			127 - run as root user
#			128 - missing argument(s)
#			129 - wrong second argument
#
printf "\n%s\n%s\n\n" "$SMBMANAGER_TOOL $SMBMANAGER_VERSION" "`date`"
__checkroot
STATUS=$?
if [ "$STATUS" -eq "$SUCCESS" ]; then
	__smbmanager $1 $2
fi

exit 127

