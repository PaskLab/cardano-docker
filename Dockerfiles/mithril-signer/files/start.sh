#!/bin/bash

_term() {
  echo "Stopping Mithril Signer ..."
  kill -SIGINT $PID
}

trap _term SIGTERM SIGINT

echo "Starting Mithril Signer ..."
mithril-signer -vvv &

PID=$!
wait $PID
trap - SIGTERM SIGINT
wait $PID
sleep 5
EXIT_STATUS=$?

echo "Exit Status: ${EXIT_STATUS}"
