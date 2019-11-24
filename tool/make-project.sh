#!/bin/sh
###
# 定义内置变量
###
THIS_FILE_PATH=$(
  cd $(dirname $0)
  pwd
)

###
# 定义内置函数
###
function ouput_debug_msg() {
  local debug_msg=$1
  local debug_swith=$2
  if [[ "$debug_swith" =~ "false" ]]; then
    echo $debug_msg >/dev/null 2>&1
  elif [ -n "$debug_swith" ]; then
    echo $debug_msg
  elif [[ "$debug_swith" =~ "true" ]]; then
    echo $debug_msg
  fi
}
function path_resolve_for_relative() {
  local str1="${1}"
  local str2="${2}"
  local slpit_char1=/
  local slpit_char2=/
  if [[ -n ${3} ]]; then
    slpit_char1=${3}
  fi
  if [[ -n ${4} ]]; then
    slpit_char2=${4}
  fi

  # 路径-转为数组
  local arr1=(${str1//$slpit_char1/ })
  local arr2=(${str2//$slpit_char2/ })

  # 路径-解析拼接
  #2 遍历某一数组
  #2 删除元素取值
  #2 获取数组长度
  #2 获取数组下标
  #2 数组元素赋值
  for val2 in ${arr2[@]}; do
    length=${#arr1[@]}
    if [ $val2 = ".." ]; then
      index=$(($length - 1))
      if [ $index -le 0 ]; then index=0; fi
      unset arr1[$index]
      #echo ${arr1[*]}
      #echo  $index
    elif [ $val2 = "." ]; then
      echo "current path" >/dev/null 2>&1
    else
      index=$length
      arr1[$index]=$val2
      #echo ${arr1[*]}
    fi
  done
  # 路径-转为字符
  local str3=''
  for i in ${arr1[@]}; do
    str3=$str3/$i
  done
  if [ -z $str3 ]; then str3="/"; fi
  echo $str3
}
function path_resolve() {
  local str1="${1}"
  local str2="${2}"
  local slpit_char1=/
  local slpit_char2=/
  if [[ -n ${3} ]]; then
    slpit_char1=${3}
  fi
  if [[ -n ${4} ]]; then
    slpit_char2=${4}
  fi

  #FIX:when passed asboult path,dose not return the asboult path itself
  #str2="/d/"
  local str3=""
  str2=$(echo $str2 | sed "s#/\$##")
  ABSOLUTE_PATH_REG_PATTERN="^/"
  if [[ $str2 =~ $ABSOLUTE_PATH_REG_PATTERN ]]; then
    str3=$str2
  else
    str3=$(path_resolve_for_relative $str1 $str2 $slpit_char1 $slpit_char2)
  fi
  echo $str3
}
function get_help_msg() {
  local USAGE_MSG=$1
  local USAGE_MSG_FILE=$2
  if [ -z $USAGE_MSG ]; then
    if [[ -n $USAGE_MSG_FILE && -e $USAGE_MSG_FILE ]]; then
      USAGE_MSG=$(cat $USAGE_MSG_FILE)
    else
      USAGE_MSG="no help msg and file"
    fi
  fi
  echo "$USAGE_MSG"
}
# 引入相关文件
# source $THIS_FILE_PATH/path-resolve.sh
# 工程目录信息
BUILT_IN_PROJECT_PATH=$(path_resolve $THIS_FILE_PATH "../")
BUILT_IN_HELP_DIR=$(path_resolve $THIS_FILE_PATH "../help")
BUILT_IN_SRC_DIR=$(path_resolve $THIS_FILE_PATH "../src")
BUILT_IN_TEST_DIR=$(path_resolve $THIS_FILE_PATH "../test")
BUILT_IN_DIST_DIR=$(path_resolve $THIS_FILE_PATH "../dist")
BUILT_IN_DOCS_DIR=$(path_resolve $THIS_FILE_PATH "../docs")
BUILT_IN_TOOL_DIR=$(path_resolve $THIS_FILE_PATH "../tool")
BUILT_IN_DEBUG_DIR=$(path_resolve $THIS_FILE_PATH "../debug")
###
# 参数帮助信息
###
# @todos:generate by shell
USAGE_MSG_PATH="$HELP_DIR"
USAGE_MSG_FILE="${HELP_DIR}/make-project.txt"
USAGE_MSG=$(
  cat <<EOF
desc:
  make project dir construtor
args:
  --project-path optional,set the project path
  -d,--debug optional,set the debug mode
  -h,--help optional,get the cmd help
how-to-run:
  run as shell args
    bash ./make-project.sh
  run as runable application
    ./make-project.sh --project-path eth0
demo-with-args:
  without-args
    ok:./make-project.sh
  passed arg with necessary value
    ok:./make-project.sh --project-path eth0
    ok:./make-project.sh --project-path=eth0
  passed arg with optional value
  passed arg without value
  basic-usage:
    set the project path
      with relative path ,it relative to the project path
        ok:./make-project.sh --project-path ../hell-get-config
      with absolute path
        ok:./make-project.sh --project-path /d/code-store/Shell/shell-get-config
how-to-get-help:
  ok:./make-project.sh --help
  ok:./make-project.sh -h
  ok:./make-project.sh --debug
EOF
)

###
#参数规则内容
###
# @todos:generate by shell
GETOPT_ARGS_SHORT_RULE="--options h,d,"
GETOPT_ARGS_LONG_RULE="--long help,debug,project-path:"

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
  --project-path)
    ARG_PROJECT_PATH=$2
    shift 2
    ;;
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
    printf "$USAGE_MSG"
    ;;
  esac
done

###
#处理剩余参数
###
# optional

###
#更新内置变量
###
# below generated by write-sources.sh
if [ -n "$ARG_PROJECT_PATH" ]; then
  PROJECT_PATH=$ARG_PROJECT_PATH
fi

###
#输出配置信息
###
# below generated by write-sources.sh
# echo $PROJECT_PATH,$FILE_LIST

###
#脚本主要代码
###
#执行脚本目录
RUN_SCRIPT_PATH=$(pwd)
#echo "the running scripts path is $RUN_SCRIPT_PATH"
#脚本所在目录
#echo $THIS_FILE_PATH
#echo "the script file 's path is $THIS_FILE_PATH"
#内置工程目录
#BUILT_IN_PROJECT_PATH
#echo "the built in path is $BUILT_IN_PROJECT_PATH"
#自定工程目录
CUSTOM_PROJECT_PATH=$(path_resolve $BUILT_IN_PROJECT_PATH $PROJECT_PATH)
#echo "the custom path is $CUSTOM_PROJECT_PATH"

CUSTOM_HELP_DIR=$CUSTOM_PROJECT_PATH/help
CUSTOM_SRC_DIR=$CUSTOM_PROJECT_PATH/src
CUSTOM_TEST_DIR=$CUSTOM_PROJECT_PATH/test
CUSTOM_DIST_DIR=$CUSTOM_PROJECT_PATH/dist
CUSTOM_DOCS_DIR=$CUSTOM_PROJECT_PATH/docs
CUSTOM_TOOL_DIR=$CUSTOM_PROJECT_PATH/tool
CUSTOM_DEBUG_DIR=$CUSTOM_PROJECT_PATH/debug

if [ -n "$PROJECT_PATH" ]; then
  #echo "uses custom path as project path"
  PROJECT_PATH="$CUSTOM_PROJECT_PATH"
else
  #echo "uses running scripts path as project path"
  PROJECT_PATH="$RUN_SCRIPT_PATH"
fi
HELP_DIR=$PROJECT_PATH/help
SRC_DIR=$PROJECT_PATH/src
TEST_DIR=$PROJECT_PATH/test
DIST_DIR=$PROJECT_PATH/dist
DOCS_DIR=$PROJECT_PATH/docs
TOOL_DIR=$PROJECT_PATH/tool
DEBUG_DIR=$PROJECT_PATH/debug

function make_project_dir() {
  local PROJECT_DIR_CONSTRUTOR_ARR=
  local PROJECT_DIR_CONSTRUTOR=
  local REG_SHELL_COMMOMENT_PATTERN="^#"
  local var=

  PROJECT_DIR_CONSTRUTOR=$(
    cat <<EOF
$HELP_DIR
$SRC_DIR
$TEST_DIR
$DIST_DIR
$DOCS_DIR
$TOOL_DIR
$DEBUG_DIR
EOF
  )
  PROJECT_DIR_CONSTRUTOR=$(echo "$PROJECT_DIR_CONSTRUTOR" | sed "s/^#.*//g" | sed "/^$/d")
  PROJECT_DIR_CONSTRUTOR_ARR=(${PROJECT_DIR_CONSTRUTOR//,/ })

  for i in ${!PROJECT_DIR_CONSTRUTOR_ARR[@]}; do
    var=${PROJECT_DIR_CONSTRUTOR_ARR[$i]}
    if [[ "$var" =~ $REG_SHELL_COMMOMENT_PATTERN ]]; then
      echo "$var" >/dev/null 2>&1
    else
      mkdir -p "$var"
    fi
  done
}

echo "create project dir for $PROJECT_PATH"
make_project_dir

#/d/code-store/Shell/shell-get-config/tool/make-proejct.sh
