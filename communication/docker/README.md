# 🐳 MQTT Broker con Docker - Solar Business

## 🚀 Setup Super Simple

### 1️⃣ Iniciar el Broker
```bash
cd communication/docker
./mqtt-docker.sh start
```

### 2️⃣ Verificar que Funciona
```bash
./test-mqtt.sh
```

### 3️⃣ Configurar tu Backend
```javascript
// En tu .env
MQTT_HOST=localhost
MQTT_PORT=1883
MQTT_USERNAME=solar_user
MQTT_PASSWORD=testing_password_123
```

¡Eso es todo! 🎉

---

## 📋 Comandos Disponibles

```bash
./mqtt-docker.sh start    # Iniciar broker
./mqtt-docker.sh stop     # Detener broker
./mqtt-docker.sh restart  # Reiniciar broker
./mqtt-docker.sh logs     # Ver logs
./mqtt-docker.sh status   # Verificar estado
./mqtt-docker.sh test     # Ejecutar tests
./mqtt-docker.sh clean    # Limpiar datos
```

## 🧪 Pruebas Rápidas

### Publicar Mensaje
```bash
docker run --rm --network solar-mqtt_mqtt-network eclipse-mosquitto:2.0 \
  mosquitto_pub -h mosquitto -p 1883 -u solar_user -P testing_password_123 \
  -t 'solar/ESP32_001/data' -m '{"voltage": 12.5, "current": 2.3}'
```

### Suscribirse a Mensajes
```bash
docker run --rm --network solar-mqtt_mqtt-network eclipse-mosquitto:2.0 \
  mosquitto_sub -h mosquitto -p 1883 -u solar_user -P testing_password_123 \
  -t 'solar/+/data'
```

## 📂 Estructura

```
docker/
├── docker-compose.yml     # Configuración Docker
├── mqtt-docker.sh         # Script de gestión
├── test-mqtt.sh          # Script de testing
├── config/
│   ├── mosquitto.conf    # Configuración Mosquitto
│   ├── acl.conf          # Permisos de usuarios
│   └── passwd            # Archivo de contraseñas
├── data/                 # Datos persistentes
└── logs/                 # Logs del broker
```

## 🔧 Configuración

### Usuarios y Permisos
- **Usuario**: `solar_user`
- **Contraseña**: `testing_password_123`
- **Permisos**: Leer/escribir en topics `solar/+/data`, `sensors/+/data`, `test/+`

### Puertos
- **MQTT**: `1883`
- **WebSocket**: `9001`

### Topics Permitidos
```
solar/+/data          # Datos de paneles solares
sensors/+/data        # Datos de sensores
device/+/data         # Datos de dispositivos ESP32
monitor/+/+           # Monitoreo general
test/+                # Testing
```

## 🛡️ Seguridad

- ✅ Autenticación requerida
- ✅ Control de acceso por topics (ACL)
- ✅ Sin acceso anónimo
- ✅ Logs de auditoria

## 🐛 Troubleshooting

### Broker no inicia
```bash
./mqtt-docker.sh logs
```

### Error de conexión
```bash
./mqtt-docker.sh status
```

### Limpiar y reiniciar
```bash
./mqtt-docker.sh clean
./mqtt-docker.sh start
```

---

## 🎯 Ventajas de Docker vs Ansible/Vagrant

✅ **Más Simple**: Un solo comando para todo  
✅ **Más Rápido**: Segundos en lugar de minutos  
✅ **Más Portable**: Funciona en cualquier OS con Docker  
✅ **Más Limpio**: No modifica el sistema host  
✅ **Más Fácil**: No necesitas instalar Vagrant/VirtualBox/Ansible  

**¡Perfecto para desarrollo y producción!** 🚀