# 🚀 Despliegue MQTT para Solar Business

## 📋 Resumen de Configuración

Este directorio contiene la configuración completa para desplegar un broker MQTT Mosquitto usando Ansible, con soporte para testing local con Vagrant.

### ✅ Estado de Validación
- **Archivos necesarios**: ✅ Todos presentes
- **Templates de Ansible**: ✅ Variables correctas
- **Configuración de inventario**: ✅ Variables sincronizadas
- **Scripts de deployment**: ✅ Listos para uso
- **Scripts de verificación**: ✅ Configurados

## 📁 Estructura de Archivos

```
ansible/
├── mqtt-broker-playbook.yml    # Playbook principal de Ansible
├── inventory.ini               # Configuración de servidores y variables
├── Vagrantfile                 # Entorno de testing local
├── templates/
│   ├── mosquitto.conf.j2      # Configuración principal del broker
│   └── acl.conf.j2           # Control de acceso por usuarios
├── scripts/
│   ├── deploy-mqtt.sh         # Script de despliegue automático
│   ├── validate-config.sh     # Validación de configuración
│   ├── verify-mqtt.sh         # Verificación post-despliegue
│   └── test-with-vagrant.sh   # Testing completo con Vagrant
```

## 🔧 Configuración Actual

### Variables del Sistema
- **Puerto MQTT**: 1883
- **Puerto WebSocket**: 9001 (opcional)
- **Usuario**: solar_user
- **Contraseña**: testing_password_123
- **Log**: /var/log/mosquitto/mosquitto.log

### Permisos de Usuario (ACL)
- **solar_user** puede:
  - Leer/Escribir en `solar/+/data`
  - Leer/Escribir en `sensors/+/data`
  - Leer/Escribir en `monitor/+/+`
  - Leer estadísticas del sistema `$SYS/broker/*`
  - Testing en `test/+`

## 🚀 Métodos de Despliegue

### Opción 1: Testing Local con Vagrant
```bash
# Instalar Vagrant (si no lo tienes)
# Descargar desde: https://www.vagrantup.com/downloads

# Levantar entorno de testing
vagrant up

# Verificar funcionamiento
./verify-mqtt.sh 192.168.56.10
```

### Opción 2: Servidor en Nube
```bash
# 1. Configura tu servidor en inventory.ini
vim inventory.ini

# 2. Despliega usando Ansible
ansible-playbook -i inventory.ini mqtt-broker-playbook.yml

# 3. Verifica el funcionamiento
./verify-mqtt.sh TU_IP_SERVIDOR
```

### Opción 3: Despliegue Automático
```bash
# Script todo-en-uno
./deploy-mqtt.sh
```

## 🔍 Verificación Post-Despliegue

### Test Automático
```bash
./verify-mqtt.sh [IP_SERVIDOR] [PUERTO] [USUARIO] [CONTRASEÑA]
```

### Test Manual
```bash
# Publicar mensaje de prueba
mosquitto_pub -h IP_SERVIDOR -p 1883 -u solar_user -P testing_password_123 \
  -t "solar/ESP32_001/data" \
  -m '{"voltage": 12.5, "current": 2.3, "temperature": 25.4}'

# Suscribirse a mensajes
mosquitto_sub -h IP_SERVIDOR -p 1883 -u solar_user -P testing_password_123 \
  -t "solar/+/data"
```

## 🔗 Integración con Backend

### Configuración en tu backend Node.js
```javascript
// En tu .env o configuración
MQTT_HOST=IP_DEL_SERVIDOR
MQTT_PORT=1883
MQTT_USERNAME=solar_user
MQTT_PASSWORD=testing_password_123

// Topics para suscribirse
MQTT_TOPICS=solar/+/data,sensors/+/data
```

### Ejemplo de uso con el servicio MQTT existente
```javascript
const mqttService = require('./src/services/mqttService');

// Configurar y conectar
await mqttService.connect({
  host: process.env.MQTT_HOST,
  port: process.env.MQTT_PORT,
  username: process.env.MQTT_USERNAME,
  password: process.env.MQTT_PASSWORD
});
```

## 🛡️ Seguridad

### Configuración Actual
- ✅ Autenticación requerida (no anónimos)
- ✅ Control de acceso por ACL
- ✅ Firewall configurado (puerto 1883)
- ✅ Logs habilitados para auditoria

### Para Producción - Recomendaciones Adicionales
```bash
# 1. Cambiar credenciales por defecto
# 2. Habilitar SSL/TLS
# 3. Configurar certificados
# 4. Restringir IPs de origen
# 5. Monitoreo y alertas
```

## 🐛 Troubleshooting

### Problemas Comunes

1. **Error de conexión**
   ```bash
   # Verificar que el servicio esté corriendo
   sudo systemctl status mosquitto
   
   # Verificar puertos abiertos
   sudo netstat -tlnp | grep 1883
   ```

2. **Error de autenticación**
   ```bash
   # Verificar usuarios configurados
   sudo cat /etc/mosquitto/passwd
   
   # Recrear usuario si es necesario
   sudo mosquitto_passwd -c /etc/mosquitto/passwd solar_user
   ```

3. **Error de permisos**
   ```bash
   # Verificar ACL
   sudo cat /etc/mosquitto/acl.conf
   
   # Reiniciar servicio después de cambios
   sudo systemctl restart mosquitto
   ```

### Logs de Diagnóstico
```bash
# Ver logs del broker
sudo tail -f /var/log/mosquitto/mosquitto.log

# Ver logs del sistema
sudo journalctl -u mosquitto -f
```

## 📊 Monitoreo

### Métricas del Broker
```bash
# Clientes conectados
mosquitto_sub -h localhost -p 1883 -u solar_user -P testing_password_123 \
  -t '$SYS/broker/clients/connected' -C 1

# Mensajes enviados
mosquitto_sub -h localhost -p 1883 -u solar_user -P testing_password_123 \
  -t '$SYS/broker/messages/sent' -C 1
```

### Dashboard Web (Opcional)
Para un dashboard web, puedes usar herramientas como:
- HiveMQ Control Center
- MQTT Explorer
- Grafana + InfluxDB

## 🎯 Próximos Pasos

1. **Testing Local**: Usar Vagrant para verificar configuración
2. **Despliegue en Nube**: Configurar servidor real
3. **Integración Backend**: Conectar con tu aplicación Node.js
4. **Pruebas ESP32**: Verificar comunicación con dispositivos
5. **Monitoreo**: Configurar alertas y métricas
6. **Seguridad**: Implementar SSL/TLS para producción

## 💡 Notas Importantes

- **Credenciales**: Cambiar las contraseñas por defecto antes de producción
- **Firewall**: Asegurar que solo los puertos necesarios estén abiertos
- **Backup**: Configurar backup de las configuraciones
- **Logs**: Configurar rotación de logs para evitar llenar disco
- **Escalabilidad**: Considerar clustering para alta disponibilidad

---
✅ **Configuración validada y lista para despliegue**
🔧 **Última validación**: $(date)
📋 **Scripts disponibles**: validate-config.sh, verify-mqtt.sh, deploy-mqtt.sh