#!/bin/bash

echo "🔍 Verificando status dos serviços N8N..."
echo "============================================="

echo -e "\n📦 Status do Docker:"
sudo systemctl status docker --no-pager

echo -e "\n🐳 Containers rodando:"
docker ps

echo -e "\n🌐 Status do Nginx:"
sudo systemctl status nginx --no-pager

echo -e "\n🔗 Portas em uso:"
sudo netstat -tlnp | grep -E ':80|:5678'

echo -e "\n📋 Logs do container N8N (últimas 20 linhas):"
docker compose logs --tail=20 n8n

echo -e "\n🌍 Testando conectividade local:"
curl -I http://localhost:5678 2>/dev/null || echo "❌ N8N não está respondendo localmente"

echo -e "\n✅ Verificação concluída!"
