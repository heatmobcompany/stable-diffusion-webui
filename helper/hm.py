from modules import cmd_args
from helper.v2a_server import get_model_info
from helper.logging import Logger
logger = Logger("HM")

args, _ = cmd_args.parser.parse_known_args()

server_id = args.google_id if args.google_id else args.server_id
group = args.group
type = args.type
url = args.share_url

def get_server_info():
    groups = group.split(",")
    server_infos = []
    count = 0
    for _group in groups:
        count += 1
        server_info = {}
        server_info['id'] = f"{server_id}_{count}" if len(groups) > 1 else server_id
        server_info['group'] = _group
        server_info['type'] = type
        server_info['url'] = url
        
        try:
            res = get_model_info(_group)
            if (res and res['result']):
                server_info['icon'] = res['result']['icon']
                server_info['icon_web'] = res['result']['icon_web']
                server_info['file'] = res['result']['file']
                server_info['link_file'] = res['result']['link_file']
                server_info['civitaiLink'] = res['result']['civitaiLink']
                server_infos.append(server_info)
        except Exception as e:
            logger.error(f"Error: load style info: {_group} {e}")

    return server_infos

server_info = {}
server_infos = []
def init_server():
    server_infos = get_server_info()
    server_info = server_infos[0]
    # for server in server_infos:
    #     post_v2a(server["id"], 'start_server: ' + json.dumps(server))
    
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