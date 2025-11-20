# 🌞 ESP32 Solar - Comunicación Básica

## 📁 Archivos Esenciales (solo 6 archivos)

### ✅ Archivos que tienes:
1. **`config.py`** - Configuración (WiFi, MQTT, etc.)
2. **`main.py`** - Programa principal simplificado  
3. **`mqttClient.py`** - Cliente MQTT
4. **`wifiClient.py`** - Cliente WiFi
5. **`temperature.py`** - Sensor DHT11 (si lo usas)
6. **`README-UNIFICADO.md`** - Esta guía

## 🎯 Objetivo: Establecer Comunicación Básica

### Paso 1: Verificar configuración
Tu `config.py` ya está configurado:
```python
WIFI_SSID = "FPT8414"           ✅
WIFI_PASS = "3260721_P"         ✅  
MQTT_BROKER = "192.168.1.54"    ✅
MQTT_USER = "solar_user"        ✅
MQTT_PASS = "testing_password_123"  ✅
```

### Paso 2: Probar comunicación
```bash
python main.py
```

### ¿Qué hace el programa ahora?

1. **Test de Comunicación**:
   - ✅ Conecta WiFi
   - ✅ Conecta MQTT  
   - ✅ Envía mensaje de prueba
   - ✅ Confirma que funciona

2. **Envío Continuo Simple**:
   - ✅ Datos básicos (temperatura/humedad simuladas)
   - ✅ Envío cada 10 segundos
   - ✅ Topic: `solar/ESP32_001/data`

## 📡 Para verificar en tu computadora:

```bash
# En el directorio communication/docker:
./monitor.sh
```

Verás mensajes como:
```
[15:30:45] solar/ESP32_001/test {"deviceId":"ESP32_001","message":"Hola desde ESP32"...}
[15:30:55] solar/ESP32_001/data {"deviceId":"ESP32_001","temperature":26.0,"humidity":55.0...}
```

## 🚀 Una vez que funcione la comunicación:

Podremos agregar:
- ✅ Datos solares realistas
- ✅ Sensores físicos  
- ✅ Más funcionalidades
- ✅ Mejores algoritmos

## 🐛 Si hay problemas:

### Error WiFi:
- Verificar SSID/password
- Verificar rango de WiFi

### Error MQTT:
- Verificar IP (192.168.1.54)
- Verificar broker Docker corriendo: `./mqtt-docker.sh status`
- Verificar firewall/puerto 1883

### Datos no llegan:
- Verificar monitor: `./monitor.sh`
- Verificar logs broker: `./mqtt-docker.sh logs`

## 💡 Filosofía: Simple → Complejo

1. **Ahora**: Comunicación básica ✅
2. **Siguiente**: Datos solares básicos
3. **Después**: Sensores reales
4. **Final**: Sistema completo

¡Primero que funcione la comunicación, después agregamos complejidad! 🎯