FROM n8nio/n8n:latest

# Exemplo: Copiar arquivos custom (opcional)
# COPY ./custom /home/node/.n8n/custom

# Definir variáveis de ambiente default (opcional)
ENV N8N_BASIC_AUTH_ACTIVE=true \
    N8N_BASIC_AUTH_USER=admin \
    N8N_BASIC_AUTH_PASSWORD=admin \
    N8N_PORT=5678

# Entrypoint padrão
CMD ["n8n"]
