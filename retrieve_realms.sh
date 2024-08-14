#!/bin/bash

# Source shared variables and functions
source ./shared.sh

# Prompt for credentials and get session key
prompt_credentials
get_session_key

# Send GET request to retrieve realm objects and write to JSON file
curl --location --silent "https://$HOST$PATH_POLICY" \
--header "Accept: application/ecmascript" \
--header "Authorization: Bearer $SESSION_KEY" \
--output realms.json

# Check if realms.json was created successfully
if [ ! -s realms.json ]; then
    echo "Failed to retrieve realm data"
    exit 1
else
    echo "Realms data saved to realms.json"
fi
