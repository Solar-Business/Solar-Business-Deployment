# config.py - CONFIGURACIÓN UNIFICADA ESP32 SOLAR
# Configuración completa para sistema de paneles solares

# === CONFIGURACIÓN DE RED ===
WIFI_SSID = "FPT8414"
WIFI_PASS = "3260721_P"

# === CONFIGURACIÓN MQTT (PARA BROKER DOCKER) ===
MQTT_BROKER = "192.168.1.54"   # ⚠️ CAMBIAR POR IP DE TU COMPUTADORA
MQTT_PORT = 1883
MQTT_USER = "solar_user"        # Usuario del broker Docker
MQTT_PASS = "testing_password_123"  # Password del broker Docker
MQTT_KEEPALIVE = 60
MQTT_RETRIES = 5

# === CONFIGURACIÓN DEL DISPOSITIVO ===
DEVICE_ID = "ESP32_001"         # ID único de este ESP32
MQTT_TOPIC_BASE = f"solar/{DEVICE_ID}"  # Topic base: solar/ESP32_001

# === CONFIGURACIÓN DE OPERACIÓN ===
USE_SIMULATOR = True            # True = datos simulados, False = sensor DHT11 real
DEBUG_MODE = True               # True = mensajes detallados en consola
CONSOLE_ONLY_MODE = False       # True = solo consola, no envía MQTT
PUBLISH_INTERVAL = 10           # Segundos entre envíos

# === CONFIGURACIÓN DE HARDWARE ===
SENSOR_PIN = 4                  # GPIO para sensor DHT11 (si se usa)
WIFI_RETRIES = 5               # Intentos de conexión WiFi

# === TOPICS MQTT ===
MQTT_TOPICS = {
    "data": f"{MQTT_TOPIC_BASE}/data",           # Datos principales
    "status": f"{MQTT_TOPIC_BASE}/status",       # Estado del dispositivo
    "config": f"{MQTT_TOPIC_BASE}/config",       # Configuración
    "heartbeat": f"{MQTT_TOPIC_BASE}/heartbeat", # Señal de vida
}

# === RANGOS DE SIMULACIÓN SOLAR ===
SIMULATION_RANGES = {
    "temperature": (20.0, 45.0),    # °C - Temperatura del panel
    "humidity": (30.0, 80.0),       # % - Humedad ambiente
    "voltage": (11.5, 13.2),        # V - Voltaje del panel 12V
    "current": (0.5, 3.0),          # A - Corriente del panel
    "power": (5.0, 40.0),           # W - Potencia calculada
    "energy": (0.0, 1000.0),        # Wh - Energía acumulada
    "irradiance": (200, 1200),      # W/m² - Irradiancia solar
}