// various functions for interaction with ui.py not large enough to warrant putting them in separate files

function set_theme(theme) {
    var gradioURL = window.location.href;
    if (!gradioURL.includes('?__theme=')) {
        window.location.replace(gradioURL + '?__theme=' + theme);
    }
}

window.max_w = 896
window.max_h = 896

document.addEventListener("DOMContentLoaded", async function() {
    await initialize();
});

function delay(ms) { return new Promise(resolve => setTimeout(resolve, ms)) }
async function check_tk() {
    const urlParams = new URLSearchParams(window.location.search);
    const token = urlParams.get('token');
    let isValid = false;
    let _s = false;
    if (!token) {
        window.location.href = window.topWeb
        return
    }
    try {
        var xhr = new XMLHttpRequest();
        xhr.open('GET', `${window.topApi}/account/user-info`, false);
        xhr.setRequestHeader('Authorization', 'Bearer ' + token);
        xhr.setRequestHeader('Content-Type', 'application/json');
        xhr.send();
        if (xhr.status === 200) {
            var res = JSON.parse(xhr.responseText);
            isValid = res?.success
            if (res && res.data && res.data.subscription) {
                const expirationDate = new Date(res.data.subscription.expires);
                const currentDate = new Date();
                _s = expirationDate > currentDate;
                window._s = _s
            }
        }
    } catch {
        console.error('Error getting user infomation!!!')
    }
    if (!isValid) {
        window.location.href = window.topWeb
        return
    }
    if (!_s) {
        var nsfw = gradioApp().querySelector("#nsfw_negative_switch > label > input");
        const nsfwlabel = document.querySelector('#nsfw_negative_switch > label');
        nsfwlabel.addEventListener('click', () => {
            if (nsfw.disabled) {
                window.parent?.postMessage({ message: "onlySubscription", data: undefined }, "*");
            }
        });
        if (nsfw) nsfw.disabled = true;
        else console.error('Can not get NSFW checkbox')
    } else {
        window.max_w = 1024
        window.max_h = 1024
    }

    const sizeIds = ["txt2img_width", "txt2img_height", "img2img_width", "img2img_height"]
    sizeIds.forEach(item => {
        const inputs = document.querySelectorAll(`#${item} input`);
        inputs.forEach(input => {
            input.setAttribute('max', window.max_w);
        });
    })

    const sizeIds2 = ["extras_upscaling_resize_w", "extras_upscaling_resize_h"]
    sizeIds2.forEach(item => {
        const inputs = document.querySelectorAll(`#${item} input`);
        inputs.forEach(input => {
            input.setAttribute('max', 4 * window.max_w);
        });
    })
}

function get_model_checkpoint(style) {
    try {
        var xhr = new XMLHttpRequest();
        xhr.open('GET', `https://beta-api.v2a.ai/sdstyle/getsimple?name=${style}`, false);
        xhr.setRequestHeader('Content-Type', 'application/json');
        xhr.send();
        if (xhr.status === 200) {
            let res = JSON.parse(xhr.responseText);
            let model_checkpoint =  res?.result?.file
            if (!model_checkpoint) {
                console.error('Empty model checkpoint')
            }
            return model_checkpoint
        } else {
            console.error('Error getting model checkpoint, code:', xhr.status)
        }
    } catch (err) {
        console.error('Error getting model checkpoint', err)
    }
}

async function initialize() {
    window.topWeb = "https://beta.vision2art.ai"
    window.topApi = "https://web-api.vision2art.ai"
    window.tasks_info = {}
    
    // Wait until document loaded
    while (!gradioApp().querySelector('#footer')) {
        await delay(200);
    }

    async function handleWindowMessage(event) {
        if (event.data && event.data.message) {
            console.log('SD message received:', event.data);
            if (event.data.message == "InitData") {
                window.topWeb = event.origin
                window.topApi = event.data.data.api
                window.style = event.data.data.style
                window.model_checkpoint = get_model_checkpoint(window.style)
                await check_tk();
            }    
        }
    }
    window.addEventListener('message', handleWindowMessage);
    window.parent?.postMessage({ message: "SdDOMLoaded", data: undefined }, "*");
}

