import json
import subprocess
import time
import datetime
from enum import Enum
import requests
import yaml
from datetime import datetime, timezone, timedelta
import logging
import smtplib

logger = logging.getLogger(__name__)
logger.setLevel(logging.INFO)
logging.basicConfig(format='%(asctime)s - %(message)s',
                    datefmt='%Y-%m-%d %H:%M:%S')

DONOTHING = 0
RESTART_SERVICE = 1
RESTART_DEVICE = 2

Action = ["DO_NOTHING", "RESTART_SERVICE", "RESTART_DEVICE"]


def get_gpu_memory_usage():
    try:
        output = subprocess.check_output(
            ['nvidia-smi', '--query-gpu=memory.used,memory.total', '--format=csv,nounits,noheader'])
        used, total = map(int, output.decode('utf-8').strip().split(','))
        logger.debug(f"GPU usage: {used}/{total}")
        return used, total
    except Exception as e:
        logger.debug(f"Error while getting GPU memory usage: {e}")
        return None, None


def get_cpu_memory_usage():
    try:
        output = subprocess.check_output(['free', '-m'])
        lines = output.decode('utf-8').strip().split('\n')
        total, used, free = map(int, lines[1].split()[1:4])
        logger.debug(f"CPU usage: {used}/{total}")
        return used, total
    except Exception as e:
        logger.debug(f"Error while getting CPU memory usage: {e}")
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


def check_cpu_memory_usage(threshold, max_attempts, retry_interval):
    failed_count = 0
    cpu_usage_percentage = 0
    for i in range(max_attempts):
        logger.debug(f"Check cpu attemps: {i}")
        used, total = get_cpu_memory_usage()
        if used is not None and total is not None:
            failed_count = 0
            cpu_usage_percentage = round(used / total, 4)
            if cpu_usage_percentage > threshold:
                if i < max_attempts - 1:
                    time.sleep(retry_interval)
            else:
                return DONOTHING, cpu_usage_percentage
        else:
            failed_count += 1
            if failed_count > 1:
                return RESTART_DEVICE, cpu_usage_percentage

    return RESTART_SERVICE, cpu_usage_percentage


def restart_service():
    cmd = "/workspace/stable-diffusion-webui/update-webui.sh"
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

def send_email_message(action, message):
    if action == DONOTHING:
        return
    try:
        with open("/workspace/config.yaml", "r") as f:
            config = yaml.safe_load(f)
            sender_email = config["email"]["sender"]
            receiver_email = config["email"]["receiver"]
            smtp_user = config["email"]["smtp_user"]
            smtp_password = config["email"]["smtp_password"]
            smtp_server = config["email"]["smtp_server"]
            port = config["email"]["smtp_port"]
            server_id = config["app"]["server_id"]
            subject = f"[{server_id}] Healthcheck: {Action[action]}"
            body = message
            message = f"Subject: {subject}\n\n{body}"
            server = smtplib.SMTP(smtp_server, port)
            server.starttls()
            server.login(smtp_user, smtp_password)
            server.sendmail(sender_email, receiver_email, message)
            server.quit()
    except Exception as e:
        logger.debug(f"Error while sending email: {e}")
        pass
def get_latest_action():
    with open("/workspace/logs/healthcheck.log", "r") as f:
        lines = f.readlines()
        lastLineResult = None
        for line in reversed(lines):
            if "GPU usage" in line:
                lastLineResult = line
                break
        if lastLineResult is None:
            return None
        for action in Action:
            if action in lastLineResult:
                return action
        return None


if __name__ == '__main__':
    action0 = check_internet_connection()
    action1, gpu_usage = check_gpu_memory_usage(
        threshold=0.90,
        max_attempts=5,
        retry_interval=10,
    )

    action2 = check_api_health(
        url="http://localhost:3000/internal/ping",
        max_attempts=5,
        retry_interval=5,
    )

    action3, ram_usage = check_cpu_memory_usage(
        threshold=0.95,
        max_attempts=3,
        retry_interval=10,
    )
    logger.debug(f"Actions: {action0}, {action1}, {action2}, {action3}")
    action = max(action0, action1, action2, action3)
    last_action = get_latest_action()
    if action is not DONOTHING and (last_action == Action[RESTART_SERVICE] or last_action == Action[RESTART_DEVICE]):
        action = RESTART_DEVICE

    message = (
        f"GPU: {round(gpu_usage * 100, 2)} %, RAM: {round(ram_usage * 100, 2)} %, Ping: {'OK' if action2 == DONOTHING else 'NOK'}, Action: {Action[action]}")
    logger.info(message)
    send_email_message(action, message)
    do_action(action)
