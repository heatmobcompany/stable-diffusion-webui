// code related to showing and updating progressbar shown as the image is being made

function rememberGallerySelection() {

}

function getGallerySelectedIndex() {

}

function request(url, data, handler, errorHandler) {
    var xhr = new XMLHttpRequest();
    xhr.open("POST", url, true);
    xhr.setRequestHeader("Content-Type", "application/json");
    xhr.onreadystatechange = function () {
        if (xhr.readyState === 4) {
            if (xhr.status === 200) {
                try {
                    var js = JSON.parse(xhr.responseText);
                    handler(js);
                } catch (error) {
                    console.error(error);
                    errorHandler();
                }
            } else {
                errorHandler();
            }
        }
    };
    var js = JSON.stringify(data);
    xhr.send(js);
}

function pad2(x) {
    return x < 10 ? '0' + x : x;
}

function formatTime(secs) {
    if (secs > 3600) {
        return pad2(Math.floor(secs / 60 / 60)) + ":" + pad2(Math.floor(secs / 60) % 60) + ":" + pad2(Math.floor(secs) % 60);
    } else if (secs > 60) {
        return pad2(Math.floor(secs / 60)) + ":" + pad2(Math.floor(secs) % 60);
    } else {
        return Math.floor(secs) + "s";
    }
}

function setTitle(progress) {
    var title = 'Stable Diffusion';

    if (opts.show_progress_in_title && progress) {
        title = '[' + progress.trim() + '] ' + title;
    }

    if (document.title != title) {
        document.title = title;
    }
}


function randomId() {
    return "task(" + Math.random().toString(36).slice(2, 7) + Math.random().toString(36).slice(2, 7) + Math.random().toString(36).slice(2, 7) + ")";
}

