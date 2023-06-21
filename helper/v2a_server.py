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
