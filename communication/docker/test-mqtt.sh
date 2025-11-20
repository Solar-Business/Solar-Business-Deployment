#!/bin/bash
# Script para verificar el funcionamiento del broker MQTT Docker

set -e

echo "🧪 Verificando broker MQTT Docker..."

# Variables
MQTT_HOST="localhost"
MQTT_PORT="1883"
MQTT_USER="solar_user"
MQTT_PASS="testing_password_123"
CONTAINER_NAME="solar-mqtt-broker"

# Test 1: Verificar que el container esté corriendo
echo ""
echo "📦 Test 1: Verificando container..."
if docker ps | grep -q $CONTAINER_NAME; then
    echo "✅ Container $CONTAINER_NAME está corriendo"
else
    echo "❌ Container $CONTAINER_NAME no está corriendo"
    echo "💡 Ejecuta: ./mqtt-docker.sh start"
    exit 1
fi

# Test 2: Verificar puertos
echo ""
echo "🔌 Test 2: Verificando puertos..."
if timeout 5 bash -c "echo >/dev/tcp/$MQTT_HOST/$MQTT_PORT" 2>/dev/null; then
    echo "✅ Puerto MQTT $MQTT_PORT disponible"
else
    echo "❌ Puerto MQTT $MQTT_PORT no disponible"
    exit 1
fi

if timeout 5 bash -c "echo >/dev/tcp/$MQTT_HOST/9001" 2>/dev/null; then
    echo "✅ Puerto WebSocket 9001 disponible"
else
    echo "⚠️  Puerto WebSocket 9001 no disponible"
fi

# Test 3: Verificar autenticación
echo ""
echo "🔐 Test 3: Verificando autenticación..."
TEST_TOPIC="test/auth/$(date +%s)"
TEST_MESSAGE="Auth test $(date)"

if timeout 10 docker run --rm --network docker_mqtt-network eclipse-mosquitto:2.0 \
   mosquitto_pub -h mqtt-broker -p 1883 -u $MQTT_USER -P $MQTT_PASS \
   -t "$TEST_TOPIC" -m "$TEST_MESSAGE" 2>/dev/null; then
    echo "✅ Autenticación funcionando"
else
    echo "❌ Error en autenticación"
    exit 1
fi

# Test 4: Verificar suscripción/publicación
echo ""
echo "📡 Test 4: Verificando pub/sub..."
ECHO_TOPIC="test/echo/$(date +%s)"
ECHO_MESSAGE="Echo test $(date +%s)"

# Iniciar suscripción en background
timeout 15 docker run --rm --network docker_mqtt-network eclipse-mosquitto:2.0 \
    mosquitto_sub -h mqtt-broker -p 1883 -u $MQTT_USER -P $MQTT_PASS \
    -t "test/echo" -C 1 > /tmp/mqtt_test_$$ 2>/dev/null &
SUB_PID=$!

sleep 2

# Publicar mensaje
docker run --rm --network docker_mqtt-network eclipse-mosquitto:2.0 \
    mosquitto_pub -h mqtt-broker -p 1883 -u $MQTT_USER -P $MQTT_PASS \
    -t "test/echo" -m "$ECHO_MESSAGE" 2>/dev/null

# Esperar resultado
wait $SUB_PID 2>/dev/null || true

if [ -f "/tmp/mqtt_test_$$" ] && grep -q "$ECHO_MESSAGE" "/tmp/mqtt_test_$$" 2>/dev/null; then
    echo "✅ Pub/Sub funcionando correctamente"
    rm -f "/tmp/mqtt_test_$$"
else
    echo "❌ Error en Pub/Sub"
    rm -f "/tmp/mqtt_test_$$"
    exit 1
fi

# Test 5: Verificar logs
echo ""
echo "📋 Test 5: Verificando logs..."
if docker logs $CONTAINER_NAME 2>&1 | grep -q "mosquitto.*starting"; then
    echo "✅ Logs del broker disponibles"
else
    echo "⚠️  No se encontraron logs de inicio"
fi

echo ""
echo "🎉 ¡Todos los tests pasaron!"
echo ""
echo "📋 Configuración para tu backend:"
echo "MQTT_HOST=localhost"
echo "MQTT_PORT=1883" 
echo "MQTT_USERNAME=solar_user"
echo "MQTT_PASSWORD=testing_password_123"
echo ""
echo "🧪 Comandos de prueba:"
echo "# Publicar desde host:"
echo "docker run --rm --network docker_mqtt-network eclipse-mosquitto:2.0 \\"
echo "  mosquitto_pub -h mqtt-broker -p 1883 -u solar_user -P testing_password_123 \\"
echo "  -t 'solar/ESP32_001/data' -m '{\"voltage\": 12.5, \"current\": 2.3}'"
echo ""
echo "# Suscribirse desde host:"  
echo "docker run --rm --network docker_mqtt-network eclipse-mosquitto:2.0 \\"
echo "  mosquitto_sub -h mqtt-broker -p 1883 -u solar_user -P testing_password_123 \\"
echo "  -t 'solar/+/data'"