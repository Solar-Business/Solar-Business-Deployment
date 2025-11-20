#!/bin/bash
# Prueba de conexión ESP32 <-> Broker MQTT Docker

echo "🔗 PRUEBA DE CONEXIÓN ESP32 ↔ BROKER MQTT"
echo "=========================================="
echo ""

# Variables del broker (deben coincidir con tu ESP32)
MQTT_USER="solar_user"
MQTT_PASS="testing_password_123"
ESP32_DEVICE_ID="ESP32_001"
TOPIC_BASE="solar/$ESP32_DEVICE_ID"

echo "📋 Configuración de prueba:"
echo "Device ID: $ESP32_DEVICE_ID" 
echo "Topic base: $TOPIC_BASE"
echo "Usuario: $MQTT_USER"
echo ""

# Verificar que el broker esté corriendo
echo "1️⃣ Verificando broker Docker..."
if ! docker ps | grep -q "solar-mqtt-broker"; then
    echo "❌ El broker MQTT no está corriendo"
    echo "💡 Ejecuta: ./mqtt-docker.sh start"
    exit 1
fi
echo "✅ Broker Docker funcionando"
echo ""

# Función para mostrar la IP de la computadora
echo "2️⃣ IP de tu computadora para ESP32:"
echo "-----------------------------------"
echo "🔍 Tu ESP32 debe usar una de estas IPs como MQTT_BROKER:"

# Intentar obtener IP local
if command -v hostname >/dev/null; then
    hostname -I 2>/dev/null | tr ' ' '\n' | grep -E '^192\.|^10\.|^172\.' | head -3
fi

# Método alternativo para WSL
if command -v ip >/dev/null; then
    ip route get 8.8.8.8 2>/dev/null | grep -oP 'src \K\S+' | head -1
fi

echo ""
echo "💡 Cambia esta línea en tu config_solar.py:"
echo "MQTT_BROKER = \"LA_IP_DE_ARRIBA\""
echo ""

# Simular datos del ESP32
echo "3️⃣ Simulando datos del ESP32..."
echo "-------------------------------"

ESP32_DATA='{
  "deviceId": "'$ESP32_DEVICE_ID'",
  "voltage": 12.45,
  "current": 2.1,
  "power": 26.15,
  "energy": 156.8,
  "temperature": 28.5,
  "humidity": 65.2,
  "irradiance": 950.0,
  "timestamp": '$(date +%s)',
  "datetime": "'$(date -Iseconds)'"
}'

echo "Datos que enviaría el ESP32:"
echo "$ESP32_DATA" | python3 -m json.tool 2>/dev/null || echo "$ESP32_DATA"
echo ""

echo "Enviando datos simulados del ESP32..."
if docker run --rm --network docker_mqtt-network eclipse-mosquitto:2.0 \
   mosquitto_pub -h mqtt-broker -p 1883 -u "$MQTT_USER" -P "$MQTT_PASS" \
   -t "$TOPIC_BASE/data" -m "$ESP32_DATA" 2>/dev/null; then
    echo "✅ Datos del ESP32 enviados correctamente"
else
    echo "❌ Error enviando datos del ESP32"
    exit 1
fi
echo ""

# Simular mensaje de estado
echo "4️⃣ Simulando mensaje de estado ESP32..."
echo "---------------------------------------"

STATUS_DATA='{
  "deviceId": "'$ESP32_DEVICE_ID'",
  "status": "online",
  "message": "Prueba de conexion desde script",
  "timestamp": '$(date +%s)'
}'

echo "Enviando estado del ESP32..."
if docker run --rm --network docker_mqtt-network eclipse-mosquitto:2.0 \
   mosquitto_pub -h mqtt-broker -p 1883 -u "$MQTT_USER" -P "$MQTT_PASS" \
   -t "$TOPIC_BASE/status" -m "$STATUS_DATA" 2>/dev/null; then
    echo "✅ Estado del ESP32 enviado correctamente"
else
    echo "❌ Error enviando estado del ESP32"
fi
echo ""

# Verificar logs del broker
echo "5️⃣ Verificando logs del broker..."
echo "---------------------------------"
echo "Últimos mensajes en el broker:"
docker logs solar-mqtt-broker --tail 5
echo ""

echo "🎉 PRUEBA COMPLETADA"
echo "==================="
echo ""
echo "✅ Si ves este mensaje, la conexión MQTT funciona correctamente"
echo ""
echo "📋 Para tu ESP32, usa esta configuración en config_solar.py:"
echo ""
echo "MQTT_BROKER = \"$(hostname -I | awk '{print $1}' || echo 'TU_IP_AQUI')\""
echo "MQTT_PORT = 1883"
echo "MQTT_USER = \"$MQTT_USER\""
echo "MQTT_PASS = \"$MQTT_PASS\""
echo "DEVICE_ID = \"$ESP32_DEVICE_ID\""
echo ""
echo "📡 Topics que funcionan:"
echo "- $TOPIC_BASE/data (datos del sensor)"
echo "- $TOPIC_BASE/status (estado del dispositivo)"
echo "- $TOPIC_BASE/config (configuración)"
echo ""
echo "🔄 Para monitorear mensajes del ESP32 en tiempo real:"
echo "./monitor.sh"
echo ""
echo "✨ ¡Tu ESP32 está listo para conectarse!"