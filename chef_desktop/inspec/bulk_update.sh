#!/bin/bash

rm -rf acme_baseline_macos/vendor
rm -rf acme_baseline_macos/inspec.lock

rm -rf acme_engineering_macos/vendor
rm -rf acme_engineering_macos/inspec.lock

inspec compliance upload acme_baseline_macos --overwrite
inspec compliance upload acme_engineering_macos --overwrite
