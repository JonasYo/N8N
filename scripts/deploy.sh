#!/bin/bash

echo "🚀 Iniciando deploy do N8N..."

# Para containers existentes
echo "⏹️ Parando containers..."
docker compose down

# Atualiza imagens
echo "📦 Baixando imagens..."
docker compose pull

# Inicia containers
echo "🔄 Iniciando containers..."
docker compose up -d

# Aguarda um momento para o container inicializar
echo "⏳ Aguardando inicialização..."
sleep 10

# Verifica status
echo "🔍 Verificando status..."
docker compose ps

# Limpa recursos não utilizados
echo "🧹 Limpando recursos..."
docker system prune -f

echo "✅ Deploy concluído!"
echo "🌐 Acesse: http://18.231.114.87:5678"
