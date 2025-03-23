## Connexion à Ubuntu
Pour vous connecter à votre machine Ubuntu, utilisez la commande suivante :
```bash
ssh nom_utilisateur@ip_machine
```

## Installation de Docker

### Mise à jour du système
Commencez par mettre à jour votre système Ubuntu :
```bash
sudo apt update && sudo apt -y full-upgrade
```

### Installation des dépendances
Installez les dépendances nécessaires pour Docker :
```bash
sudo apt install curl apt-transport-https ca-certificates software-properties-common
```

### Ajout de la clé GPG
Ajoutez la clé GPG officielle de Docker :
```bash
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
```

### Ajout de la source
Ajoutez la source de Docker à votre liste de dépôts :
```bash
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

### Installation de Docker Community Edition
Installez Docker Community Edition :
```bash
sudo apt install docker-ce
```

### Vérification du fonctionnement de Docker
Vérifiez que Docker fonctionne correctement :
```bash
sudo systemctl status docker
```

## Utilisation de Docker

### Choix d'une image
Allez sur [Docker Hub](https://hub.docker.com) pour choisir une image.

### Téléchargement d'une image
Téléchargez une image Docker :
```bash
sudo docker pull nom_de_l'image
```

### Lancement du conteneur
Lancez le conteneur pour la première fois :
```bash
sudo docker run nom_de_l'image
```

Lancez le conteneur en mode arrière-plan (démon) :
```bash
sudo docker run nom_de_l'image -d
```

### Voir les conteneurs en cours d'exécution
Listez les conteneurs actifs :
```bash
sudo docker ps
```

Listez tous les conteneurs, y compris ceux qui ne sont pas en cours d'exécution :
```bash
sudo docker ps -a
```

### Connexion au conteneur
Connectez-vous en ligne de commande (bash) dans le conteneur :
```bash
sudo docker exec -it nom_conteneur /bin/bash
```

## Installation de Portainer

### Téléchargement de Portainer
Téléchargez l'image Portainer :
```bash
sudo docker pull portainer/portainer-ce
```

### Lancement de Portainer
Lancez Portainer en mode démon :
```bash
sudo docker run -d -p 9000:9000 --restart always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest
```
