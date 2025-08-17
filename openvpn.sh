#!/bin/bash
OVPN_FILE="$1"

if [ ! -f "$OVPN_FILE" ]; then
    echo "File not found: $OVPN_FILE"
    exit 1
fi

# Créer un flux temporaire où on remplace 'cipher' par 'data-ciphers'
TMP_OVPN=$(mktemp)

# Remplacer uniquement la ligne commençant par 'cipher '
sed 's/^\s*cipher\s\+/data-ciphers /I' "$OVPN_FILE" > "$TMP_OVPN"

# Afficher ce qu'on va passer
echo "Using modified OVPN config (cipher -> data-ciphers):"
grep -i 'data-ciphers' "$TMP_OVPN"

# Lancer OpenVPN avec ce fichier temporaire
sudo openvpn --config "$TMP_OVPN"

# Supprimer le fichier temporaire après usage
rm -f "$TMP_OVPN"
