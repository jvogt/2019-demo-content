#!/bin/bash
rm Policyfile.lock.json

sleep 10 # let gdrive catch up

chef install
chef push stage
chef push prod
