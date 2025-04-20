#!/bin/bash

export RESTIC_REPOSITORY="/home/nicolas/docker-backups"
export RESTIC_PASSWORD="votre_mot_de_passe_ultra_securise"

volumes_dir="/var/lib/docker/volumes"

set -e

echo "===  Début du script de backup Docker volumes ==="

# Récupérer tous les conteneurs actifs
containers=$(docker ps -q)
echo " Conteneurs actifs trouvés : $containers"

# Tableau pour stocker les chemins des volumes à sauvegarder
declare -a volumes_to_backup=()

# Parcourir chaque conteneur pour trouver les volumes associés
for container in $containers; do
    echo " Inspection du conteneur : $container"
    # Récupérer les points de montage de type "volume"
    mounts=$(docker inspect --format '{{ range .Mounts }}{{ if eq .Type "volume" }}{{ .Name }} {{ end }}{{ end }}' "$container")
    echo " Volumes trouvés pour $container : $mounts"
    for volume in $mounts; do
        # Adapter le chemin selon ton installation Docker
        volume_path="${volumes_dir}/${volume}/_data"
        echo " Chemin du volume : $volume_path"
        if [[ ! " ${volumes_to_backup[@]} " =~ " ${volume_path} " ]]; then
            echo " Ajout du volume à la liste de backup : $volume_path"
            volumes_to_backup+=("$volume_path")
        else
            echo " Volume déjà dans la liste, on saute : $volume_path"
        fi
    done
done

echo " Liste finale des volumes à sauvegarder :"
for v in "${volumes_to_backup[@]}"; do
    echo "    $v"
done

# Sauvegarde de chaque volume avec restic
for volume_path in "${volumes_to_backup[@]}"; do
    if [ -d "$volume_path" ]; then
        echo " Lancement du backup pour : $volume_path"
        /usr/bin/restic backup "$volume_path" --exclude="*.tmp" --tag=docker-backup --exclude-if-present=".no-backup"
        echo " Backup terminé pour : $volume_path"
    else
        echo " ATTENTION : Le chemin n'existe pas ou n'est pas un dossier : $volume_path"
    fi  # <-- Correction ici : le 'fi' était manquant
done

echo " Lancement de la rotation des sauvegardes (restic forget)"
/usr/bin/restic forget --keep-daily 7 --keep-weekly 4 --prune
echo " Rotation des sauvegardes terminée"

echo "===  Fin du script de backup Docker volumes ==="
