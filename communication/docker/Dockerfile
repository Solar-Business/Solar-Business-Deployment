# Dockerfile para MQTT Broker Mosquitto
# Solar Business - Solución containerizada
FROM eclipse-mosquitto:2.0.18

# Metadatos
LABEL maintainer="Solar Business"
LABEL description="MQTT Broker Mosquitto para sistema solar"
LABEL version="1.0"

# Variables de entorno
ENV MQTT_USER=solar_user
ENV MQTT_PASSWORD=testing_password_123
ENV MQTT_PORT=1883
ENV MQTT_WS_PORT=9001

# Crear usuario mosquitto si no existe y directorios necesarios
USER root
RUN mkdir -p /mosquitto/config /mosquitto/data /mosquitto/log && \
    chown -R mosquitto:mosquitto /mosquitto

# Copiar archivos de configuración
COPY mosquitto.conf /mosquitto/config/
COPY acl.conf /mosquitto/config/
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Crear archivo de contraseñas
RUN mosquitto_passwd -c -b /mosquitto/config/passwd $MQTT_USER $MQTT_PASSWORD && \
    chown mosquitto:mosquitto /mosquitto/config/passwd && \
    chmod 600 /mosquitto/config/passwd

# Exponer puertos
EXPOSE $MQTT_PORT $MQTT_WS_PORT

# Cambiar a usuario mosquitto
USER mosquitto

# Volúmenes para persistencia
VOLUME ["/mosquitto/data", "/mosquitto/log"]

# Punto de entrada personalizado
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["/usr/sbin/mosquitto", "-c", "/mosquitto/config/mosquitto.conf"]