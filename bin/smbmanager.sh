#!/bin/bash
#
# @brief   Samba Server Manager
# @version ver.1.0
# @date    Mon Jun 02 13:36:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#  
UTIL_ROOT=/root/scripts
UTIL_VERSION=ver.1.0
UTIL=$UTIL_ROOT/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/checkroot.sh
. $UTIL/bin/checktool.sh
. $UTIL/bin/checkop.sh
. $UTIL/bin/logging.sh
. $UTIL/bin/usage.sh
. $UTIL/bin/devel.sh

SMBMANAGER_TOOL=smbmanager
SMBMANAGER_VERSION=ver.1.0
SMBMANAGER_HOME=$UTIL_ROOT/$SMBMANAGER_TOOL/$SMBMANAGER_VERSION
SMBMANAGER_CFG=$SMBMANAGER_HOME/conf/$SMBMANAGER_TOOL.cfg
SMBMANAGER_LOG=$SMBMANAGER_HOME/log

declare -A SMBMANAGER_USAGE=(
	[TOOL_NAME]="__$SMBMANAGER_TOOL"
	[ARG1]="[PROCESS]   smb | nmb | winbind | all"
	[ARG2]="[OPERATION] start | stop | restart | status | version"
	[EX-PRE]="# Restart smb service"
	[EX]="__$SMBMANAGER_TOOL smb restart"
)

declare -A LOG=(
	[TOOL]="$SMBMANAGER_TOOL"
	[FLAG]="info"
	[PATH]="$SMBMANAGER_LOG"
	[MSG]=""
)

TOOL_DBG="false"

SYSTEMCTL_PATH="/usr/bin/systemctl"
PDBEDIT="/usr/bin/pdbedit"
SMBSTATUS="/usr/bin/smbstatus"
SMBD="/usr/sbin/smbd"
NMBD="/usr/sbin/nmbd"
WINBINDD="/usr/sbin/winbindd"
SMB_OP_LIST=( start stop restart status version )

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
function __smbversion() {
	local FUNC=${FUNCNAME[0]}
	local MSG=""
	__checktool "$SMBD"
	local STATUS=$?
	if [ "$STATUS" -eq "$SUCCESS" ]; then
		if [ "$TOOL_DBG" == "true" ]; then
			MSG="Version of samba server"
			printf "$DSTA" "$SMBMANAGER_TOOL" "$FUNC" "$MSG"
		fi
		eval "$SMBD -V"
		return $SUCCESS
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
    __checktool "$SMBSTATUS"
    local STATUS=$?
    if [ "$STATUS" -eq "$SUCCESS" ]; then
		if [ "$TOOL_DBG" == "true" ]; then
			MSG="Get samba info"
			printf "$DSTA" "$SMBMANAGER_TOOL" "$FUNC" "$MSG"
		fi
        eval "$SMBSTATUS -v"
        return $SUCCESS
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
    __checktool "$PDBEDIT"
    local STATUS=$?
    if [ "$STATUS" -eq "$SUCCESS" ]; then
		if [ "$TOOL_DBG" == "true" ]; then
			MSG="List samba"
			printf "$DSTA" "$SMBMANAGER_TOOL" "$FUNC" "$MSG"
		fi
        eval "$PDBEDIT -L -v"
        return $SUCCESS
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
		__checktool "$SYSTEMCTL_PATH"
    	local STATUS=$?
		if [ "$STATUS" -eq "$SUCCESS" ]; then
			if [ "$TOOL_DBG" == "true" ]; then
				MSG="smb service [$OPERATION]"
				printf "$DSTA" "$SMBMANAGER_TOOL" "$FUNC" "$MSG"
			fi
		    eval "$SYSTEMCTL_PATH $OPERATION smb.service"
		    return $SUCCESS 
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
		local MSG=""
		__checktool "$SYSTEMCTL_PATH"
    	local STATUS=$?
		if [ "$STATUS" -eq "$SUCCESS" ]; then
			if [ "$TOOL_DBG" == "true" ]; then
				MSG="nmb service [$OPERATION]"
				printf "$DSTA" "$SMBMANAGER_TOOL" "$FUNC" "$MSG"
			fi
		    eval "$SYSTEMCTL_PATH $OPERATION nmb.service"
		    return $SUCCESS 
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
		local MSG=""
		__checktool "$SYSTEMCTL_PATH"
    	local STATUS=$?
		if [ "$STATUS" -eq "$SUCCESS" ]; then
			if [ "$TOOL_DBG" == "true" ]; then
				MSG="winbind service [$OPERATION]"
				printf "$DSTA" "$SMBMANAGER_TOOL" "$FUNC" "$MSG"
			fi
		    eval "$SYSTEMCTL_PATH $OPERATION winbind.service"
		    return $SUCCESS 
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
		local MSG=""
		if [ "$TOOL_DBG" == "true" ]; then
			MSG="Samba Server Manager"
			printf "$DSTA" "$SMBMANAGER_TOOL" "$FUNC" "$MSG"
		fi
        __checkop "$OPERATION" "${SMB_OP_LIST[*]}"
        local STATUS=$?
        if [ "$STATUS" -eq "$SUCCESS" ]; then
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
			if [ "$TOOL_DBG" == "true" ]; then
				printf "$DEND" "$SMBMANAGER_TOOL" "$FUNC" "Done"
			fi
			exit 0 
        fi
		exit 129
    fi 
	__usage $SMBMANAGER_USAGE
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
