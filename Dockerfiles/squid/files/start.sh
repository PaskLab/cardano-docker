#!/bin/bash

_term() {
  echo "Stopping Squid ..."
  kill -SIGINT $PID
}

trap _term SIGTERM SIGINT

echo "Starting Squid ..."
squid -NYCd 1 -f /config/squid.conf &

PID=$!
wait $PID
trap - SIGTERM SIGINT
wait $PID
sleep 5
EXIT_STATUS=$?

echo "Exit Status: ${EXIT_STATUS}"