function all_gallery_buttons() {
    var allGalleryButtons = gradioApp().querySelectorAll('[style="display: block;"].tabitem div[id$=_gallery].gradio-gallery .thumbnails > .thumbnail-item.thumbnail-small');
    var visibleGalleryButtons = [];
    allGalleryButtons.forEach(function (elem) {
        if (elem.parentElement.offsetParent) {
            visibleGalleryButtons.push(elem);
        }
    });
    return visibleGalleryButtons;
}

function selected_gallery_button() {
    var allCurrentButtons = gradioApp().querySelectorAll('[style="display: block;"].tabitem div[id$=_gallery].gradio-gallery .thumbnail-item.thumbnail-small.selected');
    var visibleCurrentButton = null;
    allCurrentButtons.forEach(function (elem) {
        if (elem.parentElement.offsetParent) {
            visibleCurrentButton = elem;
        }
    });
    return visibleCurrentButton;
}

function selected_gallery_index() {
    var buttons = all_gallery_buttons();
    var button = selected_gallery_button();

    var result = -1;
    buttons.forEach(function (v, i) {
        if (v == button) {
            result = i;
        }
    });

    return result;
}

function extract_image_from_gallery(gallery) {
    if (gallery.length == 0) {
        return [null];
    }
    if (gallery.length == 1) {
        return [gallery[0]];
    }

    var index = selected_gallery_index();

    if (index < 0 || index >= gallery.length) {
        // Use the first image in the gallery as the default
        index = 0;
    }

    return [gallery[index]];
}

window.args_to_array = Array.from; // Compatibility with e.g. extensions that may expect this to be around

function switch_to_txt2img() {
    gradioApp().querySelector('#tabs').querySelectorAll('button')[0].click();

    return Array.from(arguments);
}

function switch_to_img2img_tab(no) {
    gradioApp().querySelector('#tabs').querySelectorAll('button')[1].click();
    gradioApp().getElementById('mode_img2img').querySelectorAll('button')[no].click();
}
function switch_to_img2img() {
    switch_to_img2img_tab(0);
    return Array.from(arguments);
}

function switch_to_sketch() {
    switch_to_img2img_tab(1);
    return Array.from(arguments);
}

function switch_to_inpaint() {
    switch_to_img2img_tab(2);
    return Array.from(arguments);
}

function switch_to_inpaint_sketch() {
    switch_to_img2img_tab(3);
    return Array.from(arguments);
}

function switch_to_extras() {
    gradioApp().querySelector('#tabs').querySelectorAll('button')[2].click();

    return Array.from(arguments);
}

function get_tab_index(tabId) {
    let buttons = gradioApp().getElementById(tabId).querySelector('div').querySelectorAll('button');
    for (let i = 0; i < buttons.length; i++) {
        if (buttons[i].classList.contains('selected')) {
            return i;
        }
    }
    return 0;
}

function create_tab_index_args(tabId, args) {
    var res = Array.from(args);
    res[0] = get_tab_index(tabId);
    return res;
}

function get_img2img_tab_index() {
    let res = Array.from(arguments);
    res.splice(-2);
    res[0] = get_tab_index('mode_img2img');
    return res;
}

function create_submit_args(args) {
    var res = Array.from(args);

    // As it is currently, txt2img and img2img send back the previous output args (txt2img_gallery, generation_info, html_info) whenever you generate a new image.
    // This can lead to uploading a huge gallery of previously generated images, which leads to an unnecessary delay between submitting and beginning to generate.
    // I don't know why gradio is sending outputs along with inputs, but we can prevent sending the image gallery here, which seems to be an issue for some.
    // If gradio at some point stops sending outputs, this may break something
    if (Array.isArray(res[res.length - 3])) {
        res[res.length - 3] = null;
    }

    return res;
}

