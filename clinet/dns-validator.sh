#!/bin/bash

# --- Configuration ---
# Path to your dnstt-client binary
DNSTT_EXE="./dnstt-client"
# Path to your public key file
PUBKEY_FILE="server.pub"
# Input file with one IP per line
DNS_LIST="ir_dns_servers.txt"
# Output file for successful IPs
OUTPUT_FILE="working_dns.txt"

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Prompt user for domain
read -p "Enter your domain (e.g., t.example.com): " DOMAIN

# Validate domain input
if [[ -z "$DOMAIN" ]]; then
    echo "Error: Domain cannot be empty!"
    exit 1
fi

# Check if input file exists
if [ ! -f "$DNS_LIST" ]; then
    echo "Error: $DNS_LIST not found!"
    exit 1
fi

echo "Starting DNS connection test for domain: $DOMAIN"
echo "-----------------------------------"

# Clear previous output file
> "$OUTPUT_FILE"

while read -r dns_ip; do
    # Trim whitespace
    dns_ip=$(echo "$dns_ip" | xargs)
    
    # Skip empty lines
    [[ -z "$dns_ip" ]] && continue

    echo -ne "Testing DNS: $dns_ip ... "

    # 1. Run dnstt-client in background
    # Redirecting output to /dev/null to keep terminal clean
    $DNSTT_EXE -udp "${dns_ip}:53" -pubkey-file "$PUBKEY_FILE" "$DOMAIN" 127.0.0.1:7000 > /dev/null 2>&1 &
    
    # Capture the Process ID (PID)
    CLIENT_PID=$!

    # 2. Brief wait for handshake/connection initialization
    sleep 3

    # 3. Test connectivity using curl through the SOCKS5 proxy
    # --max-time 5: Timeout after 5 seconds
    # --write-out "%{http_code}": Get the HTTP status code
    HTTP_CODE=$(curl --socks5 127.0.0.1:7000 --max-time 5 --write-out "%{http_code}" --silent --output /dev/null http://httpbin.org/ip)

    if [ "$HTTP_CODE" -eq 200 ]; then
        echo -e "${GREEN}SUCCESS${NC}"
        echo "$dns_ip" >> "$OUTPUT_FILE"
    else
        echo -e "${RED}FAILED${NC}"
    fi

    # 4. Terminate the background dnstt-client process
    kill $CLIENT_PID 2>/dev/null
    wait $CLIENT_PID 2>/dev/null

done < "$DNS_LIST"

echo "-----------------------------------"
echo "Test complete. Results saved in $OUTPUT_FILE"