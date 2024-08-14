
# SiteMinder Realm Batch Updates using REST API

This set of scripts is designed to facilitate batch updates of realms in CA SiteMinder using the REST API. The scripts allow you to retrieve all realms, review them, and then apply updates to selected realms.

## Prerequisites

Before you begin, ensure you have the following:
- `curl` and `jq` installed on your system.
- Access to the CA SiteMinder policy server with REST API enabled.

## Usage

### 1. Configure the Environment

First, update the `sm_env.sh` file with your policy server address.

```bash
#!/bin/bash

# Shared variables
HOST="your-policy-server-address"
PATH_LOGIN="/ca/api/sso/services/login/v1/token"
PATH_POLICY="/ca/api/sso/services/policy/v1/SmRealms"
```

Replace `your-policy-server-address` with the actual address of your policy server.

### 2. Retrieve All Realms

Run the `retrieve_realms.sh` script to retrieve all the realms from the policy server and save them to `realms.json`.

```bash
./retrieve_realms.sh
```

After running this script, review the `realms.json` file to identify the realms that need to be updated.

### 3. Review the Update Payload

Open and review the `update_payload.json` file. This file contains the JSON payload that will be used to update the realms. Make any necessary changes to the payload.

```json
{
    "IdleTimeout": 1200
}
```

Ensure that the values in `update_payload.json` are correct for your update needs.

### 4. Run the Update Script

Once you've reviewed and possibly modified the `update_payload.json`, run the `update_realms.sh` script to apply the updates to the selected realms.

```bash
./update_realms.sh
```

### Important: Backup the Policy Store

Before executing any updates, **it is highly recommended to run `XPSExport` to backup your policy store**. This ensures that you can restore your policy store in case anything goes wrong during the update process.

## Summary

This tool is a powerful way to batch update realms in CA SiteMinder using the REST API. By following the steps above, you can retrieve, review, and update realms efficiently. Always remember to backup your policy store before making any changes.
