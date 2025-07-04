#!/bin/bash

# Script de verificação rápida do N8N
echo "🔍 Status N8N - Verificação Rápida"
echo "================================="

# 1. Verificar containers Docker
echo "📦 Containers:"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | grep -E "NAMES|n8n"

# 2. Verificar se N8N responde
echo ""
echo "🌐 Testando N8N (localhost:5678):"
if curl -s -o /dev/null -w "%{http_code}" http://localhost:5678 | grep -q "200\|401"; then
    echo "✅ N8N está respondendo"
else
    echo "❌ N8N não está respondendo"
fi

# 3. Verificar Nginx
echo ""
echo "🌐 Status Nginx:"
if systemctl is-active --quiet nginx; then
    echo "✅ Nginx está rodando"
else
    echo "❌ Nginx não está rodando"
fi

# 4. Testar acesso via Nginx
echo ""
echo "🔗 Testando acesso via Nginx (/n8n/):"
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost/n8n/ 2>/dev/null)
case $HTTP_CODE in
    200|401) echo "✅ Funcionando (HTTP $HTTP_CODE)" ;;
    502) echo "❌ Bad Gateway (HTTP $HTTP_CODE)" ;;
    *) echo "⚠️ Código HTTP: $HTTP_CODE" ;;
esac

# 5. Mostrar IP público para teste
echo ""
echo "📍 Para testar externamente:"
PUBLIC_IP=$(curl -s ifconfig.me 2>/dev/null || echo "SEU_IP_AQUI")
echo "   http://$PUBLIC_IP/n8n/"
