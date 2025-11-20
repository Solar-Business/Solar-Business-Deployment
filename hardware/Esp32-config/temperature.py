# temperature.py
import dht
from machine import Pin
import time

class DHT11Sensor:
    def __init__(self, pin_no, retries=4, delay_between=2):
        self.pin_no = pin_no
        self.retries = retries
        self.delay_between = delay_between
        self._sensor = dht.DHT11(Pin(self.pin_no))

    def measure(self):
        for attempt in range(1, self.retries + 1):
            try:
                self._sensor.measure()
                t = self._sensor.temperature()
                h = self._sensor.humidity()
                return t, h
            except OSError as e:
                print("DHT11 intento", attempt, "falló:", e)
                time.sleep(self.delay_between)
                # re-inicializar objeto por si quedó en mal estado
                try:
                    self._sensor = dht.DHT11(Pin(self.pin_no))
                except Exception:
                    pass
        raise RuntimeError("Fallo persistente leyendo DHT11")

    def read(self):
        t, h = self.measure()
        return {'temperature': t, 'humidity': h}