function showSubmitButtons(tabname, show) {
    gradioApp().getElementById(tabname + '_interrupt').style.display = show ? "none" : "block";
    // gradioApp().getElementById(tabname + '_skip').style.display = show ? "none" : "block";
}

function showRestoreProgressButton(tabname, show) {
    var button = gradioApp().getElementById(tabname + "_restore_progress");
    if (!button) return;

    button.style.display = show ? "flex" : "none";
}

function getUrlParams() {
    const urlSearchParams = new URLSearchParams(window.location.search);
    const queryParams = {};

    for (const [key, value] of urlSearchParams.entries()) {
        queryParams[key] = value;
    }

    return queryParams;
}

// Search NSFW_PROMPT in python code to update
const NSFW_PROMPT = ",nsfw,nude,topless,nipples,nudity,pussy,penis,cum,big tits,big tit"
function replaceAll(input, from, to) {
    const regex = new RegExp(from, 'g');
    const ret = input.replace(regex, to);
    return ret;
}
  
function submit() {
    // console.log('Submit txt2img')
    window.parent?.postMessage({ message: "logEvent", name: "generate_button_click", data: { button_id: 'txt2img_generate', button_text: 'Generate' } }, "*");
    checkCredit();
    showSubmitButtons('txt2img', false);

    var id = randomId();
    localStorage.setItem("txt2img_task_id", id);
    window.tasks_info[id] = {}
    window.tasks_info[id].action = "txt2img_generate"

    requestProgress(id, gradioApp().getElementById('txt2img_gallery_container'), gradioApp().getElementById('txt2img_gallery'), function () {
        showSubmitButtons('txt2img', true);
        localStorage.removeItem("txt2img_task_id");
        showRestoreProgressButton('txt2img', false);
    });

    var res = create_submit_args(arguments);

    res[0] = id;
    res[1] = `token:${getUrlParams().token}`;
    res[2] = window.model_checkpoint || opts.sd_model_checkpoint;
    var nsfw = gradioApp().querySelector("#nsfw_negative_switch > label > input");
    if (nsfw && nsfw.checked) {
        const nsfwArray = NSFW_PROMPT.split(',')
        for (let idx in nsfwArray) {
            res[3] = replaceAll(res[3], nsfwArray[idx].trim(), '')
        }
        res[4] += NSFW_PROMPT
    }

    return res;
}

function submit_img2img() {
    // console.log('Submit img2img')
    window.parent?.postMessage({ message: "logEvent", name: "generate_button_click", data: { button_id: 'img2img_generate', button_text: 'Generate' } }, "*");

    checkCredit();
    showSubmitButtons('img2img', false);

    var id = randomId();
    localStorage.setItem("img2img_task_id", id);
    window.tasks_info[id] = {}
    window.tasks_info[id].action = "img2img_generate"

    requestProgress(id, gradioApp().getElementById('img2img_gallery_container'), gradioApp().getElementById('img2img_gallery'), function () {
        showSubmitButtons('img2img', true);
        localStorage.removeItem("img2img_task_id");
        showRestoreProgressButton('img2img', false);
    });

    var res = create_submit_args(arguments);

    res[0] = id;
    res[1] = `token:${getUrlParams().token}`;
    res[2] = window.model_checkpoint || opts.sd_model_checkpoint;
    res[3] = get_tab_index('mode_img2img');
    var nsfw = gradioApp().querySelector("#nsfw_negative_switch > label > input");
    if (nsfw && nsfw.checked) {
        const nsfwArray = NSFW_PROMPT.split(',')
        for (let idx in nsfwArray) {
            res[4] = replaceAll(res[4], nsfwArray[idx].trim(), '')
        }
        res[5] += NSFW_PROMPT
    }

    return res;
}

