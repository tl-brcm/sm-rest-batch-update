#!/bin/bash

# Shared variables
HOST="ps2.demo-broadcom.com"
PATH_LOGIN="/ca/api/sso/services/login/v1/token"
PATH_POLICY="/ca/api/sso/services/policy/v1/SmRealms"

# Function to prompt for username and password securely
prompt_credentials() {
    read -p "Enter Username: " USERNAME
    read -sp "Enter Password: " PASSWORD
    echo

    # Encode the username and password to Base64
    AUTH=$(echo -n "$USERNAME:$PASSWORD" | base64)
}

# Function to get the session key
get_session_key() {
    RESPONSE=$(curl --location --silent --request POST "https://$HOST$PATH_LOGIN" \
    --header "Accept: application/ecmascript" \
    --header "Authorization: Basic $AUTH" \
    --data '')

    SESSION_KEY=$(echo "$RESPONSE" | jq -r '.sessionkey')

    if [ "$SESSION_KEY" != "null" ] && [ -n "$SESSION_KEY" ]; then
        echo "Session key extracted successfully: $SESSION_KEY"
    else
        echo "Failed to extract session key"
        exit 1
    fi
}
