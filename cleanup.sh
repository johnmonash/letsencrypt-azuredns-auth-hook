#!/usr/bin/env bash

source common.sh

# Commands
log "" 4
log "    Running azure cli commands" 4
respDel=$(az network dns record-set txt delete -g ${RESOURCE_GROUP} -z ${DNS_ZONE} -n ${CHALLENGE_KEY} -y)
log "      Delete: '$respDel'" 4

exit 0
