#!/bin/bash

REPO_DIR="auto-ovpn"
REPO_URL="https://github.com/9xN/auto-ovpn"

if [ ! -d "$REPO_DIR" ]; then
    git clone --quiet --depth 1 "$REPO_URL" "$REPO_DIR"
else
    cd "$REPO_DIR" >/dev/null
    git fetch --quiet origin
    LOCAL=$(git rev-parse @)
    REMOTE=$(git rev-parse @{u})
    if [ "$LOCAL" != "$REMOTE" ]; then
        git pull --quiet --rebase origin main
    fi
    cd - >/dev/null
fi


# Gestion intelligente de la sélection de fichier OVPN
AUTOCHOOSE=0
INPUT_ARG=""

# Parse les arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        --autochoose)
            AUTOCHOOSE=1
            shift
            ;;
        *)
            INPUT_ARG="$1"
            shift
            ;;
    esac
done

if [ -z "$INPUT_ARG" ] || [ "$INPUT_ARG" = "--help" ]; then
    echo "Usage: $0 [--autochoose] <JP|KR|VN|RU|TH|US>"
    exit 1
fi

# Si l'argument ne contient pas de slash, on cherche dans auto-ovpn/configs/
if [[ "$INPUT_ARG" != */* ]]; then
    MATCHES=(auto-ovpn/configs/*"$INPUT_ARG".ovpn)
    if [ ${#MATCHES[@]} -eq 0 ] || [ ! -e "${MATCHES[0]}" ]; then
        echo "No file found for pattern: $INPUT_ARG"
        exit 1
    elif [ ${#MATCHES[@]} -eq 1 ] || [ "$AUTOCHOOSE" -eq 1 ]; then
        OVPN_FILE="${MATCHES[0]}"
        echo "File automatically selected: $OVPN_FILE"
    else
        echo "Multiple files found:"
        select OVPN_FILE in "${MATCHES[@]}"; do
            if [ -n "$OVPN_FILE" ]; then
                break
            fi
        done
    fi
else
    OVPN_FILE="$INPUT_ARG"
fi

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
sudo openvpn --config "$TMP_OVPN" --verb 0

# Supprimer le fichier temporaire après usage
rm -f "$TMP_OVPN"
