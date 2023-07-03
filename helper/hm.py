import os, json
from modules import cmd_args
from helper.v2a_server import post_v2a, HeartbeatThread

args, _ = cmd_args.parser.parse_known_args()

server_id = args.google_id if args.google_id else args.server_id
group = args.group
type = args.type
url = args.share_url

models = [
    {
        'name' : 'Majicmix',
        'file' : 'majicmixRealistic_v5.safetensors',
        'link_file': 'https://civitai.com/api/download/models/82446',
        'icon' : 'https://image.civitai.com/xG1nkqKTMzGDvpLrqFT7WA/66820fd3-98f2-4fbb-b904-0507de39c36a/width=1024/00002-140050360.jpeg',
        'civitaiLink' : 'https://civitai.com/models/43331',
    },
    {
        'name' : 'RevAnimated',
        'file' : 'revAnimated_v122.safetensors',
        'link_file' : 'https://civitai.com/api/download/models/46846',
        'icon' : 'https://image.civitai.com/xG1nkqKTMzGDvpLrqFT7WA/6a4cdef6-669c-4f95-c8b3-f30fe84d7e00/width=450/00010-3061578913.jpeg',
        'civitaiLink' : 'https://civitai.com/models/7371',
    },
    {
        'name' : 'Meinamix',
        'file' : 'meinamix_meinaV10.safetensors',
        'link_file' : 'https://civitai.com/api/download/models/80511',
        'icon' : 'https://image.civitai.com/xG1nkqKTMzGDvpLrqFT7WA/9c9892af-9240-4108-896a-acda424dd196/width=450/00037-3212833155.jpeg',
        'civitaiLink' : 'https://civitai.com/models/7240',
    },
    {
        'name' : 'RealisticVision',
        'file' : 'realisticVisionV30_v30VAE.safetensors',
        'link_file' : 'https://civitai.com/api/download/models/105674',
        'icon' : 'https://image.civitai.com/xG1nkqKTMzGDvpLrqFT7WA/cf4b9664-975a-4f56-8fba-afe4b5827a00/width=576/334107.jpeg',
        'civitaiLink' : 'https://civitai.com/models/4201',
    },
    {
        'name' : 'CosplayMix',
        'file' : 'cosplaymix_v41.safetensors',
        'link_file' : 'https://civitai.com/api/download/models/98501',
        'icon' : 'https://image.civitai.com/xG1nkqKTMzGDvpLrqFT7WA/9533df34-359f-4dbc-909d-dac6a3ab2081/width=1024/00082-3284715324.jpeg',
        'civitaiLink' : 'https://civitai.com/models/34502',
    },
]

def get_server_info():
    server_info = {}
    server_info['id'] = server_id
    server_info['group'] = group
    server_info['type'] = type
    server_info['url'] = url
    for m in models:
        if group == m['name']:
            server_info['icon'] = m['icon']
            server_info['civitaiLink'] = m['civitaiLink']
    return server_info

def init_server():
    if args.type != 'colab':
        heartbeat_thread = HeartbeatThread(server_id)
        heartbeat_thread.daemon = True
        heartbeat_thread.start()
    server_info = get_server_info()
    post_v2a(server_id, 'start_server: ' + json.dumps(server_info))
    
def get_models_info():
    for m in models:
        if group == m['name']:
            return m['file'],  m['link_file']
    return None, None