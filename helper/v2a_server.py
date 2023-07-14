import threading
import time
import requests

BASE_API_URL = 'https://beta-api.vision2art.ai'

AUTH_HEADER = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY0YTc3NjY5NTE2Y2ZmNDZlYTRmMDhmMiIsInJvbGVzIjpbIlBSSU1BUlkiXSwiZW1haWwiOiJhbi5uZ3V5ZW5AaGVhdG1vYi5uZXQiLCJjcmVhdGVfYXQiOiIyMDIzLTA3LTA3VDAyOjIwOjI1LjcxOVoiLCJpYXQiOjE2ODg2OTY0MzAsImV4cCI6MTY5MTI4ODQzMH0.HgIgnKvoianhG9H6TFeJxlvilsibin5bW2HKzixx5K0'
}

def post_v2a(name, log):
    url = BASE_API_URL + '/colablog/add'
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
        
def get_model_info(name):
    url = f'{BASE_API_URL}/sdstyle?name={name}'
    try:
        response = requests.request("GET", url, headers=AUTH_HEADER)
        return response.json()
    except requests.exceptions.RequestException as e:
        return None

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
