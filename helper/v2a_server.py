import threading
import time
import requests

def post_v2a(name, log):
    url = 'http://v2a-api.dev.heatmob.net/colablog/add'
    data = {
        'name': name,
        'log': log
    }

    try:
        response = requests.post(url, json=data)
        response.raise_for_status()
        print('Post v2a success: ', log)
    except requests.exceptions.RequestException as e:
        print('Post v2a failure: ', log)

class HeartbeatThread(threading.Thread):
    def __init__(self, name):
        threading.Thread.__init__(self)
        self._stop_event = threading.Event(); self.name = name; self.count = 0
    def stop(self):
        self._stop_event.set()
    def run(self):
        while not self._stop_event.is_set():
            time.sleep(20); self.count += 1
            post_v2a(self.name, 'Heartbeat, count = ' + str(self.count))
