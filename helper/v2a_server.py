import requests
from helper.logging import Logger
logger = Logger("V2A")

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
        logger.info('Post v2a success: ', name, log)
    except Exception as e:
        logger.error('Post v2a fail: ', name, log)
        
def get_model_info(name):
    url = f'{BASE_API_URL}/sdstyle/getsimple?name={name}'
    try:
        response = requests.request("GET", url)
        return response.json()
    except Exception as e:
        logger.error(f'Get model info fail: {e}')
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
        logger.error(f'Get user info fail: {e}')
        return None
