#!/bin/bash
start=$1
end=$2

if [ $# -ne 2 ]; then
  echo "Usage: ./gencsv.sh <start> <end>"
  exit 1
fi

for i in $(seq $start $end); do
  echo "$i, $((RANDOM % 500))"
done > inputFile
