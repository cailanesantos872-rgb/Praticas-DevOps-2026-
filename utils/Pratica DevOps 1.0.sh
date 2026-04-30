!/bin/bash
LOG_FILE="apache.log"
if [ ! -f "$LOG_FILE" ]; then
  echo "Arquivo apache.log não encontrado!"
  exit 1
fi
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
OUTPUT_DIR="log_analysis_$TIMESTAMP"
mkdir -p "$OUTPUT_DIR"
echo "Analisando logs..."
1. IPs únicos
awk '{print $1}' "$LOG_FILE" | sort | uniq > "$OUTPUT_DIR/1_unique_ips.txt"
2. Métodos HTTP
awk -F\" '{print $2}' "$LOG_FILE" | awk '{print $1}' | sort | uniq -c | sort -nr > "$OUTPUT_DIR/2_http_methods.txt"
3. Métodos perigosos (DELETE, PUT)
grep -E '"(DELETE|PUT)' "$LOG_FILE" > "$OUTPUT_DIR/3_dangerous_methods.txt"
URLs acessadas
awk -F\" '{print $2}' "$LOG_FILE" | awk '{print $2}' | sort | uniq -c | sort -nr > "$OUTPUT_DIR/4_urls.txt"
5. Top 10 IPs
awk '{print $1}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -10 > "$OUTPUT_DIR/5_top_ips.txt"
Relatório consolidado
REPORT="$OUTPUT_DIR/report.txt"
echo "===== RELATÓRIO DE ANÁLISE DE LOGS =====" > "$REPORT"
echo "Data: $(date)" >> "$REPORT"
echo -e "\nTop 10 IPs:" >> "$REPORT"
cat "$OUTPUT_DIR/5_top_ips.txt" >> "$REPORT"
echo -e "\nMétodos HTTP:" >> "$REPORT"
cat "$OUTPUT_DIR/2_http_methods.txt" >> "$REPORT"

echo -e "\nMétodos Perigosos:" >> "$REPORT"
wc -l "$OUTPUT_DIR/3_dangerous_methods.txt" >> "$REPORT"

echo -e "\nTotal de IPs únicos:" >> "$REPORT"
wc -l "$OUTPUT_DIR/1_unique_ips.txt" >> "$REPORT"

echo "Análise concluída! Resultados em: $OUTPUT_DIR"
