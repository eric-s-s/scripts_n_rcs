#!/bin/bash

if [[ -z "${MONGO_SECRET}" ]]; then
    echo must set MONGO_SECRET
    exit 1
fi


RAW_OUTPUT=false
FILENAME=""

# Loop over all arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    --raw-output)
      RAW_OUTPUT=true
      shift
      ;;
    --*)
      echo "unkown option. allowed=--raw-output"
      exit 1
      ;;
    *)
      if [[ -z "$FILENAME" ]]; then
        FILENAME="$1"
      else
        echo "Unexpected extra positional argument: $1"
        exit 1
      fi
      shift
      ;;
  esac
done

if [[ -z "$FILENAME" ]]; then
  echo "Error: missing filename"
  exit 1
fi


if [[ "$RAW_OUTPUT" = "true" ]];then
    mongosh "${MONGO_SECRET}" -f "$FILENAME"
else
    mongosh "${MONGO_SECRET}" -f "$FILENAME" | jq .
fi
