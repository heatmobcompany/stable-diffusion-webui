import subprocess
import time
import datetime
from enum import Enum
import requests


DONOTHING = 0
RESTART_SERVICE = 1
RESTART_DEVICE = 2

Action = ["DONOTHING", "RESTART_SERVICE", "RESTART_DEVICE"]


def get_gpu_memory_usage():
    try:
        output = subprocess.check_output(['nvidia-smi', '--query-gpu=memory.used,memory.total', '--format=csv,nounits,noheader'])
        used, total = map(int, output.decode('utf-8').strip().split(','))
        return used, total
    except Exception as e:
        return None, None

def check_gpu_memory_usage(threshold, max_attempts, retry_interval):
    failed_count = 0
    gpu_usage_percentage = 0
    for _ in range(max_attempts):
        used, total = get_gpu_memory_usage()
        if used is not None and total is not None:
            failed_count = 0
            gpu_usage_percentage = round(used / total, 3)
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


if __name__ == '__main__':
    threshold = 0.85
    max_attempts = 10
    retry_interval = 10
    action1, usage = check_gpu_memory_usage(threshold, max_attempts, retry_interval)
    
    max_attempts = 5
    retry_interval = 5
    api_url = "http://localhost:3000/internal/ping"
    action2 = check_api_health(api_url, max_attempts, retry_interval)

    action = max(action1, action2)
    print(f"{datetime.datetime.now()}: Action: {Action[action]}, GPU usage: {usage * 100} %, Ping: {'OK' if action2 == DONOTHING else 'NOK'}")
    do_action(action)
