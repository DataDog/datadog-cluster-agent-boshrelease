#!/usr/bin/env bash

# Unless explicitly stated otherwise all files in this repository are licensed under the Apache 2.0 License.
# This product includes software developed at Datadog (https://www.datadoghq.com/).
# Copyright 2017-Present Datadog, Inc.

# Helper functions used by ctl scripts
set -e # exit immediately if a simple command exits with a non-zero status
set -u # report the usage of uninitialized variables

# NOTE: most of this is copied and adapted from https://github.com/DataDog/datadog-agent-boshrelease
# we should do refactoring and share the common functions

function printf_log {
  local message=${1}
  local timestamp=`date +%y:%m:%d-%H:%M:%S`
  printf "${timestamp} :: ${message}\n" | tee -a "/var/vcap/sys/log/${NAME}/${NAME}_script.log"
}

function echon_log {
  local message=${1}
  local timestamp=`date +%y:%m:%d-%H:%M:%S`
  printf "${timestamp} :: ${message} \n" | tee -a "/var/vcap/sys/log/${NAME}/${NAME}_script.log"
}

function check_if_running_and_kill {
  local agent_command="$1"
  local do_not_wait="$2"
  local pid=$(find_pid $agent_command)
  if [ -n "$pid" ]; then
    printf_log "The Cluster Agent is running, stopping it"
    if [ -n "$do_not_wait" ]; then
      kill -9 "$pid"
    else
      stop_agent $agent_command
    fi
  fi
}

function stop_agent {
  local agent_command=$1
  (
      {
          exec chpst -v -u vcap:vcap "${DD_CLUSTER_AGENT}" stop -c ${JOB_DIR}/config/
      } >>${LOG_DIR}/${NAME}.stdout.log \
      2>>${LOG_DIR}/${NAME}.stderr.log
  ) || true
  find_pid_kill_and_wait $1 || true
}

function find_pid_kill_and_wait {
  local find_command=$1
  local pid=$(find_pid $find_command)
  if [[ ! "$pid" || "$pid" == "" ]]; then
    echo "No such PID exists, skipping the hard kill"
  else
    local timeout=${2:-25}
    local force=${3:-1}

    wait_pid $pid 1 $timeout $force
    echo "killed pid"
  fi
}

function wait_pid {
  local pidfile=$1
  local pid=$2
  local try_kill=$3
  local timeout=${4:-0}
  local force=${5:-0}
  local countdown=$(( $timeout * 10 ))
  local ps_out="$(ps ax | grep $pid | grep -v grep)"

  if [ -e /proc/$pid -o -n "$ps_out" ]; then
    if [ "$try_kill" = "1" ]; then
      echon_log "Killing $pidfile: $pid "
      kill $pid
    fi
    while [ -e /proc/$pid ]; do
      sleep 0.1
      [ "$countdown" != '0' -a $(( $countdown % 10 )) = '0' ] && echo -n .
      if [ $timeout -gt 0 ]; then
        if [ $countdown -eq 0 ]; then
          if [ "$force" = "1" ]; then
            echo
            printf_log "Kill timed out, using kill -9 on $pid ..."
            kill -9 $pid
            sleep 0.5
          fi
          break
        else
          countdown=$(( $countdown - 1 ))
        fi
      fi
    done
    if [ -e /proc/$pid ]; then
      printf_log "Timed Out"
    else
      printf_log "Stopped"
    fi
  else
    printf_log "Process $pid is not running"
  fi
}

function pid_guard {
  local pidfile=$1
  local name=$2

  if [ -f "$pidfile" ]; then
    pid=$(head -1 "$pidfile")
    if [ -n "$pid" ] && [ -e /proc/$pid ]; then
      die "$name is already running, please stop it first"
    fi
    printf_log "Removing stale pidfile ..."
    rm $pidfile
  fi
}
