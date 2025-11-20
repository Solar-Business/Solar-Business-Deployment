#!/bin/bash
# Monitor en tiempo real de mensajes MQTT

echo "📡 MONITOR MQTT EN TIEMPO REAL"
echo "=============================="
echo ""
echo "Este script te mostrará TODOS los mensajes que lleguen al broker."
echo "Útil para ver cuando tu ESP32 envíe datos reales."
echo ""
echo "🛑 Para salir, presiona Ctrl+C"
echo ""
echo "🔍 Escuchando en topics:"
echo "- solar/+/data (datos de paneles)"
echo "- sensors/+/data (sensores)" 
echo "- device/+/data (dispositivos)"
echo "- test/+ (pruebas)"
echo ""
echo "Iniciando monitor..."
sleep 2

# Ejecutar monitor con host network
docker run --rm --network host eclipse-mosquitto:2.0 \
  mosquitto_sub -h localhost -p 1883 \
  -t "solar/+/data" -t "sensors/+/data" -t "device/+/data" -t "test/+" \
  -v | while IFS= read -r line; do
    echo "[$(date '+%H:%M:%S')] $line"
  done