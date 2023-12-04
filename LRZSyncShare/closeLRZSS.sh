#!/bin/bash

AppName="LRZ Sync+Share v"

wmctrl -c "$AppName"
while [ $? -ne 0 ]; do
    sleep 2
    wmctrl -c "$AppName"
done

# https://stackoverflow.com/a/5274331
