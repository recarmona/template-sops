#!/bin/bash
# WARNING: This script will be executed as root on initial boot of the instance

# Python is required for sshuttle to work
dnf update -y
dnf install -y python3