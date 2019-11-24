#!/bin/sh

USAGE_MSG=
USAGE_MSG_PATH=$(path_resolve $THIS_FILE_PATH "../help")
USAGE_MSG_FILE=${USAGE_MSG_PATH}/from-a-config-file.txt
USAGE_MSG=$(get_help_msg "$USAGE_MSG" "$USAGE_MSG_FILE")

GETOPT_ARGS_SHORT_RULE="--options h,d,"
GETOPT_ARGS_LONG_RULE="--long help,debug,custom-file:,project-path:,file-path:,built-in-file:,no-built-in:"
###
#设置参数规则
###
GETOPT_ARGS=$(
  getopt $GETOPT_ARGS_SHORT_RULE \
    $GETOPT_ARGS_LONG_RULE -- "$@"
)
###
#解析参数规则
###
eval set -- "$GETOPT_ARGS"
# below generated by write-sources.sh

while [ -n "$1" ]; do
  case $1 in
  -h | --help)
    echo "$USAGE_MSG"
    exit 1
    ;;
  -d | --debug)
    IS_DEBUG_MODE=true
    shift 2
    ;;
  --)
    break
    ;;
  *)

    key="${1}"
    value=$2
     #dic+=([$key]=$value)
     #cache_set_arg_val "$key" "$value"
     cache_set_arg_val "$key" "$value"
    shift 2
    ;;
  esac
done
