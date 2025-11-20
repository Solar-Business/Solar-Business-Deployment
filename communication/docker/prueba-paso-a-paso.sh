#!/bin/bash
# Guía paso a paso para probar MQTT

echo "🧪 GUÍA PASO A PASO - Testing MQTT Broker"
echo "========================================="
echo ""

echo "📋 PASO 1: Verificar que el container esté corriendo"
echo "Comando: docker compose ps"
echo "Resultado esperado: Ver 'solar-mqtt-broker' con STATUS 'Up'"
echo ""
docker compose ps
echo ""

read -p "¿Ves el container corriendo? (y/n): " container_ok
if [[ $container_ok != "y" ]]; then
    echo "❌ Problema: El container no está corriendo"
    echo "💡 Solución: Ejecuta './mqtt-docker.sh start'"
    exit 1
fi

echo ""
echo "📋 PASO 2: Probar conexión básica"
echo "Vamos a intentar conectarnos al broker..."
echo ""

echo "Comando que ejecutaré:"
echo "docker run --rm --network docker_mqtt-network eclipse-mosquitto:2.0 \\"
echo "  mosquitto_pub -h mqtt-broker -p 1883 -u solar_user -P testing_password_123 \\"
echo "  -t 'test/simple' -m 'Hola MQTT!'"
echo ""

if docker run --rm --network docker_mqtt-network eclipse-mosquitto:2.0 \
   mosquitto_pub -h mqtt-broker -p 1883 -u solar_user -P testing_password_123 \
   -t 'test/simple' -m 'Hola MQTT!' 2>/dev/null; then
    echo "✅ ¡Conexión exitosa! El broker acepta mensajes"
else
    echo "❌ Error de conexión"
    echo "💡 Revisa los logs: ./mqtt-docker.sh logs"
    exit 1
fi

echo ""
echo "📋 PASO 3: Probar suscripción y recepción"
echo "Ahora vamos a suscribirnos y recibir un mensaje..."
echo ""

echo "Iniciando suscriptor en background..."
timeout 10 docker run --rm --network docker_mqtt-network eclipse-mosquitto:2.0 \
    mosquitto_sub -h mqtt-broker -p 1883 -u solar_user -P testing_password_123 \
    -t "test/paso3" -C 1 > /tmp/mqtt_resultado 2>/dev/null &

sleep 2
echo "Enviando mensaje de prueba..."
docker run --rm --network docker_mqtt-network eclipse-mosquitto:2.0 \
    mosquitto_pub -h mqtt-broker -p 1883 -u solar_user -P testing_password_123 \
    -t "test/paso3" -m "Mensaje recibido correctamente" 2>/dev/null

sleep 2

if [ -f "/tmp/mqtt_resultado" ] && grep -q "Mensaje recibido correctamente" "/tmp/mqtt_resultado"; then
    echo "✅ ¡Perfecto! El broker puede recibir Y enviar mensajes"
    MENSAJE_RECIBIDO=$(cat /tmp/mqtt_resultado)
    echo "📨 Mensaje recibido: '$MENSAJE_RECIBIDO'"
    rm -f /tmp/mqtt_resultado
else
    echo "❌ Problema con pub/sub"
    rm -f /tmp/mqtt_resultado
    exit 1
fi

echo ""
echo "📋 PASO 4: Simular datos de ESP32"
echo "Vamos a enviar datos como lo haría tu ESP32..."
echo ""

ESP32_DATA='{"deviceId":"ESP32_001","voltage":12.45,"current":2.1,"power":26.15,"temperature":28.5,"humidity":65.2,"timestamp":"'$(date -Iseconds)'"}'
echo "Datos que enviaremos:"
echo "$ESP32_DATA"
echo ""

if docker run --rm --network docker_mqtt-network eclipse-mosquitto:2.0 \
   mosquitto_pub -h mqtt-broker -p 1883 -u solar_user -P testing_password_123 \
   -t 'solar/ESP32_001/data' -m "$ESP32_DATA" 2>/dev/null; then
    echo "✅ ¡Datos de ESP32 enviados correctamente!"
    echo "📡 Topic usado: solar/ESP32_001/data"
else
    echo "❌ Error enviando datos de ESP32"
    exit 1
fi

echo ""
echo "📋 PASO 5: Verificar logs del broker"
echo "Revisando los últimos logs..."
echo ""
docker logs solar-mqtt-broker --tail 5

echo ""
echo "🎉 ¡TODAS LAS PRUEBAS PASARON!"
echo "========================================="
echo ""
echo "🔗 Tu broker MQTT está FUNCIONANDO CORRECTAMENTE"
echo ""
echo "📋 Para conectar tu backend Node.js:"
echo "MQTT_HOST=localhost"
echo "MQTT_PORT=1883"
echo "MQTT_USERNAME=solar_user" 
echo "MQTT_PASSWORD=testing_password_123"
echo ""
echo "📡 Topics que funcionan:"
echo "- solar/+/data (para datos de paneles)"
echo "- sensors/+/data (para sensores)" 
echo "- device/+/data (para dispositivos)"
echo "- test/+ (para pruebas)"
echo ""
echo "✅ ¡Tu sistema está listo para recibir datos reales!"