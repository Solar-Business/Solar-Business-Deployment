#!/bin/bash
# Script de testing para MQTT Docker Broker

set -e

MQTT_HOST=${1:-"192.168.56.20"}
MQTT_PORT=${2:-"1883"} 
MQTT_USER=${3:-"solar_user"}
MQTT_PASS=${4:-"testing_password_123"}

echo "🐳 Testing Docker MQTT Broker"
echo "================================"
echo "📡 Host: $MQTT_HOST:$MQTT_PORT"
echo "👤 User: $MQTT_USER"
echo "📅 Date: $(date)"
echo ""

# Test 1: Conectividad básica
echo "🔌 Test 1: Network connectivity..."
if ping -c 2 $MQTT_HOST >/dev/null 2>&1; then
    echo "✅ Host reachable"
else
    echo "❌ Host not reachable"
    exit 1
fi

# Test 2: Puerto MQTT
echo ""
echo "🔗 Test 2: MQTT Port..."
if timeout 5 bash -c "echo >/dev/tcp/$MQTT_HOST/$MQTT_PORT" 2>/dev/null; then
    echo "✅ Port $MQTT_PORT is open"
else
    echo "❌ Port $MQTT_PORT not available"
    exit 1
fi

# Test 3: Autenticación y publicación
echo ""
echo "📤 Test 3: MQTT Publish..."
TEST_TOPIC="test/docker/$(date +%s)"
TEST_MESSAGE="Docker MQTT Test from $(hostname) at $(date)"

if mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -u $MQTT_USER -P $MQTT_PASS -t "$TEST_TOPIC" -m "$TEST_MESSAGE" 2>/dev/null; then
    echo "✅ Message published successfully"
else
    echo "❌ Failed to publish message"
    exit 1
fi

# Test 4: Suscripción
echo ""
echo "📥 Test 4: MQTT Subscribe..."
TEMP_FILE="/tmp/mqtt_docker_test_$$"

timeout 10 mosquitto_sub -h $MQTT_HOST -p $MQTT_PORT -u $MQTT_USER -P $MQTT_PASS -t "test/echo" -C 1 > "$TEMP_FILE" 2>/dev/null &
SUB_PID=$!

sleep 2

ECHO_MESSAGE="Echo test $(date +%s)"
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -u $MQTT_USER -P $MQTT_PASS -t "test/echo" -m "$ECHO_MESSAGE" 2>/dev/null

wait $SUB_PID 2>/dev/null

if [ -f "$TEMP_FILE" ] && grep -q "$ECHO_MESSAGE" "$TEMP_FILE" 2>/dev/null; then
    echo "✅ Subscribe/Publish cycle successful"
    rm -f "$TEMP_FILE"
else
    echo "❌ Subscribe/Publish cycle failed"
    rm -f "$TEMP_FILE"
    exit 1
fi

# Test 5: WebSocket
echo ""
echo "🌐 Test 5: WebSocket Port..."
WS_PORT="9001"
if timeout 5 bash -c "echo >/dev/tcp/$MQTT_HOST/$WS_PORT" 2>/dev/null; then
    echo "✅ WebSocket port $WS_PORT is open"
else
    echo "⚠️  WebSocket port $WS_PORT not available (may be normal)"
fi

# Test 6: Prueba de topics específicos para Solar Business
echo ""
echo "🌞 Test 6: Solar Business Topics..."
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -u $MQTT_USER -P $MQTT_PASS -t "solar/ESP32_001/data" -m '{"voltage": 12.5, "current": 2.3, "temperature": 25.4}' 2>/dev/null && echo "✅ Solar data published"

mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -u $MQTT_USER -P $MQTT_PASS -t "sensors/temp_01/data" -m '{"temperature": 23.5, "humidity": 60.2}' 2>/dev/null && echo "✅ Sensor data published"

echo ""
echo "🎉 All tests passed!"
echo ""
echo "📋 Configuration for your backend:"
echo "MQTT_HOST=$MQTT_HOST"
echo "MQTT_PORT=$MQTT_PORT"
echo "MQTT_USERNAME=$MQTT_USER"
echo "MQTT_PASSWORD=$MQTT_PASS"
echo ""
echo "🚀 Ready for ESP32 and backend integration!"
echo ""
echo "📖 Example commands:"
echo "# Publish solar data:"
echo "mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -u $MQTT_USER -P $MQTT_PASS -t 'solar/ESP32_001/data' -m '{\"voltage\": 12.5, \"current\": 2.3}'"
echo ""
echo "# Subscribe to all solar data:"
echo "mosquitto_sub -h $MQTT_HOST -p $MQTT_PORT -u $MQTT_USER -P $MQTT_PASS -t 'solar/+/data'"
echo ""
echo "# Subscribe to all sensors:"
echo "mosquitto_sub -h $MQTT_HOST -p $MQTT_PORT -u $MQTT_USER -P $MQTT_PASS -t 'sensors/+/data'"