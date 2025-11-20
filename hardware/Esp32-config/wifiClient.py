# wifiClient.py
import network
import time

def connect(ssid, password, timeout=20):
    wlan = network.WLAN(network.STA_IF)
    if not wlan.active():
        wlan.active(True)
    if wlan.isconnected():
        return wlan
    start = time.time()
    wlan.connect(ssid, password)
    while not wlan.isconnected():
        if time.time() - start > timeout:
            raise OSError("WiFi connect timeout")
        time.sleep(1)
    return wlan

def wait_connected(ssid, password, retries=3, delay=5):
    for i in range(1, retries+1):
        try:
            wlan = connect(ssid, password)
            return wlan
        except Exception as e:
            print("WiFi intento", i, "falló:", e)
            time.sleep(delay)
    raise RuntimeError("No se pudo conectar a WiFi después de retries")
