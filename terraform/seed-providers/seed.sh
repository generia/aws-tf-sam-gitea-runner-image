#!/usr/bin/env bash
set -e
mkdir -p /tmp/tf-seed
cp /opt/seed-providers/main.tf /tmp/tf-seed/
cd /tmp/tf-seed
terraform init -input=false -no-color
