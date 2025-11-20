#!/bin/bash
# show-connections.sh - Mostrar conexiones MQTT activas

echo "🔍 DISPOSITIVOS CONECTADOS AL BROKER MQTT"
echo "=========================================="
echo ""

echo "📊 Estadísticas del broker:"
docker exec solar-mqtt-broker mosquitto_sub -h localhost -p 1883 -u solar_user -P testing_password_123 -t '$SYS/broker/clients/connected' -C 1 2>/dev/null | while read count; do
    echo "   Clientes conectados: $count"
done

docker exec solar-mqtt-broker mosquitto_sub -h localhost -p 1883 -u solar_user -P testing_password_123 -t '$SYS/broker/clients/total' -C 1 2>/dev/null | while read total; do
    echo "   Total de clientes: $total"
done

echo ""
echo "📡 Últimas conexiones (logs del broker):"
docker logs solar-mqtt-broker --tail 10 | grep -E "(New connection|New client connected|disconnected)" | tail -5

echo ""
echo "🔄 Para monitoreo en tiempo real, ejecuta:"
echo "   ./monitor-esp32.sh"