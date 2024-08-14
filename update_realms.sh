#!/bin/bash

# Source shared variables and functions
source ./shared.sh

# Prompt for credentials and get session key
prompt_credentials
get_session_key

# Check if realms.json exists
if [ ! -f realms.json ]; then
    echo "realms.json not found. Please run retrieve_realms.sh first."
    exit 1
fi

# Check if update_payload.json exists
if [ ! -f update_payload.json ]; then
    echo "update_payload.json not found. Please create the payload file."
    exit 1
fi

# Read the update payload
UPDATE_PAYLOAD=$(cat update_payload.json)

# Extract the realm IDs and paths from the JSON file and loop through each
jq -c '.data[] | {id: .id, path: .path}' realms.json | while read -r realm; do
    realmId=$(echo "$realm" | jq -r '.id' | sed 's/^CA.SM::Realm@//')
    realmPath=$(echo "$realm" | jq -r '.path')

    echo "Updating realm: $realmPath"
    
    # Send PUT request to update the realm
    RESPONSE=$(curl --location --silent --write-out "HTTPSTATUS:%{http_code}" --request PUT "https://$HOST/ca/api/sso/services/policy/v1/objects/$realmId" \
    --header "Accept: application/ecmascript" \
    --header "Content-Type: application/json" \
    --header "Authorization: Bearer $SESSION_KEY" \
    --data "$UPDATE_PAYLOAD")

    # Extract the body and the HTTP status code
    HTTP_BODY=$(echo "$RESPONSE" | sed -e 's/HTTPSTATUS\:.*//g')
    HTTP_STATUS=$(echo "$RESPONSE" | tr -d '\n' | sed -e 's/.*HTTPSTATUS://')

    # Check if the update was successful
    if [ "$HTTP_STATUS" -eq 200 ]; then
        echo "Realm $realmPath updated successfully."
    else
        echo "Failed to update realm $realmPath. Response code: $HTTP_STATUS"
        echo "Response body: $HTTP_BODY"
    fi
done

echo "Script completed."
