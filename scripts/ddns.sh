#!/bin/bash

# Author: pchuan
# Version: 1.0
# Date: November 28, 2024
# Description: 自动ddns脚本

# set -exo
set -e

##############################################################

# Cloudflare API token (Enter Cloudflare dashboard -> Profile -> API Tokens -> Create Token -> Edit Zone DNS)
CF_API_TOKEN="277a724706e0adc25974ca9b303856f5bc9b2"
# Cloudflare zone ID for your domain (Enter website domain -> Overview -> API -> Zone ID)
ZONE_ID="0f2b9c8b2407726864d4f0ab736005d2"
# Cloudflare account email address
CF_API_EMAIL="1114003209@qq.com"
# DNS record name
RECORD_NAME="simscop.pchuan.site"
# Cloudflare DNS record type (A or AAAA)
RECORD_TYPE="A"
# The new IP address you want to point to
NEW_IP=$(ping -4 -c 1 -W 1 simscop.asuscomm.cn | grep -oP '\(\K[0-9.]+(?=\))' | head -n 1)

echo "New IP address: $NEW_IP"

# Function to update the DNS record
update_dns_record() {
    # Fetch the current DNS record ID for the given domain name
    RECORD_RECALL=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records?name=$RECORD_NAME" \
        -H "X-Auth-Key: $CF_API_TOKEN" \
        -H "X-Auth-Email: $CF_API_EMAIL" \
        -H "Content-Type: application/json")

    RECORD_ID=$(echo $RECORD_RECALL | jq -r '.result[0].id')
    OLD_IP=$(echo $RECORD_RECALL | jq -r '.result[0].content')

    echo "Record ID: $RECORD_ID"
    echo "Old IP address: $OLD_IP"

    # If the record ID is not found, create a new DNS record
    if [ "$RECORD_ID" == "null" ]; then
        echo "Record not found, creating a new one..."
        curl -s -X POST "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records" \
            -H "X-Auth-Key: $CF_API_TOKEN" \
            -H "X-Auth-Email: $CF_API_EMAIL" \
            -H "Content-Type: application/json" \
            --data '{
        "type": "'"$RECORD_TYPE"'",
        "name": "'"$RECORD_NAME"'",
        "content": "'"$NEW_IP"'",
        "ttl": 1,
        "proxied": false
      }' | jq .
    else
        # Update the existing DNS record with the new IP address
        echo "Updating DNS record..."
        curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$RECORD_ID" \
            -H "X-Auth-Key: $CF_API_TOKEN" \
            -H "X-Auth-Email: $CF_API_EMAIL" \
            -H "Content-Type: application/json" \
            --data '{
        "type": "'"$RECORD_TYPE"'",
        "name": "'"$RECORD_NAME"'",
        "content": "'"$NEW_IP"'",
        "ttl": 1,
        "proxied": false
      }' | jq .
    fi
}

# Call the function to update DNS record
update_dns_record

# Add the following line to your crontab to run this script every 30 minutes
# echo "*/30 * * * * /bin/bash ddns.sh" | crontab -
