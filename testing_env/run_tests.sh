#!/bin/bash

sec=$1

sh ./compile.sh $sec

TIMEOUT_CMD="timeout"
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    TIMEOUT_CMD="gtimeout"
fi

$TIMEOUT_CMD $sec swipl -q < test.pl   2>&1

sh ./clean.sh