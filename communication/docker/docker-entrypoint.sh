#!/bin/sh
# Docker entrypoint for Solar Business MQTT Broker

set -e

echo "🐳 Starting Solar Business MQTT Broker Container..."
echo "📅 Date: $(date)"
echo "🔧 Mosquitto version: $(mosquitto -h | head -1)"
echo "👤 Running as user: $(whoami)"

# Verificar que los archivos de configuración existen
echo "📁 Checking configuration files..."
if [ ! -f /mosquitto/config/mosquitto.conf ]; then
    echo "❌ Error: mosquitto.conf not found!"
    exit 1
fi

if [ ! -f /mosquitto/config/passwd ]; then
    echo "❌ Error: passwd file not found!"
    exit 1
fi

if [ ! -f /mosquitto/config/acl.conf ]; then
    echo "❌ Error: acl.conf not found!"
    exit 1
fi

echo "✅ Configuration files OK"

# Verificar permisos de directorios
echo "🔐 Checking permissions..."
ls -la /mosquitto/config/
ls -la /mosquitto/data/ 2>/dev/null || echo "Data directory will be created"
ls -la /mosquitto/log/ 2>/dev/null || echo "Log directory will be created"

# Crear directorios de datos si no existen
mkdir -p /mosquitto/data /mosquitto/log

echo "🚀 Starting Mosquitto MQTT Broker..."
echo "📡 MQTT Port: ${MQTT_PORT:-1883}"
echo "🌐 WebSocket Port: ${MQTT_WS_PORT:-9001}"
echo "👤 MQTT User: ${MQTT_USER:-solar_user}"
echo "🔒 Authentication: Enabled"
echo "📋 ACL: Enabled"

# Ejecutar Mosquitto con la configuración
exec "$@"