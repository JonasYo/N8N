#!/bin/bash

# Atualiza pacotes
sudo apt update && sudo apt upgrade -y

# Instala Docker
sudo apt install -y docker.io docker-compose nginx certbot python3-certbot-nginx

# Ativa Docker
sudo systemctl enable docker
sudo systemctl start docker

# Copia configuração Nginx
sudo cp nginx/n8n.conf /etc/nginx/sites-available/n8n
sudo ln -s /etc/nginx/sites-available/n8n /etc/nginx/sites-enabled/
sudo rm /etc/nginx/sites-enabled/default

# Reinicia Nginx
sudo systemctl restart nginx

# Gera SSL
sudo certbot --nginx --non-interactive --agree-tos -d $1 -m $2

# Cria estrutura persistente
mkdir -p ~/n8n-vps/n8n_data