function submit_extras() {
    // console.log('Submit extras')
    window.parent?.postMessage({ message: "logEvent", name: "generate_button_click", data: { button_id: 'extras_generate', button_text: 'Generate' } }, "*");

    checkCredit();

    const urlParams = new URLSearchParams(window.location.search);
    const token = urlParams.get('token');
    fetch(`${window.topApi}/account/use-credit`, {
        method: 'POST',
        headers: {
            'Authorization': `Bearer ${token}`,
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            action: "extras_generate",
            infodata: {
                sd_model_checkpoint: window.model_checkpoint || opts.sd_model_checkpoint
            }
        })
    })
        .then(response => response.json())
        .catch(error => {
            console.error('Error occurred during token verification:', error);
        });

    var id = randomId();
    var res = create_submit_args(arguments);
    res[0] = id;
    res[1] = `token:${getUrlParams().token}`;

    return res;
}

function restoreProgressTxt2img() {
    showRestoreProgressButton("txt2img", false);
    var id = localStorage.getItem("txt2img_task_id");

    id = localStorage.getItem("txt2img_task_id");

    if (id) {
        requestProgress(id, gradioApp().getElementById('txt2img_gallery_container'), gradioApp().getElementById('txt2img_gallery'), function () {
            showSubmitButtons('txt2img', true);
        }, null, 0);
    }

    return id;
}

function restoreProgressImg2img() {
    showRestoreProgressButton("img2img", false);

    var id = localStorage.getItem("img2img_task_id");

    if (id) {
        requestProgress(id, gradioApp().getElementById('img2img_gallery_container'), gradioApp().getElementById('img2img_gallery'), function () {
            showSubmitButtons('img2img', true);
        }, null, 0);
    }

    return id;
}


onUiLoaded(function () {
    showRestoreProgressButton('txt2img', localStorage.getItem("txt2img_task_id"));
    showRestoreProgressButton('img2img', localStorage.getItem("img2img_task_id"));
});


function modelmerger() {
    var id = randomId();
    requestProgress(id, gradioApp().getElementById('modelmerger_results_panel'), null, function () { });

    var res = create_submit_args(arguments);
    res[0] = id;
    return res;
}


function ask_for_style_name(_, prompt_text, negative_prompt_text) {
    var name_ = prompt('Style name:');
    return [name_, prompt_text, negative_prompt_text];
}

function confirm_clear_prompt(prompt, negative_prompt) {
    if (confirm("Delete prompt?")) {
        prompt = "";
        negative_prompt = "";
    }

    return [prompt, negative_prompt];
}


var opts = {};
onAfterUiUpdate(function() {
    if (Object.keys(opts).length != 0) return;

    var json_elem = gradioApp().getElementById('settings_json');
    if (json_elem == null) return;

    var textarea = json_elem.querySelector('textarea');
    var jsdata = textarea.value;
    opts = JSON.parse(jsdata);

    executeCallbacks(optionsChangedCallbacks); /*global optionsChangedCallbacks*/

    Object.defineProperty(textarea, 'value', {
        set: function (newValue) {
            var valueProp = Object.getOwnPropertyDescriptor(HTMLTextAreaElement.prototype, 'value');
            var oldValue = valueProp.get.call(textarea);
            valueProp.set.call(textarea, newValue);

            if (oldValue != newValue) {
                opts = JSON.parse(textarea.value);
            }

            executeCallbacks(optionsChangedCallbacks);
        },
        get: function () {
            var valueProp = Object.getOwnPropertyDescriptor(HTMLTextAreaElement.prototype, 'value');
            return valueProp.get.call(textarea);
        }
    });

    json_elem.parentElement.style.display = "none";

    setupTokenCounters();

    var show_all_pages = gradioApp().getElementById('settings_show_all_pages');
    var settings_tabs = gradioApp().querySelector('#settings div');
    if (show_all_pages && settings_tabs) {
        settings_tabs.appendChild(show_all_pages);
        show_all_pages.onclick = function () {
            gradioApp().querySelectorAll('#settings > div').forEach(function (elem) {
                if (elem.id == "settings_tab_licenses") {
                    return;
                }

                elem.style.display = "block";
            });
        };
    }
});

