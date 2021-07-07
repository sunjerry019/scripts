#!/bin/bash
# Updates IP Address in cloudflare

IPv4=$(curl -sS -4 icanhazip.com)
IPv6=$(curl -sS -6 icanhazip.com)s

#   DNS INFO
ZONE="<redacted>"
ID4="<redacted>"
ID6="<redacted>"
ENTRY="<redacted>"
# / DNS INFO

#   AUTH INFO
APITOKEN="<redacted>"
# / AUTH INFO


AREC='{"type":"A","name":"'$ENTRY'","content":"'$IPv4'","ttl":1,"proxied":false}'

RES=$(curl -sS -X PATCH "https://api.cloudflare.com/client/v4/zones/$ZONE/dns_records/$ID4" \
     -H "Authorization: Bearer $APITOKEN" \
     -H "Content-Type: application/json" \
     --data $AREC)

if grep -q '"success":true' <<< "$RES"; then
	echo "Successfully updated IP to $IPv4"
else
	echo "Failure in update."
	echo "Response: $RES"
	exit 1
fi

if [[ ! -z "$IPv6" ]]; then
    AAAAREC='{"type":"AAAA","name":"'$ENTRY'","content":"'$IPv6'","ttl":1,"proxied":false}'

    RES2=$(curl -sS -X PATCH "https://api.cloudflare.com/client/v4/zones/$ZONE/dns_records/$ID6s" \
        -H "Authorization: Bearer $APITOKEN" \
        -H "Content-Type: application/json" \
        --data $AAAAREC)
    
    if grep -q '"success":true' <<< "$RES2"; then
	    echo "Successfully updated IP to $IPv6"
    else
	    echo "Failure in update for ipv6."
	    echo "Response: $RES2"
	    exit 1
    fi
fi

# curl -X GET "https://api.cloudflare.com/client/v4/zones/$ZONE/dns_records/$ID" \
#      -H "Authorization: Bearer $APITOKEN" \
#      -H "Content-Type: application/json"

# "https://api.cloudflare.com/client/v4/zones/$ZONE/dns_records/$ID

# curl -X GET "https://api.cloudflare.com/client/v4/user/tokens/verify" \
#      -H "Authorization: Bearer <REDACTED>" \
#      -H "Content-Type:application/json"
