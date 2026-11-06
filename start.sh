
#!/bin/bash
set -e

if [ -z "$TERMINAL_USER" ] || [ -z "$TERMINAL_PASSWORD" ]; then
    echo "ERROR: Set TERMINAL_USER and TERMINAL_PASSWORD."
    exit 1
fi

echo "Starting shared Linux terminal..."
echo "All connected users share this environment."

exec /usr/local/bin/ttyd \
    --writable \
    --port "${PORT:-10000}" \
    --interface 0.0.0.0 \
    --credential "${TERMINAL_USER}:${TERMINAL_PASSWORD}" \
    --max-clients 20 \
    -- bash --login
