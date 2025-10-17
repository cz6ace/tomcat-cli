#!/bin/bash
#

protocol=http
host=localhost
port=8080
user=tomcat
pass=tomcat
connect_timeout=10

#
# Print usage
#
help() {
  cat <<HELP
Usage: $0 [OPTION]... command [ARG]
Executes command in tomcat instance.

Options:
  --config filename optional configfile with connection/password
  --port port       port on which the tomcat manager is running
  --host hostname   hostname of the tomcat instance
  --protocol protocol protocol - default http
  -h --help         show this help

Commands:
  list        List Currently Deployed Applications
  info        List OS and JVM Properties
  vminfo      VM Info
  resources   List Available Global JNDI Resources
  sessions    Session Statistics. Compulsory argument of webapp path, e.g. /manager
  expire      Expire Sessions. Compulsory argument of webapp path. Optional secondary argument number of minutes to expire sessions that are idle for longer than num minutes
  threaddump  Thread Dump
  reload      Reload An Existing Application, e.g. /examples
  start       Start an Existing Application
  stop        Stop an Existing Application
HELP
}

#
# Read default parameters like host, port, etc.
#
readdefaults() {
  configfile=$(dirname $0)/.tomcat-cli
  if [ -e $configfile ]; then
    source $configfile
  elif [ -e ~/.tomcat-cli ]; then
    source ~/.tomcat-cli
  fi
  return
}

#
# runs the URI using specified parameters
#
runcmd() {
  cmd=$1
  extra=$2
  wget --connect-timeout=$connect_timeout --http-user=$user --http-password=$pass -q -O - $protocol://$host:$port/manager/text/$cmd?$extra
}

if [ $# -eq 0 ]; then
  help
  exit 0
fi

readdefaults

while (( $# > 0 )); do
  case $1 in
    "--config")
      config=$2
      if [ -e "$config" ]; then
        source "$config"
      else
        echo Config $config file not found
        exit 1
      fi
      shift
      ;;
    "--protocol")
      protocol=$2
      shift
      ;;
    "--port")
      port=$2
      shift
      ;;
    "--host")
      host=$2
      shift
      ;;
    "-h" | "--help")
      help
      ;;
    "list") 
      runcmd list
      ;;
    "info")
      runcmd serverinfo
      ;;
    "vminfo")
      runcmd vminfo
      ;;
    "resources")
      runcmd resources
      ;;
    "sessions")
      runcmd sessions "path=$2"
      shift
      ;;
    "expire")
      path=$2
      num=${3:-0}
      shift
      shift
      runcmd expire "path=${path}&idle=${num}"
      ;;
    "threaddump")
      runcmd threaddump
      ;;
    "reload")
      runcmd reload "path=$2"
      shift
      ;;
    "start")
      runcmd start "path=$2"
      shift
      ;;
    "stop")
      runcmd stop "path=$2"
      shift
      ;;
    *)
      echo Unknown command $1
      exit 1
      ;;
  esac
  shift
done

#eof