// starts sending progress requests to "/internal/progress" uri, creating progressbar above progressbarContainer element and
// preview inside gallery element. Cleans up all created stuff when the task is over and calls atEnd.
// calls onProgress every time there is a progress update
function requestProgress(id_task, progressbarContainer, gallery, atEnd, onProgress, inactivityTimeout = 40) {
    var dateStart = new Date();
    var wasEverActive = false;
    var parentProgressbar = progressbarContainer.parentNode;
    var parentGallery = gallery ? gallery.parentNode : null;

    var divProgress = document.createElement('div');
    divProgress.className = 'progressDiv';
    divProgress.style.display = opts.show_progressbar ? "block" : "none";
    var divInner = document.createElement('div');
    divInner.className = 'progress';

    divProgress.appendChild(divInner);
    parentProgressbar.insertBefore(divProgress, progressbarContainer);

    if (parentGallery) {
        var livePreview = document.createElement('div');
        livePreview.className = 'livePreview';
        parentGallery.insertBefore(livePreview, gallery);
    }

    var removeProgressBar = function () {
        setTitle("");
        parentProgressbar.removeChild(divProgress);
        if (parentGallery) parentGallery.removeChild(livePreview);
        atEnd();
    };

    function getRandomName() {
        const length = 14;
        const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
        let result = '';
        for (let i = 0; i < length; i++) {
            const randomIndex = Math.floor(Math.random() * characters.length);
            result += characters.charAt(randomIndex);
        }
        return result;
    }
    async function getSignedRequest(fileName, token) {
        const url = `${window.topApi}/aws/signed-url?fileName=${encodeURIComponent(fileName)}&file-type=image/png`;
        const response = await fetch( url, {
            headers: {
                'Authorization': `Bearer ${token}`
            },
        });
        const data = await response.json();
        if (data.success) {
            return {
                signedRequest: data.data.signedRequest,
                url: data.data.url
            };
        } else {
            throw new Error(data.message || 'Request failed');
        }
    }
    async function uploadRequest(signedRequest, imageUrl) {
        const response = await fetch(imageUrl);
        const imageData = await response.blob();
        const putResponse = await fetch(signedRequest, {
            method: 'PUT',
            body: imageData
        });

        if (putResponse.ok) {
        } else {
            console.error('Error uploading image to S3:', putResponse.statusText);
        }
    }
    async function uploadImage(img_path, token) {
        return new Promise((resolve, eject) => {
            const img_name = getRandomName() + ".png"
            getSignedRequest(img_name, token)
                .then(({ signedRequest, url }) => {
                    const img_url = window.location.origin + '/file=' + img_path
                    uploadRequest(signedRequest, img_url)
                        .then(ret => {
                            resolve(url)
                        })
                })
        })
    }

    var fun = function (id_task, id_live_preview) {
        request("./internal/progress", { id_task: id_task, id_live_preview: id_live_preview }, function (res) {
            if (res.completed) {
                removeProgressBar();
                
                const urlParams = new URLSearchParams(window.location.search);
                const token = urlParams.get('token');
                const action = window?.tasks_info[id_task]?.action;
                const infodata = JSON.parse(res?.inputsinfo) || {};
                const images_result = res?.images_path;

                fetch(`${window.topApi}/account/use-credit`, {
                    method: 'POST',
                    headers: {
                        'Authorization': `Bearer ${token}`,
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({
                        action,
                        infodata: {
                            ...infodata,
                            sd_model_checkpoint: opts.sd_model_checkpoint,
                        },
                    })
                })
                    .then(response => response.json())
                    .catch(error => {
                        console.error('Error occurred during token verification:', error);
                    });

                const promises = images_result.map(img => uploadImage(img, token));
                Promise.all(promises)
                    .then(retUpload => {
                        fetch(`${window.topApi}/gallery/web-advance/submit-result`, {
                            method: 'POST',
                            headers: {
                                'Authorization': `Bearer ${token}`,
                                'Content-Type': 'application/json'
                            },
                            body: JSON.stringify({
                                task_id: id_task,
                                model: window.style,
                                api_type: `${action}`,
                                images_path: retUpload,
                                inputsinfo: res?.inputsinfo,
                            })
                        })
                            .then(retSubmit => {
                                // console.log(retSubmit)
                            })
                            .catch(e => {
                                console.error('Error occurred during submit result', e);
                            })
                    })
                    .catch(e => {
                        console.error('Error occurred during upload image', e);
                    })

                return;
            }

            var rect = progressbarContainer.getBoundingClientRect();

            if (rect.width) {
                divProgress.style.width = rect.width + "px";
            }

            let progressText = "";

            divInner.style.width = ((res.progress || 0) * 100.0) + '%';
            divInner.style.background = res.progress ? "" : "transparent";

            if (res.progress > 0) {
                progressText = ((res.progress || 0) * 100.0).toFixed(0) + '%';
            }

            if (res.eta) {
                progressText += " ETA: " + formatTime(res.eta);
            }


            setTitle(progressText);

            if (res.textinfo && res.textinfo.indexOf("\n") == -1) {
                progressText = res.textinfo + " " + progressText;
            }

            divInner.textContent = progressText;

            var elapsedFromStart = (new Date() - dateStart) / 1000;

            if (res.active) wasEverActive = true;

            if (!res.active && wasEverActive) {
                removeProgressBar();
                return;
            }

            if (elapsedFromStart > inactivityTimeout && !res.queued && !res.active) {
                removeProgressBar();
                return;
            }


            if (res.live_preview && gallery) {
                rect = gallery.getBoundingClientRect();
                if (rect.width) {
                    livePreview.style.width = rect.width + "px";
                    livePreview.style.height = rect.height + "px";
                }

                var img = new Image();
                img.onload = function () {
                    livePreview.appendChild(img);
                    if (livePreview.childElementCount > 2) {
                        livePreview.removeChild(livePreview.firstElementChild);
                    }
                };
                img.src = res.live_preview;
            }


            if (onProgress) {
                onProgress(res);
            }

            setTimeout(() => {
                fun(id_task, res.id_live_preview);
            }, opts.live_preview_refresh_period || 500);
        }, function () {
            removeProgressBar();
        });
    };

    fun(id_task, 0);
}
