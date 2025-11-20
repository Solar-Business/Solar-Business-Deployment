#!/bin/bash
# Script para gestionar el broker MQTT con Docker

set -e

ACTION=${1:-start}
PROJECT_NAME="docker"

case $ACTION in
    "start"|"up")
        echo "🚀 Iniciando broker MQTT..."
        docker compose up -d
        echo "✅ Broker MQTT iniciado"
        echo "📡 Puerto MQTT: 1883"
        echo "🌐 Puerto WebSocket: 9001"
        echo ""
        echo "🔗 Para conectar desde tu backend:"
        echo "MQTT_HOST=localhost"
        echo "MQTT_PORT=1883"
        echo "MQTT_USERNAME=solar_user"
        echo "MQTT_PASSWORD=testing_password_123"
        ;;
    "stop"|"down")
        echo "⏹️  Deteniendo broker MQTT..."
        docker compose down
        echo "✅ Broker MQTT detenido"
        ;;
    "restart")
        echo "🔄 Reiniciando broker MQTT..."
        docker compose restart mqtt-broker
        echo "✅ Broker MQTT reiniciado"
        ;;
    "logs")
        echo "📋 Mostrando logs del broker MQTT..."
        docker compose logs -f mqtt-broker
        ;;
    "status")
        echo "📊 Estado del broker MQTT:"
        docker compose ps
        echo ""
        echo "🔍 Verificando conectividad..."
        if docker run --rm --network docker_mqtt-network eclipse-mosquitto:2.0 mosquitto_pub -h mqtt-broker -p 1883 -u solar_user -P testing_password_123 -t "test/status" -m "OK" 2>/dev/null; then
            echo "✅ MQTT broker funcionando correctamente"
        else
            echo "❌ Error: No se puede conectar al broker MQTT"
        fi
        ;;
    "test")
        echo "🧪 Ejecutando tests del broker MQTT..."
        ./test-mqtt.sh
        ;;
    "clean")
        echo "🧹 Limpiando datos del broker MQTT..."
        docker compose down -v
        echo "✅ Datos limpiados"
        ;;
    *)
        echo "📖 Uso: $0 {start|stop|restart|logs|status|test|clean}"
        echo ""
        echo "Comandos disponibles:"
        echo "  start   - Iniciar el broker MQTT"
        echo "  stop    - Detener el broker MQTT"
        echo "  restart - Reiniciar el broker MQTT"
        echo "  logs    - Mostrar logs en tiempo real"
        echo "  status  - Verificar estado y conectividad"
        echo "  test    - Ejecutar tests de conectividad"
        echo "  clean   - Limpiar datos y logs"
        exit 1
        ;;
esac