onOptionsChanged(function () {
    var elem = gradioApp().getElementById('sd_checkpoint_hash');
    var sd_checkpoint_hash = opts.sd_checkpoint_hash || "";
    var shorthash = sd_checkpoint_hash.substring(0, 10);

    if (elem && elem.textContent != shorthash) {
        elem.textContent = shorthash;
        elem.title = sd_checkpoint_hash;
        elem.href = "https://google.com/search?q=" + sd_checkpoint_hash;
    }
});

let txt2img_textarea, img2img_textarea = undefined;

function restart_reload() {
    document.body.innerHTML = '<h1 style="font-family:monospace;margin-top:20%;color:lightgray;text-align:center;">Reloading...</h1>';

    var requestPing = function () {
        requestGet("./internal/ping", {}, function (data) {
            location.reload();
        }, function () {
            setTimeout(requestPing, 500);
        });
    };

    setTimeout(requestPing, 2000);

    return [];
}

// Simulate an `input` DOM event for Gradio Textbox component. Needed after you edit its contents in javascript, otherwise your edits
// will only visible on web page and not sent to python.
function updateInput(target) {
    let e = new Event("input", { bubbles: true });
    Object.defineProperty(e, "target", { value: target });
    target.dispatchEvent(e);
}


var desiredCheckpointName = null;
function selectCheckpoint(name) {
    desiredCheckpointName = name;
    gradioApp().getElementById('change_checkpoint').click();
}

function currentImg2imgSourceResolution(w, h, scaleBy) {
    var img = gradioApp().querySelector('#mode_img2img > div[style="display: block;"] img');
    return img ? [img.naturalWidth, img.naturalHeight, scaleBy] : [0, 0, scaleBy];
}

function scaleToImg2imgResolution(w, h, scaleBy, max_w, max_h) {
    var img = gradioApp().querySelector('#mode_img2img > div[style="display: block;"] img');
    if (img && (img.naturalWidth * scaleBy > window.max_w || img.naturalHeight * scaleBy > window.max_h)){
        let iratio = img.naturalWidth / img.naturalHeight;
        let fratio = window.max_w / window.max_h;
        if (iratio < fratio) {
            scaleBy = window.max_h / img.naturalHeight
        }
        else {
            scaleBy = window.max_w / img.naturalWidth
        }
    }
    return img ? [img.naturalWidth, img.naturalHeight, scaleBy, window.max_w, window.max_h] : [0, 0, scaleBy, window.max_w, window.max_h];
}

function detectCurrentImageResolution(w, h, scaleBy, max_w, max_h) {
    var img = gradioApp().querySelector('#mode_img2img > div[style="display: block;"] img');
    if (img && (img.naturalWidth > window.max_w || img.naturalHeight > window.max_h)){
        let iratio = img.naturalWidth / img.naturalHeight;
        let fratio = window.max_w / window.max_h;
        if (iratio > fratio) {
            scaleBy = window.max_w / img.naturalWidth
            return [window.max_w, Math.round(window.max_h / iratio), scaleBy]
        }
        else {
            scaleBy = window.max_h / img.naturalHeight
            return [Math.round(window.max_w * iratio), window.max_h, scaleBy]
        }
    }
    return img ? [img.naturalWidth, img.naturalHeight, scaleBy] : [0, 0, scaleBy];
}

