#!/bin/bash
#
# This script will run all the sec-helpers on the domainname provided to this script.
# It allows us to add new sec-helpers without adding them to individual cloudbuild.yaml files of our front-end and API projects.
#
set -eo pipefail
if [ "$2" == "" ]; then
    echo "This container expects two arguments: a domain name (or dispatch file), and type"
    exit 1
fi
if [[ -f $1 ]]; then
    domain_name=$(sed -n "s/\s*-\s*url.*:\s*\"\(.*\)\/.*/\1/p" "$1" | head -n1)
else
    domain_name=$1
fi
type=$2


echo Running sec_helpers...
echo
python test.py "${domain_name}" "${type}"
