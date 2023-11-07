import time

from modules.progress import ProgressRequest, ProgressResponse

queue_tasks = {}
started_tasks = {}
finished_tasks = {}
failed_tasks = {}

images_results = {}
failed_results = {}

def add_task_to_queue(id_task):
    queue_tasks[id_task] = time.time()
    if len(queue_tasks) > 16:
        queue_tasks.pop(list(queue_tasks.keys())[0])

def start_task(id_task):
    if id_task in queue_tasks:
        time_task = queue_tasks.pop(id_task, None)
        started_tasks[id_task] = time_task
        if len(started_tasks) > 16:
            started_tasks.pop(list(started_tasks.keys())[0])
        return time_task

def finish_task(id_task):
    if id_task in started_tasks:
        time_task = started_tasks.pop(id_task, None)
        finished_tasks[id_task] = time_task
        if len(finished_tasks) > 16:
            finished_tasks.pop(list(finished_tasks.keys())[0])
        return time_task

def save_images_result(id_task, images_path):
    images_results[id_task] = images_path
    if len(images_results) > 16:
        images_results.pop(list(images_results.keys())[0])

def save_failure_result(id_task, result):
    failed_results[id_task] = result
    if len(failed_results) > 16:
        failed_results.pop(list(failed_results.keys())[0])

def setup_progress_extra_api(app):
    return app.add_api_route("/internal/progress-extra", progressextraapi, methods=["POST"], response_model=ProgressResponse)

def progressextraapi(req: ProgressRequest):
    active = req.id_task in started_tasks
    queued = req.id_task in queue_tasks
    completed = req.id_task in finished_tasks
    failed = req.id_task in failed_results

    images_path = []
    textinfo = "Waiting..."
    result_info = ""
    
    if completed:
        textinfo = "Finished"
        if req.id_task in images_results:
            images_path = images_results[req.id_task]
    if failed:
        textinfo = "Failed"
        result_info =  failed_results[req.id_task]
    if queued:
        textinfo = f"In queue"
    return ProgressResponse(active=active, queued=queued, completed=completed, failed=failed, id_live_preview=-1, textinfo=textinfo, images_path=images_path, inputsinfo="", result_info=result_info, progress=0)
