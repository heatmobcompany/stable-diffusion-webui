import threading
import time
import requests

BASE_API_URL = 'https://beta-api.v2a.ai'
WEB_API_URL = 'https://web-api.v2a.ai'

def post_v2a(name, log):
    url = BASE_API_URL + '/log/add'
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
    url = f'{BASE_API_URL}/sdstyle/getsimple?name={name}'
    try:
        response = requests.request("GET", url)
        return response.json()
    except requests.exceptions.RequestException as e:
        return None

def get_user_info(token):
    url = f'{WEB_API_URL}/account/user-info'
    headers = {'Authorization': f'Bearer {token}'}
    try:
        response = requests.get(url, headers=headers)
        response.raise_for_status()
        user_info = response.json()
        return user_info
    except Exception as e:
        print(f"Error: {e}")
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
