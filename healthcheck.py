import json
import subprocess
import time
import datetime
from enum import Enum
import requests
import yaml
from datetime import datetime, timezone, timedelta

DONOTHING = 0
RESTART_SERVICE = 1
RESTART_DEVICE = 2

Action = ["DO_NOTHING", "RESTART_SERVICE", "RESTART_DEVICE"]


def get_gpu_memory_usage():
    try:
        output = subprocess.check_output(['nvidia-smi', '--query-gpu=memory.used,memory.total', '--format=csv,nounits,noheader'])
        used, total = map(int, output.decode('utf-8').strip().split(','))
        return used, total
    except Exception as e:
        return None, None
    
def check_internet_connection():
    target = '8.8.8.8'
    try:
        subprocess.check_output(['ping', '-c', '4', target])
        return DONOTHING
    except Exception as e:
        return RESTART_DEVICE

def check_gpu_memory_usage(threshold, max_attempts, retry_interval):
    failed_count = 0
    gpu_usage_percentage = 0
    for _ in range(max_attempts):
        used, total = get_gpu_memory_usage()
        if used is not None and total is not None:
            failed_count = 0
            gpu_usage_percentage = round(used / total, 4)
            if gpu_usage_percentage > threshold:
                time.sleep(retry_interval)
            else:
                return DONOTHING, gpu_usage_percentage
        else:
            failed_count += 1
            if failed_count > 1:
                return RESTART_DEVICE, gpu_usage_percentage

    return RESTART_SERVICE, gpu_usage_percentage
        
def restart_service():
    cmd = "sudo service sd-service restart"
    subprocess.call(cmd, shell=True)

def restart_device():
    cmd = "sudo reboot"
    subprocess.call(cmd, shell=True)


def do_action(action):
    if action == RESTART_SERVICE:
        return restart_service()
    elif action == RESTART_DEVICE:
        return restart_device()


def check_api_health(url, max_attempts, retry_interval):
    failed_count = 0
    for _ in range(max_attempts):
        try:
            response = requests.get(url)
            if response.status_code == 200:
                return DONOTHING
            else:
                failed_count += 1
                if failed_count > 1:
                    return RESTART_SERVICE
                time.sleep(retry_interval)
        except Exception as e:
            failed_count += 1
            if failed_count > 1:
                return RESTART_SERVICE
            time.sleep(retry_interval)
            
def send_webhook_message(action, message):
    if action == DONOTHING:
        return
    with open("/workspace/config.yaml", 'r') as yaml_file:
        try:
            config_data = yaml.safe_load(yaml_file)
            webhook_url = config_data["app"]["msteam_webhook"]
            server_id = config_data["app"]["server_id"]
            message = {
                'title': f"[{server_id}] {Action[action]}",
                'text': message,
            }
            payload = json.dumps(message)
            headers = {
                'Content-Type': 'application/json',
            }
            response = requests.post(webhook_url, data=payload, headers=headers)
            if response.status_code != 200:
                print('Status error while sending message to Teams')
                pass
        except Exception as e:
            print("Exception while sending message to Teams")
            pass

if __name__ == '__main__':
    action0 = check_internet_connection()
    
    threshold = 0.85
    max_attempts = 10
    retry_interval = 10
    action1, usage = check_gpu_memory_usage(threshold, max_attempts, retry_interval)
    
    max_attempts = 5
    retry_interval = 5
    api_url = "http://localhost:3000/internal/ping"
    action2 = check_api_health(api_url, max_attempts, retry_interval)

    action = max(action0, action1, action2)
    utc_time = datetime.now(timezone.utc)
    local_timezone = timezone(timedelta(hours=7))
    local_time = utc_time.astimezone(local_timezone)
    message = (f"{local_time}: GPU usage: {round(usage * 100, 2)} %, Ping: {'OK' if action2 == DONOTHING else 'NOK'}, Action: {Action[action]}")
    print(message)
    send_webhook_message(action, message)
    do_action(action)
