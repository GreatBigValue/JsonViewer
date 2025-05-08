#!/bin/sh

# Simple wait-for-it script (ash shell compatible)
set -e

HOST=$1
PORT=$2
TIMEOUT=${3:-30}
COMMAND=${@:4}

echo "Waiting for $HOST:$PORT (timeout: $TIMEOUT seconds)..."

# Loop until timeout is reached
START_TIME=$(date +%s)
END_TIME=$((START_TIME + TIMEOUT))

while [ $(date +%s) -lt $END_TIME ]; do
  if nc -z $HOST $PORT > /dev/null 2>&1; then
    echo "Service $HOST:$PORT is available after $(($(date +%s) - START_TIME)) seconds"

    # Execute command if provided
    if [ ! -z "$COMMAND" ]; then
      echo "Executing command: $COMMAND"
      exec $COMMAND
    fi

    exit 0
  fi

  echo "Waiting for $HOST:$PORT..."
  sleep 2
done

echo "Timeout reached. $HOST:$PORT is not available after $TIMEOUT seconds"

# Execute command anyway if provided
if [ ! -z "$COMMAND" ]; then
  echo "Executing command anyway: $COMMAND"
  exec $COMMAND
fi

exit 0
