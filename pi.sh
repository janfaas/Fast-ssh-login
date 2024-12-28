#!/bin/bash

# Bestand om de configuratie op te slaan
CONFIG_FILE="$HOME/.ssh_login_config"

# Controleer of het configuratiebestand bestaat en laad de opgeslagen instellingen
if [ -f "$CONFIG_FILE" ]; then
    # Laad de opgeslagen configuraties in de variabelen
    source "$CONFIG_FILE"
else
    # Als het bestand niet bestaat, vraag dan om de gegevens en sla ze op
    echo "Voer de gebruikersnaam in:"
    read USERNAME
    echo "Voer het IP-adres of de hostnaam van de server in:"
    read SERVER_IP
    echo "Wil je een SSH-sleutel gebruiken? (ja/nee)"
    read USE_KEY

    if [[ "$USE_KEY" == "ja" ]]; then
        echo "Voer het pad naar de privé-SSH-sleutel in (bijv. ~/.ssh/id_rsa):"
        read SSH_KEY_PATH
    fi

    # Sla de gegevens op in het configuratiebestand
    echo "USERNAME=$USERNAME" > "$CONFIG_FILE"
    echo "SERVER_IP=$SERVER_IP" >> "$CONFIG_FILE"
    echo "USE_KEY=$USE_KEY" >> "$CONFIG_FILE"
    if [[ "$USE_KEY" == "ja" ]]; then
        echo "SSH_KEY_PATH=$SSH_KEY_PATH" >> "$CONFIG_FILE"
    fi
fi

# Maak verbinding via SSH zonder opnieuw om wachtwoord te vragen
if [[ "$USE_KEY" == "ja" ]]; then
    # Gebruik de SSH-sleutel
    ssh -i "$SSH_KEY_PATH" "$USERNAME@$SERVER_IP"
else
    # Gebruik wachtwoord inloggen
    ssh "$USERNAME@$SERVER_IP"
fi

