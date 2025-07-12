#!/bin/bash

echo "🔧 Script de resolução de problemas N8N"
echo "========================================"

# Verifica e reinicia Docker se necessário
echo "🐳 Verificando Docker..."
if ! systemctl is-active --quiet docker; then
    echo "⚠️ Docker não está rodando. Iniciando..."
    sudo systemctl start docker
    sleep 5
fi

# Verifica se o container está rodando
if ! docker compose ps | grep -q "n8n.*Up"; then
    echo "🔄 Container N8N não está rodando. Reiniciando..."
    docker compose down
    docker compose up -d
    sleep 15
fi

# Verifica Nginx
echo "🌐 Verificando Nginx..."
if ! systemctl is-active --quiet nginx; then
    echo "⚠️ Nginx não está rodando. Iniciando..."
    sudo systemctl start nginx
fi

# Testa conectividade
echo "🔍 Testando conectividade..."
if curl -s -o /dev/null -w "%{http_code}" http://localhost:5678 | grep -q "200\|401"; then
    echo "✅ N8N está respondendo localmente!"
else
    echo "❌ N8N não está respondendo. Verificando logs..."
    docker compose logs --tail=10 n8n
fi

# Verifica portas
echo "📊 Portas em uso:"
sudo netstat -tlnp | grep -E ':80|:5678'

echo -e "\n🌍 URLs para testar:"
echo "- Diretamente: http://54.94.117.140:5678"
echo "- Via Nginx: http://54.94.117.140"
