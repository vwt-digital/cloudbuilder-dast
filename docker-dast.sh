#!/bin/bash
#
# This script will run all the sec-helpers on the domainname provided to this script.
# It allows us to add new sec-helpers without adding them to individual cloudbuild.yaml files of our front-end and API projects.
#
set -eo pipefail
if [ "$2" == "" ]; then
    echo "This container expects two arguments: a domain name, and type"
    exit 1
fi
domain_name=$1
type=$2
echo "--------"
echo Starting verification of desired http plaintext behaviour...
python /sec-helpers/verify-no-http/main.py ${domain_name}
echo "--------"
echo Starting SSLlabs verification, this may take between 3-5 minutes...
python /sec-helpers/verify-encryption-in-transit/main.py ${domain_name}
#echo "--------"
#if [ "$type" == "frontend" ]; then
#    echo Starting Content Security Policy validation...
#    python /sec-helpers/verify-content-security-policy.py