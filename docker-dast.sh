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

if [ "$3" != "" ]; then
  domain_name="${domain_name/develop/$3}"
  domain_name="${domain_name/master-/}"
fi

echo "--------"
echo Starting verification of desired http plaintext behaviour...
python /sec-helpers/verify-no-http/main.py "${domain_name}"
echo "--------"
echo Starting HSTS max-age verification
python /sec-helpers/verify-hsts/main.py "${domain_name}"
echo "--------"
echo Starting TLS version test
python /sec-helpers/verify-high-tls/main.py "${domain_name}" "$( (( "$3" == "" )) && printf %s '--force-pass' )"
echo "--------"
echo Starting no SSL test
bash /sec-helpers/verify-no-ssl/ssl3.sh "${domain_name}"
echo "--------"
if [ "$type" == "api" ]; then
	echo Starting CORS Policy verification
	python /sec-helpers/verify-cors-policy/main.py "${domain_name}"
	echo "--------"
fi
#echo "--------"
#if [ "$type" == "frontend" ]; then
#    echo Starting Content Security Policy validation...
#    python /sec-helpers/verify-content-security-policy.py
