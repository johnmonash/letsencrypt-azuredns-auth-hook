#!/usr/bin/env bash

source common.sh

# Commands
log "" 4
log "    Running azure cli commands" 4
respAddRec=$(az network dns record-set txt add-record -g ${RESOURCE_GROUP} -z ${DNS_ZONE} -n ${CHALLENGE_KEY} -v ${TOKEN_VALUE} --output json)
log "      AddRec: '$respAddRec'" 4


exit 0
