#!/bin/bash

# Check if a specific process is running.
function checkProcess() {
  PROCESS_NAME=$1

  if  [ -z "$PROCESS_NAME" ]; then
    IS_RUNNING=$(ps -def | awk '{print $8}' | grep "$PROCESS_NAME")

    if [ -z "$IS_RUNNING" ]; then
      exit 1
    fi
  fi
}

# Check if a specific port is open.
function checkPort() {
  PORT=$1

  if  [ -z "$PORT" ]; then
    IS_OPEN=$(nc -v -z -u 127.0.0.1 "$PORT" | grep open)

    if [ -z "$IS_OPEN" ]; then
      exit 1
    fi
  fi
}

# Main function
function main() {
  # Check if the srl-[live|file]-transmit is running.
  checkProcess "$1"

  # Check if the input port is open.
  checkPort "$2"

  # Check if the output port is open.
  checkPort "$3"
}

main "$1" "$2" "$3"