#!/bin/bash

updates=$(checkupdates | wc -l)

if [ "$updates" -gt 0 ]; then
    echo "$updates"
else
    echo "" # hide the module when there are no updates
fi