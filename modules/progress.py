import base64
import io
import time

import gradio as gr
from pydantic import BaseModel, Field

from modules.shared import opts

import modules.shared as shared
from modules.shared import queue_lock

current_task = None
pending_tasks = {}
images_results = {}
inputs_infos = {}
finished_tasks = []
recorded_results = []
recorded_results_limit = 2


def start_task(id_task):
    global current_task

    current_task = id_task
    pending_tasks.pop(id_task, None)


def finish_task(id_task):
    global current_task

    if current_task == id_task:
        current_task = None

    finished_tasks.append(id_task)
    if len(finished_tasks) > 16:
        finished_tasks.pop(0)


def record_results(id_task, res):
    recorded_results.append((id_task, res))
    if len(recorded_results) > recorded_results_limit:
        recorded_results.pop(0)

def save_images_results(id_task, images_path, inputs_info):
    images_results[id_task] = images_path
    inputs_infos[id_task] = inputs_info
    if len(images_results) > 16:
        images_results.pop(0)
    if len(inputs_infos) > 16:
        inputs_infos.pop(0)

def get_tasks_info():
    ret = {}
    ret['current_task'] = current_task
    ret['queue_tasks'] = len(pending_tasks)
    ret['finished_tasks'] = len(finished_tasks)
    return ret

def get_task_info(task_id):
    active = task_id == current_task
    queued = task_id in pending_tasks
    completed = task_id in finished_tasks
    if not active:
        pos, total = queue_lock.get_task_position(task_id)
    ret = {}
    ret['active'] = active
    ret['queued'] = queued
    ret['queue_pos'] = pos
    ret['queue_len'] = total
    ret['completed'] = completed
    return ret

def add_task_to_queue(id_job):
    pending_tasks[id_job] = time.time()


class ProgressRequest(BaseModel):
    id_task: str = Field(default=None, title="Task ID", description="id of the task to get progress for")
    id_live_preview: int = Field(default=-1, title="Live preview image ID", description="id of last received last preview image")


class ProgressResponse(BaseModel):
    active: bool = Field(title="Whether the task is being worked on right now")
    queued: bool = Field(title="Whether the task is in queue")
    completed: bool = Field(title="Whether the task has already finished")
    progress: float = Field(default=None, title="Progress", description="The progress with a range of 0 to 1")
    eta: float = Field(default=None, title="ETA in secs")
    live_preview: str = Field(default=None, title="Live preview image", description="Current live preview; a data: uri")
    id_live_preview: int = Field(default=None, title="Live preview image ID", description="Send this together with next request to prevent receiving same image")
    textinfo: str = Field(default=None, title="Info text", description="Info text used by WebUI.")
    images_path: list = Field(default=None, title="Images result", description="Generated images.")
    inputsinfo: str = Field(default=None, title="Inputs info", description="Info of input generated.")


def setup_progress_api(app):
    return app.add_api_route("/internal/progress", progressapi, methods=["POST"], response_model=ProgressResponse)


def progressapi(req: ProgressRequest):
    active = req.id_task == current_task
    queued = req.id_task in pending_tasks
    completed = req.id_task in finished_tasks

    images_path = []
    if completed:
        if req.id_task in images_results:
            images_path = images_results[req.id_task]
        if req.id_task in inputs_infos:
            inputs_info = inputs_infos[req.id_task]

    if not active:
        pos, total = queue_lock.get_task_position(req.id_task)
        remain_tasks = 0
        for task in pending_tasks:
            remain_tasks += 1
            if task == req.id_task:
                break
        return ProgressResponse(active=active, queued=queued, completed=completed, id_live_preview=-1, textinfo=f"In queue... {pos + 1}/{total} request(s) remaining until yours" if queued and pos >= 0 else "Waiting...", images_path=images_path, inputsinfo=inputs_info)

    progress = 0

    job_count, job_no = shared.state.job_count, shared.state.job_no
    sampling_steps, sampling_step = shared.state.sampling_steps, shared.state.sampling_step

    if job_count > 0:
        progress += job_no / job_count
    if sampling_steps > 0 and job_count > 0:
        progress += 1 / job_count * sampling_step / sampling_steps

    progress = min(progress, 1)

    elapsed_since_start = time.time() - shared.state.time_start
    predicted_duration = elapsed_since_start / progress if progress > 0 else None
    eta = predicted_duration - elapsed_since_start if predicted_duration is not None else None

    id_live_preview = req.id_live_preview
    shared.state.set_current_image()
    if opts.live_previews_enable and shared.state.id_live_preview != req.id_live_preview:
        image = shared.state.current_image
        if image is not None:
            buffered = io.BytesIO()

            if opts.live_previews_image_format == "png":
                # using optimize for large images takes an enormous amount of time
                if max(*image.size) <= 256:
                    save_kwargs = {"optimize": True}
                else:
                    save_kwargs = {"optimize": False, "compress_level": 1}

            else:
                save_kwargs = {}

            image.save(buffered, format=opts.live_previews_image_format, **save_kwargs)
            base64_image = base64.b64encode(buffered.getvalue()).decode('ascii')
            live_preview = f"data:image/{opts.live_previews_image_format};base64,{base64_image}"
            id_live_preview = shared.state.id_live_preview
        else:
            live_preview = None
    else:
        live_preview = None

    return ProgressResponse(active=active, queued=queued, completed=completed, progress=progress, eta=eta, live_preview=live_preview, id_live_preview=id_live_preview, textinfo=shared.state.textinfo if progress > 0 else "Processing...")


def restore_progress(id_task):
    while id_task == current_task or id_task in pending_tasks:
        time.sleep(0.1)

    res = next(iter([x[1] for x in recorded_results if id_task == x[0]]), None)
    if res is not None:
        return res

    return gr.update(), gr.update(), gr.update(), f"Couldn't restore progress for {id_task}: results either have been discarded or never were obtained"
