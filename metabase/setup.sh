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

# Get setup token
SETUP_TOKEN=$(http --ignore-stdin --timeout=5 GET http://metabase:3000/api/session/properties | jq -r '.["setup-token"]')

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
