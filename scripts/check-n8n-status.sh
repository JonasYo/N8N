#!/bin/bash

echo "🔍 Verificando status do N8N na VPS..."
echo "====================================="

# Verificar se Docker está rodando
echo ""
echo "🐳 Verificando Docker..."
if ! systemctl is-active --quiet docker; then
    echo "❌ Docker não está rodando"
    echo "🚀 Tentando iniciar Docker..."
    sudo systemctl start docker
    sleep 3
else
    echo "✅ Docker está rodando"
fi

# Verificar containers
echo ""
echo "📦 Status dos containers:"
docker ps -a --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}\t{{.Image}}"

# Verificar especificamente o container n8n
echo ""
echo "🔍 Verificando container N8N..."
N8N_CONTAINER=$(docker ps -q --filter "ancestor=n8nio/n8n:latest")
if [ ! -z "$N8N_CONTAINER" ]; then
    echo "✅ Container N8N está rodando (ID: $N8N_CONTAINER)"
    
    # Verificar logs do container
    echo ""
    echo "📋 Últimos logs do N8N:"
    docker logs --tail 10 $N8N_CONTAINER
else
    echo "❌ Container N8N não está rodando"
    
    # Verificar se existe algum container parado
    STOPPED_CONTAINER=$(docker ps -aq --filter "ancestor=n8nio/n8n:latest")
    if [ ! -z "$STOPPED_CONTAINER" ]; then
        echo "⚠️ Container N8N existe mas está parado"
        echo "📋 Logs do container parado:"
        docker logs --tail 15 $STOPPED_CONTAINER
    fi
fi

# Verificar conectividade local
echo ""
echo "🌐 Testando conectividade local..."
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:5678 2>/dev/null || echo "000")
case $HTTP_CODE in
    200|401)
        echo "✅ N8N está respondendo na porta 5678 (HTTP $HTTP_CODE)"
        ;;
    000)
        echo "❌ Não foi possível conectar na porta 5678"
        ;;
    *)
        echo "⚠️ N8N respondeu com código HTTP $HTTP_CODE"
        ;;
esac

# Verificar se a porta está escutando
echo ""
echo "🔌 Portas em uso:"
if command -v netstat > /dev/null; then
    netstat -tlnp | grep -E ':5678|:80' | head -10
elif command -v ss > /dev/null; then
    ss -tlnp | grep -E ':5678|:80' | head -10
else
    echo "⚠️ netstat/ss não disponível"
fi

# Verificar nginx
echo ""
echo "🌐 Verificando Nginx..."
if systemctl is-active --quiet nginx; then
    echo "✅ Nginx está rodando"
    
    # Testar configuração do nginx
    if nginx -t 2>/dev/null; then
        echo "✅ Configuração do Nginx está válida"
    else
        echo "❌ Configuração do Nginx tem erros:"
        nginx -t
    fi
else
    echo "❌ Nginx não está rodando"
fi

# Verificar acesso externo
echo ""
echo "🌍 Testando acesso externo..."
EXTERNAL_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://127.0.0.1/n8n/ 2>/dev/null || echo "000")
case $EXTERNAL_CODE in
    200|401|301|302)
        echo "✅ Acesso via Nginx funcionando (HTTP $EXTERNAL_CODE)"
        ;;
    502)
        echo "❌ Bad Gateway - Nginx não consegue conectar ao N8N"
        ;;
    000)
        echo "❌ Não foi possível conectar via Nginx"
        ;;
    *)
        echo "⚠️ Nginx respondeu com código HTTP $EXTERNAL_CODE"
        ;;
esac

echo ""
echo "📝 URLs para testar:"
echo "   - N8N direto: http://$(curl -s ifconfig.me 2>/dev/null || echo 'SEU_IP'):5678"
echo "   - Via Nginx: http://$(curl -s ifconfig.me 2>/dev/null || echo 'SEU_IP')/n8n/"
echo ""
echo "🔧 Para mais detalhes, execute: docker logs <container_id>"
