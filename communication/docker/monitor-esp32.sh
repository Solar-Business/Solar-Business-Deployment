#!/bin/bash
# Monitor específico para ESP32

echo "📡 MONITOR ESP32 EN TIEMPO REAL"
echo "=============================="
echo ""
echo "Escuchando TODOS los mensajes del ESP32_001..."
echo "🛑 Ctrl+C para salir"
echo ""
echo "Topics monitoreados:"
echo "- solar/ESP32_001/+  (todos los subtopics)"
echo "- test/+            (pruebas)"
echo ""
sleep 2

# Monitor específico para ESP32
docker run --rm -it --network host eclipse-mosquitto:2.0 \
  mosquitto_sub -h localhost -p 1883 -u solar_user -P testing_password_123 \
  -t "solar/ESP32_001/+" \
  -t "test/+" \
  -v | while IFS= read -r line; do
    # Formatear salida con timestamp
    echo "[$(date '+%H:%M:%S')] $line"
  done