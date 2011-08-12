#! /bin/sh
############################################################################

ssh_config_file=${SSH_CONFIG_FILE:-config/ssh}
local_dir=${LOCAL_DIR:-$(pwd)/test}
remote_dir=${REMOTE_DIR:-\$(pwd)/test}
remote_script=${REMOTE_SCRIPT:-test_suite.sh}

usage="usage: %s [-F SSH_CONFIG_FILE] [-L LOCAL_DIR] [-R REMOTE_DIR] [-S SCRIPT] [-h] HOSTS...\n"
option="       %s   %s\n"
while getopts "F:G:L:R:S:h" opt
do
  case $opt in
  F  )  ssh_config_file=$OPTARG ;;
  L  )  local_dir=$OPTARG ;;
  R  )  remote_dir=$OPTARG ;;
  S  )  remote_script=$OPTARG ;;
  h  )  printf "$usage" $0
        printf "$option" "-F" "the ssh config file"
        printf "$option" "-L" "the local dir"
        printf "$option" "-R" "the remote dir"
        printf "$option" "-S" "the remote script"
        printf "$option" "-h" "prints this help"
        exit 0 ;;
  \? )  printf "$usage" $0
        exit 2 ;;
  esac
done
shift $(($OPTIND - 1))

############################################################################
#
# transfer tests
#

for host in "$@"
do
ssh -q -T -F "$ssh_config_file" "$host" -- <<SCRIPT
rm -rf "$remote_dir"
if [ "\$(dirname "$remote_dir")" != "" ]
then
  mkdir -p "\$(dirname "$remote_dir")"
fi
SCRIPT

scp -q -r -p -F "$ssh_config_file" "$local_dir" "$host:$remote_dir"

status=$?
if [ $status -ne 0 ]
then
  echo "[$status] could not scp tests to host: $host" >&2
  exit 1
fi
done

#
# run tests
#

for host in "$@"
do
echo "############## $host ##############"
ssh -q -F "$ssh_config_file" "$host" -- "$remote_dir/$remote_script" </dev/null

status=$?
if [ $status -ne 0 ]
then
  echo "[$status] $remote_dir/$remote_script" >&2
  exit 1
fi
done
############################################################################
