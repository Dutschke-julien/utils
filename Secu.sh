#!/bin/bash

# Vérifier si le fichier de journal existe, sinon le créer


# Répertoire personnel de l'utilisateur
user_home="/home/utilisateur"

# Fichier d'historique des commandes
history_file="$user_home/.bash_history"

# Fichier de journal personnalisé
log_file="$user_home/.log_cmd"

if [ ! -f "$log_file" ]; then
    touch "$log_file"
fi
# Chemin vers le fichier .zshrc
zshrc_file="$HOME/.zshrc"

# Ligne à ajouter dans le .zshrc
line_to_add="nohup /chemin/vers/ton/script.sh &"

# Vérifie si la ligne est déjà présente dans le .zshrc
if ! grep -qF "$line_to_add" "$zshrc_file"; then
    # Ajoute la ligne à la fin du .zshrc
    echo "$line_to_add" >> "$zshrc_file"
fi

# Fonction pour enregistrer une commande dans le journal
log_command() {
    local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    local current_dir=$(pwd)
    local command="$1"
    echo "[$timestamp] Répertoire : $current_dir" >> "$log_file"
    echo "[$timestamp] Commande   : $command" >> "$log_file"
    echo "----------------------------------------" >> "$log_file"
}

# Lire l'historique des commandes depuis la dernière ligne lue
last_line=$(cat "$log_file" | wc -l)
new_commands=$(tail -n +$last_line "$history_file")

# Enregistrer les nouvelles commandes dans le fichier de journal
while IFS= read -r command; do
    log_command "$command"
done <<< "$new_commands"
