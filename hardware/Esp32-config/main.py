# main.py - COMUNICACIÓN BÁSICA ESP32 -> MQTT
import time
import machine
import ujson as json

# Importar módulos locales
import wifiClient
from mqttClient import MQTTClientWrapper
from config import *

def test_basic_communication():
    """Prueba básica de comunicación MQTT"""
    print("🧪 PRUEBA DE COMUNICACIÓN BÁSICA")
    print("================================")
    print(f"📱 Device: {DEVICE_ID}")
    print(f"🌐 WiFi: {WIFI_SSID}")
    print(f"📡 MQTT: {MQTT_BROKER}:{MQTT_PORT}")
    print(f"👤 Usuario: {MQTT_USER}")
    print("")
    
    # Conectar WiFi
    print("1️⃣ Conectando WiFi...")
    try:
        wlan = wifiClient.wait_connected(WIFI_SSID, WIFI_PASS, retries=3, delay=2)
        print(f"✅ WiFi conectado: {wlan.ifconfig()[0]}")
    except Exception as e:
        print(f"❌ Error WiFi: {e}")
        return False
    
    # Conectar MQTT
    print("\n2️⃣ Conectando MQTT...")
    mqtt = MQTTClientWrapper(
        MQTT_BROKER,
        port=MQTT_PORT,
        user=MQTT_USER,
        password=MQTT_PASS
    )
    
    try:
        mqtt.connect(retries=3, delay=2)
        print("✅ MQTT conectado")
    except Exception as e:
        print(f"❌ Error MQTT: {e}")
        return False
    
    # Enviar mensaje de prueba
    print("\n3️⃣ Enviando mensaje de prueba...")
    test_message = {
        "deviceId": DEVICE_ID,
        "message": "Hola desde ESP32",
        "test": True,
        "timestamp": time.time()
    }
    
    try:
        mqtt.publish(f"solar/{DEVICE_ID}/test", json.dumps(test_message))
        print("✅ Mensaje enviado!")
        print(f"📦 Contenido: {test_message}")
    except Exception as e:
        print(f"❌ Error enviando: {e}")
        return False
    
    # Cleanup
    mqtt.disconnect()
    print("\n🎉 ¡COMUNICACIÓN EXITOSA!")
    print("Ya podemos enviar datos al broker MQTT")
    return True

def send_simple_data():
    """Envío continuo de datos simples"""
    print("🚀 MODO ENVÍO CONTINUO")
    print("=====================")
    print(f"⏱️ Intervalo: {PUBLISH_INTERVAL} segundos")
    print("🛑 Ctrl+C para detener")
    print("")
    
    # Conectar WiFi y MQTT
    wlan = wifiClient.wait_connected(WIFI_SSID, WIFI_PASS, retries=3, delay=2)
    mqtt = MQTTClientWrapper(MQTT_BROKER, port=MQTT_PORT, user=MQTT_USER, password=MQTT_PASS)
    mqtt.connect(retries=3, delay=2)
    
    print("✅ Conectado, comenzando envío de datos...")
    
    counter = 1
    
    while True:
        try:
            # Datos simples para probar
            simple_data = {
                "deviceId": DEVICE_ID,
                "counter": counter,
                "temperature": 25.0 + (counter % 10),  # Temperatura simulada simple
                "humidity": 50.0 + (counter % 20),     # Humedad simulada simple
                "timestamp": time.time(),
                "message": f"Datos #{counter}"
            }
            
            # Enviar
            mqtt.publish(f"solar/{DEVICE_ID}/data", json.dumps(simple_data))
            
            print(f"📤 Enviado #{counter}: Temp={simple_data['temperature']}°C, Hum={simple_data['humidity']}%")
            
            counter += 1
            time.sleep(PUBLISH_INTERVAL)
            
        except KeyboardInterrupt:
            print("\n🛑 Deteniendo...")
            break
        except Exception as e:
            print(f"❌ Error: {e}")
            time.sleep(5)
    
    mqtt.disconnect()
    print("✅ Desconectado")

def main():
    print("🌞 ESP32 SOLAR - COMUNICACIÓN BÁSICA")
    print("====================================")
    
    # Primero probar comunicación
    if not test_basic_communication():
        print("🛑 Error en comunicación básica")
        return
    
    print("\n" + "="*50)
    input("Presiona ENTER para continuar con envío continuo...")
    print("")
    
    # Si la prueba fue exitosa, comenzar envío continuo
    send_simple_data()

if __name__ == "__main__":
    main()
