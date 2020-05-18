#!/bin/bash
rm acme_app.lock.json
rm acme_monogodb.lock.json

sleep 10 # let gdrive catch up

chef install acme_app.rb
chef push stage acme_app.lock.json
chef push prod acme_app.lock.json

chef install acme_monogodb.rb
chef push stage acme_monogodb.lock.json
chef push prod acme_monogodb.lock.json
