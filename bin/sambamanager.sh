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
UTIL=${UTIL_ROOT}/sh_util/${UTIL_VERSION}
UTIL_LOG=${UTIL}/log

.	${UTIL}/bin/devel.sh
.	${UTIL}/bin/usage.sh
.	${UTIL}/bin/check_root.sh
.	${UTIL}/bin/check_tool.sh
.	${UTIL}/bin/check_op.sh
.	${UTIL}/bin/logging.sh
.	${UTIL}/bin/load_conf.sh
.	${UTIL}/bin/load_util_conf.sh
.	${UTIL}/bin/progress_bar.sh

SAMBAMANAGER_TOOL=sambamanager
SAMBAMANAGER_VERSION=ver.1.0
SAMBAMANAGER_HOME=${UTIL_ROOT}/${SAMBAMANAGER_TOOL}/${SAMBAMANAGER_VERSION}
SAMBAMANAGER_CFG=${SAMBAMANAGER_HOME}/conf/${SAMBAMANAGER_TOOL}.cfg
SAMBAMANAGER_UTIL_CFG=${SAMBAMANAGER_HOME}/conf/${SAMBAMANAGER_TOOL}_util.cfg
SAMBAMANAGER_LOG=${SAMBAMANAGER_HOME}/log

.	${SAMBAMANAGER_HOME}/bin/nmb_operation.sh
.	${SAMBAMANAGER_HOME}/bin/smb_operation.sh
.	${SAMBAMANAGER_HOME}/bin/winbind_operation.sh
.	${SAMBAMANAGER_HOME}/bin/smb_version.sh
.	${SAMBAMANAGER_HOME}/bin/smb_list.sh

declare -A SAMBAMANAGER_USAGE=(
	[USAGE_TOOL]="${SAMBAMANAGER_TOOL}"
	[USAGE_ARG1]="[PR] smb | nmb | winbind | all"
	[USAGE_ARG2]="[OP] start | stop | restart | status | version"
	[USAGE_EX_PRE]="# Restart smb service"
	[USAGE_EX]="${SAMBAMANAGER_TOOL} smb restart"
)

declare -A SAMBAMANAGER_LOGGING=(
	[LOG_TOOL]="${SAMBAMANAGER_TOOL}"
	[LOG_FLAG]="info"
	[LOG_PATH]="${SAMBAMANAGER_LOG}"
	[LOG_MSGE]="None"
)

declare -A PB_STRUCTURE=(
	[BW]=50
	[MP]=100
	[SLEEP]=0.01
)

TOOL_DBG="false"
TOOL_LOG="false"
TOOL_NOTIFY="false"

#
# @brief   Main function
# @params  Values required process name and operation
# @exitval Function __smbmanger exit with integer value
#			0   - success operation
#			128 - missing argument(s)
#			129 - failed to load tool script configuration from files
#			130 - missing systemctl tool
#			131 - wrong second argument
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __sambamanager "$PR" "$OP"
#
function __sambamanager() {
	local PR=$1 OP=$2
	if [[ -n "${PR}" && -n "${OP}" ]]; then
		local FUNC=${FUNCNAME[0]} MSG="None" STATUS_CONF STATUS_CONF_UTIL STATUS
		MSG="Loading basic and util configuration!"
		__info_debug_message "$MSG" "$FUNC" "$SAMBAMANAGER_TOOL"
		__progress_bar PB_STRUCTURE
		declare -A config_sambamanager=()
		__load_conf "$SAMBAMANAGER_CFG" config_sambamanager
		STATUS_CONF=$?
		declare -A config_sambamanager_util=()
		__load_util_conf "$SAMBAMANAGER_UTIL_CFG" config_sambamanager_util
		STATUS_CONF_UTIL=$?
		declare -A STATUS_STRUCTURE=([1]=$STATUS_CONF [2]=$STATUS_CONF_UTIL)
		__check_status STATUS_STRUCTURE
		STATUS=$?
		if [ $STATUS -eq $NOT_SUCCESS ]; then
			MSG="Force exit!"
			__info_debug_message_end "$MSG" "$FUNC" "$SAMBAMANAGER_TOOL"
			exit 129
		fi
		TOOL_DBG=${config_sambamanager[DEBUGGING]}
		TOOL_LOG=${config_sambamanager[LOGGING]}
		TOOL_NOTIFY=${config_sambamanager[EMAILING]}
		local SYSCTL=${config_sambamanager_util[SYSTEMCTL]}
		__check_tool "${SYSCTL}"
		STATUS=$?
		if [ $STATUS -eq $NOT_SUCCESS ]; then
			MSG="Force exit!"
			__info_debug_message_end "$MSG" "$FUNC" "$SAMBAMANAGER_TOOL"
			exit 130
		fi
		local OPERATIONS=${config_sambamanager_util[SAMBA_OPERATIONS]}
		IFS=' ' read -ra OPS <<< "${OPERATIONS}"
		__check_op "${OP}" "${OPS[*]}"
		STATUS=$?
		if [ $STATUS -eq $SUCCESS ]; then
			case "${PR}" in
				"smb")
					__smb_operation $OP
					;;
				"nmb")
					__nmb_operation $OP
					;;
				"winbind")
					__winbind_operation $OP
					;;
				"all")
					MSG="All samba service [${OP}]"
					__info_debug_message_end "$MSG" "$FUNC" "$SAMBAMANAGER_TOOL"
					__nmb_operation $OP
					__smb_operation $OP
					__winbind_operation $OP
					;;
				"info")
					__smb_info
					;;
				"list")
					__smb_list
					;;
				"version")
					__smb_version
					;;
			esac
			MSG="Operation: ${OP} with service(s): ${PR} done"
			__info_debug_message "$MSG" "$FUNC" "$SAMBAMANAGER_TOOL"
			SAMBAMANAGER_LOGGING[LOG_MSGE]=$MSG
			SAMBAMANAGER_LOGGING[LOG_FLAG]="info"
			__logging SAMBAMANAGER_LOGGING
			__info_debug_message_end "Done" "$FUNC" "$SAMBAMANAGER_TOOL"
			exit 0
		fi
		__usage SAMBAMANAGER_USAGE
		exit 131
	fi
	__usage SAMBAMANAGER_USAGE
	exit 128
}

#
# @brief   Main entry point
# @params  Value required process and operation
# @exitval Script tool smbmanger exit with integer value
#			0   - success operation
#			127 - run as root user
#			128 - missing argument(s)
#			129 - failed to load tool script configuration from files
#			130 - missing systemctl tool
#			131 - wrong second argument
#
printf "\n%s\n%s\n\n" "${SAMBAMANAGER_TOOL} ${SAMBAMANAGER_VERSION}" "`date`"
__check_root
STATUS=$?
if [ $STATUS -eq $SUCCESS ]; then
	__sambamanager $1 $2
fi

exit 127

