from datetime import datetime
import json
from modules import cmd_args
from helper.v2a_server import get_model_info, get_user_info, post_v2a

args, _ = cmd_args.parser.parse_known_args()

server_id = args.google_id if args.google_id else args.server_id
group = args.group
type = args.type
url = args.share_url

def get_server_info():
    server_info = {}
    server_info['id'] = server_id
    server_info['group'] = group
    server_info['type'] = type
    server_info['url'] = url
    
    res = get_model_info(group)
    if (res and res['result']):
        server_info['icon'] = res['result']['icon']
        server_info['file'] = res['result']['file']
        server_info['link_file'] = res['result']['link_file']
        server_info['civitaiLink'] = res['result']['civitaiLink']
    return server_info

def get_user_priority(token):
    response_data = get_user_info(token)
    pri, name = 100, None
    try:
        name = response_data['data']['username']
        expires_str = response_data['data']['subscription']['expires']
        expires_datetime = datetime.strptime(expires_str, "%Y-%m-%dT%H:%M:%S.%fZ")
        current_datetime = datetime.utcnow()
        if expires_datetime > current_datetime:
            pri = 50 # Subscription priority
    except Exception as e:
        print(f"Error: parse user data: {e}")
    return pri, name # Default priority

server_info = {}
def init_server():
    server_info = get_server_info()
    print('start_server:', json.dumps(server_info))
    post_v2a(server_id, 'start_server: ' + json.dumps(server_info))
    
def get_firebase_head():
    return r'''
    <script src="https://www.gstatic.com/firebasejs/8.6.8/firebase-app.js"></script>  
    <script src="https://www.gstatic.com/firebasejs/8.6.8/firebase-analytics.js"></script>
    <script>
    // Initialize Firebase
    const firebaseConfig = {
        apiKey: "AIzaSyDxjOeHF3LMfafohrnwLwMjg_SEy9wuBEI",
        authDomain: "v2a-web.firebaseapp.com",
        projectId: "v2a-web",
        storageBucket: "v2a-web.appspot.com",
        messagingSenderId: "845966199447",
        appId: "1:845966199447:web:90c659000db7f67d7637d2",
        measurementId: "G-6T6NJZXY0X"
    };
    firebase.initializeApp(firebaseConfig);
    const analytics = firebase.analytics();
    </script>
    '''