import os
import requests
from modules import cmd_args
from helper.logging import Logger

logger = Logger("V2A")
args, _ = cmd_args.parser.parse_known_args()

BASE_API_URL = args.base_api
LORA_BASE_URL = args.lora_base_url

def post_v2a(name, log):
    url = BASE_API_URL + '/log/add'
    data = {
        'name': name,
        'log': log
    }

    try:
        response = requests.post(url, json=data)
        response.raise_for_status()
        logger.info('Post v2a success: {} {}', name, log)
    except Exception as e:
        logger.error('Post v2a fail: {} {}', name, log)
        
def get_model_info(name):
    url = f'{BASE_API_URL}/sdstyle/getsimple?name={name}'
    try:
        response = requests.request("GET", url)
        return response.json()
    except Exception as e:
        # logger.error(f'Get model info fail: {e}')
        return None


def download_lora(name, save_dir):
    os.makedirs(save_dir, exist_ok=True)
    file_url = f"{LORA_BASE_URL}/{name}.safetensors"
    if file_url is not None:
        file_name = os.path.basename(file_url)
        local_file_path = os.path.join(save_dir, file_name)
        try:
            response = requests.get(file_url, stream=True)
            response.raise_for_status()
            with open(local_file_path, 'wb') as file:
                for chunk in response.iter_content(chunk_size=8192):
                    file.write(chunk)
            return local_file_path
        except requests.exceptions.RequestException as e:
            print(f"Error downloading file: {e}")
