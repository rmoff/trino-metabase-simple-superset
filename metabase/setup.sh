#!/bin/sh
set -e

# Install required tools
apk update && apk add --no-cache httpie jq

# Wait for Metabase to be ready
echo 'Waiting for Metabase to start...'
until http --check-status --ignore-stdin --timeout=5 HEAD http://metabase:3000 >/dev/null 2>&1; do
    printf '.'
    sleep 5
done

# Wait for the API to be fully initialized
SETUP_TOKEN=""
while [ -z "$SETUP_TOKEN" ] || [ "$SETUP_TOKEN" = "null" ]; do
    printf '.'
    sleep 5
    # Try to get the setup token, but handle errors gracefully
    RESPONSE=$(http --ignore-stdin --timeout=5 GET http://metabase:3000/api/session/properties 2>/dev/null || echo '{}')
    SETUP_TOKEN=$(echo $RESPONSE | jq -r '.["setup-token"]' 2>/dev/null || echo "")
done

echo 'Setup token obtained: '$SETUP_TOKEN

# Configure Metabase
http --ignore-stdin POST http://metabase:3000/api/setup \
    token="$SETUP_TOKEN" \
    user:='{
        "email": "admin@example.com",
        "first_name": "asdf",
        "last_name": "zxcv",
        "password": "ArthurDent42"
    }' \
    prefs:='{
        "allow_tracking": false,
        "site_name": "Sirius Cybernetics Corporation"
    }'

echo "Metabase setup complete!"
echo ""
echo "  ╔╦╗╔═╗╔╦╗╔═╗╔╗ ╔═╗╔═╗╔═╗  ╦═╗╔═╗╔═╗╔╦╗╦ ╦┬"
echo "  ║║║║╣  ║ ╠═╣╠╩╗╠═╣╚═╗║╣   ╠╦╝║╣ ╠═╣ ║║╚╦╝│"
echo "  ╩ ╩╚═╝ ╩ ╩ ╩╚═╝╩ ╩╚═╝╚═╝  ╩╚═╚═╝╩ ╩═╩╝ ╩ o"
echo ""
echo "  ★彡 ⚡ ★彡 ⚡ ★彡 ⚡ ★彡 ⚡ ★彡 ⚡ ★彡 ⚡ ★彡 ⚡"
echo ""
echo "  🚀 Login at: http://localhost:3000"
echo "  👤 Username: admin@example.com"
echo "  🔑 Password: ArthurDent42"
echo ""
echo "  ★彡 ⚡ ★彡 ⚡ ★彡 ⚡ ★彡 ⚡ ★彡 ⚡ ★彡 ⚡ ★彡 ⚡"
echo ""
echo "  Don't Panic! And always carry a towel! 🌌🐬"
echo ""