function scaleToExtrasResolution(w, h, scaleBy, max_w, max_h) {
    console.log("scaleToExtrasResolution", w, h, scaleBy, max_w, max_h)
    var img = gradioApp().querySelector('#mode_extras > div[style="display: block;"] img');
    const _max_w = 4 * window.max_w;
    const _max_h = 4 * window.max_h;
    if (img && (img.naturalWidth * scaleBy > _max_w || img.naturalHeight * scaleBy > _max_h)){
        let iratio = img.naturalWidth / img.naturalHeight;
        let fratio = _max_w / _max_h;
        if (iratio < fratio) {
            scaleBy = _max_h / img.naturalHeight
        }
        else {
            scaleBy = _max_w / img.naturalWidth
        }
    }
    return img ? [img.naturalWidth, img.naturalHeight, scaleBy, _max_w, _max_h] : [0, 0, scaleBy, _max_w, _max_h];
}

function updateImg2imgResizeToTextAfterChangingImage() {
    // At the time this is called from gradio, the image has no yet been replaced.
    // There may be a better solution, but this is simple and straightforward so I'm going with it.

    setTimeout(function () {
        gradioApp().getElementById('img2img_update_resize_to').click();
    }, 500);

    return [];

}



function setRandomSeed(elem_id) {
    var input = gradioApp().querySelector("#" + elem_id + " input");
    if (!input) return [];

    input.value = "-1";
    updateInput(input);
    return [];
}

function switchWidthHeight(tabname) {
    var width = gradioApp().querySelector("#" + tabname + "_width input[type=number]");
    var height = gradioApp().querySelector("#" + tabname + "_height input[type=number]");
    if (!width || !height) return [];

    var tmp = width.value;
    width.value = height.value;
    height.value = tmp;

    updateInput(width);
    updateInput(height);
    return [];
}

function checkCredit() {
    const urlParams = new URLSearchParams(window.location.search);
    const token = urlParams.get('token');

    // Call the API endpoint to consume credit
    if (!token) {
        throw new Error('Token not found');
    }

    var xhr = new XMLHttpRequest();
    xhr.open('GET', `${window.topApi}/account/check-credit`, false);
    xhr.setRequestHeader('Authorization', 'Bearer ' + token);
    xhr.setRequestHeader('Content-Type', 'application/json');
    xhr.send();
    if (xhr.status === 200) {
        // console.log('Successfully checked credit');
    } else {
        var errorMessage = 'Request failed with status: ' + xhr.status;
        throw new Error(errorMessage);
    }
}

function getCurrentDateTime() {
    const now = new Date();
    const year = now.getFullYear().toString();
    const month = (now.getMonth() + 1).toString().padStart(2, '0');
    const day = now.getDate().toString().padStart(2, '0');
    const hours = now.getHours().toString().padStart(2, '0');
    const minutes = now.getMinutes().toString().padStart(2, '0');
    const seconds = now.getSeconds().toString().padStart(2, '0');
    
    return `${year}${month}${day}_${hours}${minutes}${seconds}`;
}

async function check_export(task_id, task_type, retry) {
    let txt = gradioApp().getElementById('export_component').textContent
    if (retry < 10) {
        if (txt.includes(task_id)) {
            let listStr = txt.split(task_id)
            let jsonData = listStr[listStr.length - 1];
            var blob = new Blob([jsonData], { type: 'application/json' });
            var anchor = document.createElement('a');
            anchor.href = URL.createObjectURL(blob);
            anchor.download = `${task_type}_${getCurrentDateTime()}.json`;
            anchor.click();
        } else {
            retry ++;
            setTimeout(() => check_export(task_id, task_type, retry), 1000);
        }
     } else {
        alert("Error in export parameter!")
    }
}

async function export_txt2img_parameters() {
    var res = create_submit_args(arguments);
    var task_id = randomId().replace('task', 'export');
    res[0] = task_id
    res[2] = window.model_checkpoint || opts.sd_model_checkpoint;
    setTimeout(() => check_export(task_id, "txt2img", 0), 1000);
    return res
}

async function export_img2img_parameters() {
    var res = create_submit_args(arguments);
    var task_id = randomId().replace('task', 'export');
    res[0] = task_id
    res[2] = window.model_checkpoint || opts.sd_model_checkpoint;
    setTimeout(() => check_export(task_id, "img2img", 0), 1000);
    return res
}