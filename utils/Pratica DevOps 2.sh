#!/bin/bash

# Cara, primeira coisa: ver se passou o arquivo
if [ $# -ne 1 ]; then
    echo "Uso: $0 <arquivo_log>"
    exit 1
fi

LOG_FILE="$1"

# Se o arquivo não existir, nem adianta continuar
if [ ! -f "$LOG_FILE" ]; then
    echo "Arquivo não encontrado!"
    exit 1
fi

# Criando uma pasta com data/hora pra não misturar análises
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
OUTPUT_DIR="log_analysis_${TIMESTAMP}"
mkdir -p "$OUTPUT_DIR"

echo "🔎 Lendo o log e organizando a bagunça..."

# 1. IPs únicos (quem acessou o servidor)
# Sempre é a primeira coluna
awk '{print $1}' "$LOG_FILE" | sort | uniq > "$OUTPUT_DIR/1_unique_ips.txt"

# 2. Métodos HTTP (GET, POST, etc)
# A gente pega o que tá entre aspas e extrai o método
awk -F\" '{print $2}' "$LOG_FILE" | awk '{print $1}' | sort | uniq -c | sort -nr > "$OUTPUT_DIR/2_http_methods.txt"

# 3. Métodos suspeitos (DELETE e PUT)
# Aqui já é aquele radar de segurança ligado
grep -E '"(DELETE|PUT) ' "$LOG_FILE" > "$OUTPUT_DIR/3_dangerous_methods.txt"

# 4. URLs acessadas (o que o pessoal mais pediu)
awk -F\" '{print $2}' "$LOG_FILE" | awk '{print $2}' | sort | uniq -c | sort -nr > "$OUTPUT_DIR/4_urls.txt"

# 5. Top 10 IPs (quem mais ficou “batendo na porta”)
awk '{print $1}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -10 > "$OUTPUT_DIR/5_top_ips.txt"

