# mqttClient.py
import ubinascii
import machine
import time
try:
    from umqtt.simple import MQTTClient
except:
    # en algunas builds el módulo puede llamarse mqtt.simple; intento fallback
    from umqtt.robust import MQTTClient as MQTTClient

class MQTTClientWrapper:
    def __init__(self, server, port=1883, client_id=None, user=None, password=None, keepalive=60):
        if client_id is None:
            client_id = b"mp_" + ubinascii.hexlify(machine.unique_id())
        self.server = server
        self.port = port
        self.user = user
        self.password = password
        self.client = MQTTClient(client_id, server, port=port, user=user, password=password, keepalive=keepalive)
        self.cb = None

    def set_callback(self, cb):
        self.cb = cb
        self.client.set_callback(cb)

    def connect(self, retries=3, delay=3):
        for i in range(1, retries+1):
            try:
                self.client.connect()
                return
            except Exception as e:
                print("MQTT connect intento", i, "falló:", e)
                time.sleep(delay)
        raise RuntimeError("No se pudo conectar al broker MQTT")

    def publish(self, topic, msg, retain=False, qos=0):
        try:
            self.client.publish(topic, msg, qos=qos, retain=retain)
        except Exception as e:
            print("Error publish:", e)
            raise

    def subscribe(self, topic):
        self.client.subscribe(topic)

    def check_msg(self):
        try:
            self.client.check_msg()
        except Exception as e:
            # si falla la conexión, propagar para que el caller reconecte
            raise

    def ping(self):
        try:
            self.client.ping()
        except Exception:
            pass

    def disconnect(self):
        try:
            self.client.disconnect()
        except Exception:
            pass
