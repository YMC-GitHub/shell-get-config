<core_file_head>
#!/bin/sh

# 读取配置文件
# 需要：
# 去除行首空格
# 去除注释内容
# 分割各键值对
# 分割键名键值
<core_file_head/>
<core_define_built_in_var>
###
# 定义内置变量
###
declare -A dic
dic=()
THIS_FILE_PATH=$(
  cd $(dirname $0)
  pwd
)
FILE_PATH=$THIS_FILE_PATH       #the default is relative tp the peoject dir
PROJECT_PATH="../"              #the default is relative to this file path
BUILT_IN_FILE=a-config-file.txt #
<core_define_built_in_var/>

<core_define_built_in_fun>
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
function read_config_file(){
# echo ${THIS_FILE_PATH}
local CONFIG_FILE=${THIS_FILE_PATH}/from-a-config.txt
if [ -n "${1}" ]
then
    CONFIG_FILE=$1
fi
local test=`sed 's/^ *//g' $CONFIG_FILE | grep --invert-match "^#"`
#字符转为数组
local arr=($test)
local key=
local value=
for i in "${arr[@]}"; do
    # 获取键名
    key=`echo $i|awk -F'=' '{print $1}'`
    # 获取键值
    value=`echo $i|awk -F'=' '{print $2}'`
    # 输出该行
    #printf "%s\t\n" "$i"
    dic+=([$key]=$value)
done
echo "read confifg file:$CONFIG_FILE"
}
# function-usage:
# read_config_file
# read_config_file a-config-file-2.txt

<core_define_built_in_fun/>

<core_include_commom_code>
# 引入相关文件
<core_include_commom_code/>

<core_arg_help_msg>
# 参数帮助信息
USAGE_MSG=
USAGE_MSG_PATH=$(path_resolve $THIS_FILE_PATH "../help")
USAGE_MSG_FILE=${USAGE_MSG_PATH}/from-a-config-file.txt
USAGE_MSG=$(get_help_msg "$USAGE_MSG" "$USAGE_MSG_FILE")
<core_arg_help_msg/>

<core_arg_rule_content>
###
#参数规则内容
###
GETOPT_ARGS_SHORT_RULE="--options h,d,$ARGS_RULE_SHORT_TXT"
GETOPT_ARGS_LONG_RULE="--long help,debug,$ARGS_RULE_TXT"
<core_arg_rule_content/>

<core_set_arg_rule>
###
#设置参数规则
###
GETOPT_ARGS=$(
  getopt $GETOPT_ARGS_SHORT_RULE \
  $GETOPT_ARGS_LONG_RULE -- "$@"
)
<core_set_arg_rule/>

<core_parse_arg_rule>
###
#解析参数规则
###
ouput_debug_msg "pasre cli args ..." "true"
eval set -- "$GETOPT_ARGS"
# below generated by write-sources.sh
<core_parse_arg_rule/>

<core_handle_the_rest_arg>
###
#处理剩余参数
###
# optional

<core_handle_the_rest_arg/>

<core_update_built_in_var>
###
#更新内置变量
###
# below generated by write-sources.sh

<core_update_built_in_var/>

<core_print_config_info>
###
#输出配置信息
###
# below generated by write-sources.sh

<core_print_config_info/>

<core_main_code>
###
#脚本主要代码
###
#读取配置文件
PROJECT_PATH=$(path_resolve $THIS_FILE_PATH $PROJECT_PATH)
HELP_DIR=$PROJECT_PATH/help
SRC_DIR=$PROJECT_PATH/src
TEST_DIR=$PROJECT_PATH/test
DIST_DIR=$PROJECT_PATH/dist
DOCS_DIR=$PROJECT_PATH/docs
TOOL_DIR=$PROJECT_PATH/tool

FILE_PATH=$(path_resolve $PROJECT_PATH $FILE_PATH)
echo $FILE_PATH
mkdir -p $FILE_PATH
BUILT_IN_FILE=$THIS_FILE_PATH/$BUILT_IN_FILE
if [ -n "$ARG_CUSTOM_FILE" ]; then
  CUSTOM_FILE=$FILE_PATH/$CUSTOM_FILE
fi

echo "read built-in config:..."
#fix sed: can't read a-config-file.txt: No such file or directory with index.sh

if [ -n "$ARG_NO_BUILT_IN" ]; then
  echo "does not read  the built in config.. " >/dev/null 2>&1
else
  #echo "read  the built in config"
  read_config_file $BUILT_IN_FILE
fi

#2输出某个键值
: <<ouput-one-key-val-for-debug
if [ ${dic["key1"]} ] ; then
    echo ${dic["key1"]}
fi
if [ ${dic["k8s-master"]} ] ; then
    echo ${dic["k8s-master"]}
fi
ouput-one-key-val-for-debug
#2输出整个配置
#echo ${dic[*]}

echo "read custom config:..."
#fix: No such file or directory
if [[ -n "$CUSTOM_FILE" && -e $CUSTOM_FILE ]]; then
  #echo "read the file passed by cli args $CONFIG_FILE"
  read_config_file $CUSTOM_FILE
fi

#:<<ouput-config-key-val-for-debug
# 输出整个配置文件的键名
echo "config file all key: "
echo ${!dic[*]}
# 输出整个配置文件的键值
echo "config file all val: "
echo ${dic[*]}
# 输出整个配置某个的键值
echo "config file key k8s-worker-7 's val is: "
if [ ${dic["k8s-worker-7"]} ]; then
  echo ${dic["k8s-worker-7"]}
fi
#ouput-config-key-val-for-debug
<core_main_code/>