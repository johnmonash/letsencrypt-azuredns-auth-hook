#!/usr/bin/env bash

#
# How to deploy a DNS challenge using Azure
#

# Debug Logging level
DEBUG=3

source cred.sh
# the file cred.sh needs to have the following variables defined:

# Azure Tenant specific configuration settings
#   You should create an SPN in Azure first and authorize it to make changes to Azure DNS
#       REF: https://azure.microsoft.com/en-us/documentation/articles/resource-group-create-service-principal-portal/
#TENANT=""      # Your tenant name  or guid
#SPN_USERNAME=""         # This is one of the SPN values (the identifier-uri or guid value)
#SPN_PASSWORD=""                   # This is the password associated with the SPN account
#RESOURCE_GROUP=""      # This is the resource group containing your Azure DNS instance
#DNS_ZONE=""                  # This is the DNS zone you want the SPN to manage (Contributor access)


# Supporting functions
function log {
    if [ $DEBUG -ge $2 ]; then
        echo "$1" > /dev/tty
    fi
}
function login_azure {
    # Azure DNS Connection Variables
    # You should create an SPN in Azure first and authorize it to make changes to Azure DNS
    #  REF: https://azure.microsoft.com/en-us/documentation/articles/resource-group-create-service-principal-portal/
    az login --service-principal -u ${SPN_USERNAME} -p ${SPN_PASSWORD} --tenant ${TENANT}  > /dev/null
}
function parseSubDomain {
    log "  Parse SubDomain" 4

    FQDN="$1"
    log "    FQDN: '${FQDN}''" 4

    DOMAIN=`sed -E 's/(^[^.]+)\.(.*)/\2/' <<< "${FQDN}"`
    log "    DOMAIN: '${DOMAIN}'" 4

    SUBDOMAIN=`sed -E 's/(^[^.]+)\.(.*)/\1/' <<< "${FQDN}"`
    log "    SUBDOMAIN: '${SUBDOMAIN}'" 4

    echo "${SUBDOMAIN}"
}
function buildDnsKey {
    log "  Build DNS Key" 4

    FQDN="$1"
    log "    FQDN: '${FQDN}'" 4

    SUBDOMAIN=$(parseSubDomain ${FQDN})
    log "    SUBDOMAIN: ${SUBDOMAIN}" 4

    CHALLENGE_KEY="_acme-challenge.${SUBDOMAIN}"
    log "    KEY: '${CHALLENGE_KEY}'" 4

    echo "${CHALLENGE_KEY}"
}


# Logging the header
log "Azure Hook Script - LetsEncrypt" 4


login_azure
FQDN="$CERTBOT_DOMAIN"
TOKEN_VALUE="$CERTBOT_VALIDATION"
SUBDOMAIN=$(parseSubDomain ${FQDN})
CHALLENGE_KEY=$(buildDnsKey ${FQDN})

