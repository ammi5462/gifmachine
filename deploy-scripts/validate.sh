#!/bin/bash
sleep 10
curl -f http://localhost || exit 1
echo "GIFMachine is up and running!"
