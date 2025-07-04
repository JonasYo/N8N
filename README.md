# N8N Docker Setup

Configuração para executar N8N em um VPS usando Docker e Nginx.

## 🚀 Deploy Rápido

```bash
# 1. Executar deploy
./scripts/deploy.sh

# 2. Verificar status
./scripts/check-status.sh

# 3. Resolver problemas (se necessário)
./scripts/troubleshoot.sh
```

## 🌐 URLs de Acesso

- **Direto (porta 5678)**: http://18.231.114.87:5678
- **Via Nginx (porta 80)**: http://18.231.114.87

## 🔧 Credenciais

- **Usuário**: admin
- **Senha**: @dm1nP@ssw0rd

## 📋 Resolução de Problemas

### N8N não abre

1. Verifique se o container está rodando: `docker compose ps`
2. Verifique os logs: `docker compose logs n8n`
3. Teste conectividade local: `curl http://localhost:5678`
4. Execute o script de diagnóstico: `./scripts/troubleshoot.sh`

### Container não inicia

```bash
# Reiniciar completamente
docker compose down
docker compose up -d

# Verificar logs
docker compose logs -f n8n
```

### Nginx não funciona

```bash
# Verificar status
sudo systemctl status nginx

# Testar configuração
sudo nginx -t

# Reiniciar
sudo systemctl restart nginx
```

## 🏗️ Estrutura do Projeto

```
├── docker-compose.yml      # Configuração do container N8N
├── infra/
│   └── nginx/
│       └── sites-available/
│           └── n8n.conf   # Configuração do Nginx
└── scripts/
    ├── deploy.sh          # Script de deploy
    ├── check-status.sh    # Verificação de status
    └── troubleshoot.sh    # Resolução de problemas
```
