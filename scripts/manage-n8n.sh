#!/bin/bash

# Script para gerenciar o N8N
SCRIPT_DIR=$(dirname "$0")
COMPOSE_DIR="$SCRIPT_DIR/../infra"

show_usage() {
    echo "🔧 Gerenciador N8N"
    echo "=================="
    echo "Uso: $0 [comando]"
    echo ""
    echo "Comandos disponíveis:"
    echo "  start     - Iniciar N8N"
    echo "  stop      - Parar N8N"
    echo "  restart   - Reiniciar N8N"
    echo "  status    - Ver status"
    echo "  logs      - Ver logs"
    echo "  update    - Atualizar imagem e reiniciar"
    echo ""
}

start_n8n() {
    echo "🚀 Iniciando N8N..."
    cd "$COMPOSE_DIR"
    docker compose up -d
    echo "⏳ Aguardando N8N inicializar..."
    sleep 10
    
    # Verificar se iniciou
    if docker ps | grep -q "n8nio/n8n"; then
        echo "✅ N8N iniciado com sucesso!"
    else
        echo "❌ Falha ao iniciar N8N"
        docker compose logs n8n
    fi
}

stop_n8n() {
    echo "🛑 Parando N8N..."
    cd "$COMPOSE_DIR"
    docker compose down
    echo "✅ N8N parado"
}

restart_n8n() {
    echo "🔄 Reiniciando N8N..."
    stop_n8n
    sleep 2
    start_n8n
}

show_status() {
    echo "📊 Status atual:"
    cd "$COMPOSE_DIR"
    docker compose ps
    
    echo ""
    echo "🌐 Testando conectividade:"
    if curl -s -o /dev/null -w "%{http_code}" http://localhost:5678 | grep -q "200\|401"; then
        echo "✅ N8N está respondendo"
    else
        echo "❌ N8N não está respondendo"
    fi
}

show_logs() {
    echo "📋 Logs do N8N (últimas 50 linhas):"
    cd "$COMPOSE_DIR"
    docker compose logs --tail=50 n8n
}

update_n8n() {
    echo "🔄 Atualizando N8N..."
    cd "$COMPOSE_DIR"
    docker compose pull n8n
    docker compose up -d --force-recreate n8n
    echo "✅ N8N atualizado!"
}

# Processar comando
case $1 in
    start)
        start_n8n
        ;;
    stop)
        stop_n8n
        ;;
    restart)
        restart_n8n
        ;;
    status)
        show_status
        ;;
    logs)
        show_logs
        ;;
    update)
        update_n8n
        ;;
    *)
        show_usage
        ;;
esac
