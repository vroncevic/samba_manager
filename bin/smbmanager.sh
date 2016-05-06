#!/bin/bash
#
# @brief   Samba Server Management
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

TOOL_NAME=smbmanager
TOOL_VERSION=ver.1.0
TOOL_HOME=$UTIL_ROOT/$TOOL_NAME/$TOOL_VERSION
TOOL_CFG=$TOOL_HOME/conf/$TOOL_NAME.cfg
TOOL_LOG=$TOOL_HOME/log

declare -A SMBMANAGER_USAGE=(
	[TOOL_NAME]="__$TOOL_NAME"
	[ARG1]="[PROCESS]   smb | nmb | winbind | all"
	[ARG2]="[OPERATION] start | stop | restart | status | version"
	[EX-PRE]="# Restart smb service"
	[EX]="__$TOOL_NAME smb restart"	
)

declare -A LOG=(
	[TOOL]="$TOOL_NAME"
	[FLAG]="info"
	[PATH]="$TOOL_LOG"
	[MSG]=""
)

SYSTEMCTL="/usr/bin/systemctl"
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
# STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#	# true
# else
#	# false
# fi
#
function __smbversion() {
	__checktool "$SMBD"
	STATUS=$?
	if [ "$STATUS" -eq "$SUCCESS" ]; then
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n" "CMD: $SMBD -V"
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
# STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#	# true
# else
#	# false
# fi
#
function __smbinfo() {
    __checktool "$SMBSTATUS"
    STATUS=$?
    if [ "$STATUS" -eq "$SUCCESS" ]; then
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n" "CMD: $SMBSTATUS -v"
		fi
        eval "$SMBSTATUS -v"
        return $SUCCESS
    else 
        return $NOT_SUCCESS
    fi
}

#
# @brief  List samba db
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __smblist
# STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#	# true
# else
#	# false
# fi
#
function __smblist() {
    __checktool "$PDBEDIT"
    STATUS=$?
    if [ "$STATUS" -eq "$SUCCESS" ]; then
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n" "CMD: $PDBEDIT -L -v"
		fi
        eval "$PDBEDIT -L -v"
        return $SUCCESS
    else 
        return $NOT_SUCCESS
    fi
}

#
# @brief  Run operation with smb service
# @param  Value required operation to be done
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __smboperation "$OPERATION"
# STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#	# true
# else
#	# false
# fi
#
function __smboperation() {
    OPERATION=$1
    if [ -n "$OPERATION" ]; then
		__checktool "$SYSTEMCTL"
    	STATUS=$?
		if [ "$STATUS" -eq "$SUCCESS" ]; then
			if [ "$TOOL_DEBUG" == "true" ]; then
				printf "%s\n" "CMD: $SYSTEMCTL $OPERATION smb.service"
			fi
		    eval "$SYSTEMCTL $OPERATION smb.service"
		    return $SUCCESS 
		fi
		return $NOT_SUCCESS
    fi 
    return $NOT_SUCCESS
}

#
# @brief  Run operation with nmb service
# @param  Value required operation to be done
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __nmboperation "$OPERATION"
# STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#	# true
# else
#	# false
# fi
#
function __nmboperation() {
    OPERATION=$1
    if [ -n "$OPERATION" ]; then
		__checktool "$SYSTEMCTL"
    	STATUS=$?
		if [ "$STATUS" -eq "$SUCCESS" ]; then
			if [ "$TOOL_DEBUG" == "true" ]; then
				printf "%s\n" "CMD: $SYSTEMCTL $OPERATION nmb.service"
			fi
		    eval "$SYSTEMCTL $OPERATION nmb.service"
		    return $SUCCESS 
		fi
		return $NOT_SUCCESS
    fi 
    return $NOT_SUCCESS
}

#
# @brief  Run operation with winbind service
# @param  Value required operation to be done
# @retval Success return 0, else return 1 
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __winbindoperation "$OPERATION"
# STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#	# true
# else
#	# false
# fi
#
function __winbindoperation() {
    OPERATION=$1
    if [ -n "$OPERATION" ]; then
		__checktool "$SYSTEMCTL"
    	STATUS=$?
		if [ "$STATUS" -eq "$SUCCESS" ]; then
			if [ "$TOOL_DEBUG" == "true" ]; then
				printf "%s\n" "CMD: $SYSTEMCTL $OPERATION winbind.service"
			fi
		    eval "$SYSTEMCTL $OPERATION winbind.service"
		    return $SUCCESS 
		fi
		return $NOT_SUCCESS
    fi 
    return $NOT_SUCCESS
}

#
# @brief  Main function 
# @params Values required process name and operation
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __smbmanager "$PROCESS" "$OPERATION"
#
function __smbmanager() {
    PROCESS=$1
    OPERATION=$2
    if [ -n "$PROCESS" ] && [ -n "$OPERATION" ]; then
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n" "[Samba Server Manager]"
		fi
        __checkop "$OPERATION" "${SMB_OP_LIST[*]}"
        STATUS=$?
        if [ "$STATUS" -eq "$SUCCESS" ]; then
            case "$PROCESS" in
                "smb") 		
                    if [ "$TOOL_DEBUG" == "true" ]; then
                    	printf "%\n" "$OPERATION smb service"
                    fi
                    __smboperation "$OPERATION"
                    ;;
                "nmb")	    
                    if [ "$TOOL_DEBUG" == "true" ]; then
                    	printf "%\n" "$OPERATION nmb service"
                    fi
                    __nmboperation "$OPERATION"
                    ;;
                "winbind")	
                    if [ "$TOOL_DEBUG" == "true" ]; then
                    	printf "%\n" "$OPERATION winbind service"
                    fi
                    __winbindoperation "$OPERATION" 
                    ;;
                "all") 		
                    if [ "$TOOL_DEBUG" == "true" ]; then
                    	printf "%\n" "$OPERATION all samba service"
                    fi
                    __nmboperation "$OPERATION"
                    __smboperation "$OPERATION"
                    __winbindoperation "$OPERATION"
                    ;;
                "info")		
                    if [ "$TOOL_DEBUG" == "true" ]; then
                    	printf "%\n" "Get samba info"
                    fi
                    __smbinfo
                    ;;
                "list")     
                    if [ "$TOOL_DEBUG" == "true" ]; then
                    	printf "%\n" "List samba"
                    fi
                    __smblist
					;;
				"version")
					if [ "$TOOL_DEBUG" == "true" ]; then
						printf "%s\n" "Version of samba server"
					fi
					__smbversion
					;;
            esac
			if [ "$TOOL_DEBUG" == "true" ]; then
				printf "%s\n\n" "[Done]"
			fi
			exit 0 
        fi
		__usage $SMBMANAGER_USAGE
		exit 129
    fi 
	__usage $SMBMANAGER_USAGE
	exit 128
}

#
# @brief   Main entry point
# @params  Values required process and operation
# @exitval Script tool atmanger exit with integer value
#			0   - success operation 
# 			127 - run as root user
#			128 - missing argument
#			129 - wrong argument (operation)
#
printf "\n%s\n%s\n\n" "$TOOL_NAME $TOOL_VERSION" "`date`"
__checkroot
STATUS=$?
if [ "$STATUS" -eq "$SUCCESS" ]; then
	__smbmanager "$1" "$2"
fi

exit 127

