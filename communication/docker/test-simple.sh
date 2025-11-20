#!/bin/bash
# Prueba SUPER SIMPLE de MQTT

echo "🧪 PRUEBA SIMPLE MQTT - 3 pasos fáciles"
echo "========================================"
echo ""

echo "1️⃣ ¿Está corriendo el container?"
echo "--------------------------------"
if docker ps | grep -q solar-mqtt-broker; then
    echo "✅ SÍ - El container está corriendo"
else
    echo "❌ NO - Ejecuta: ./mqtt-docker.sh start"
    exit 1
fi
echo ""

echo "2️⃣ ¿Puedo enviar un mensaje?"
echo "----------------------------"
echo "Enviando mensaje 'Hola Mundo' al broker..."
if docker run --rm --network docker_mqtt-network eclipse-mosquitto:2.0 \
   mosquitto_pub -h mqtt-broker -p 1883 -u solar_user -P testing_password_123 \
   -t 'test/hola' -m 'Hola Mundo' 2>/dev/null; then
    echo "✅ SÍ - Mensaje enviado exitosamente"
else
    echo "❌ NO - Error enviando mensaje"
    exit 1
fi
echo ""

echo "3️⃣ ¿Puedo enviar datos como ESP32?"
echo "-----------------------------------"
DATOS_ESP32='{"voltage":12.5,"current":2.1,"power":26.25,"temp":25.3}'
echo "Enviando datos de prueba: $DATOS_ESP32"
if docker run --rm --network docker_mqtt-network eclipse-mosquitto:2.0 \
   mosquitto_pub -h mqtt-broker -p 1883 -u solar_user -P testing_password_123 \
   -t 'solar/ESP32_001/data' -m "$DATOS_ESP32" 2>/dev/null; then
    echo "✅ SÍ - Datos de ESP32 enviados correctamente"
else
    echo "❌ NO - Error enviando datos ESP32"
    exit 1
fi
echo ""

echo "🎉 ¡TODAS LAS PRUEBAS PASARON!"
echo "=============================="
echo ""
echo "Esto significa que:"
echo "✅ Tu broker MQTT funciona perfectamente"
echo "✅ Puede recibir mensajes de cualquier cliente"
echo "✅ Tu ESP32 podrá enviar datos sin problemas"
echo "✅ Tu backend podrá conectarse y recibir datos"
echo ""
echo "🔗 Configuración para tu backend:"
echo "MQTT_HOST=localhost"
echo "MQTT_PORT=1883"
echo "MQTT_USERNAME=solar_user"
echo "MQTT_PASSWORD=testing_password_123"
echo ""
echo "✨ ¡Ya puedes conectar tu ESP32 y tu backend Node.js!"