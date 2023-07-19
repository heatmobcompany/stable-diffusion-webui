import html
import threading
import time
from helper.hm import get_user_priority

from modules import shared, progress, errors
from modules.priority_lock import PriorityLock
from modules.shared import queue_lock

class QueueLock:
    def __init__(self, pri=100, name=None):
        self._priority = pri
        self._name = name

    def __enter__(self):
        queue_lock.acquire(self._priority, self._name)
        return self

    def __exit__(self, exc_type, exc_value, traceback):
        queue_lock.release()

def wrap_queued_call(func):
    def f(*args, **kwargs):
        with QueueLock():
            res = func(*args, **kwargs)

        return res

    return f


def wrap_gradio_gpu_call(func, extra_outputs=None):
    def f(*args, **kwargs):

        # if the first argument is a string that says "task(...)", it is treated as a job id
        if args and type(args[0]) == str and args[0].startswith("task(") and args[0].endswith(")"):
            id_task = args[0]
            progress.add_task_to_queue(id_task)
        else:
            id_task = None

        pri, name = 100, None
        if args and type(args[1]) == str and args[1].startswith("token:"):
            token = args[1].replace('token:', '')
            pri, name = get_user_priority(token)
        print('wrap_gradio_gpu_call wait', pri, name, id_task)
        with QueueLock(pri, id_task):
            shared.state.begin()
            print('wrap_gradio_gpu_call start', pri, name, id_task)
            progress.start_task(id_task)

            try:
                res = func(*args, **kwargs)
                progress.record_results(id_task, res)
            finally:
                progress.finish_task(id_task)

            shared.state.end()
            print('wrap_gradio_gpu_call done', pri, name, id_task)
        return res

    return wrap_gradio_call(f, extra_outputs=extra_outputs, add_stats=True)


def wrap_gradio_call(func, extra_outputs=None, add_stats=False):
    def f(*args, extra_outputs_array=extra_outputs, **kwargs):
        run_memmon = shared.opts.memmon_poll_rate > 0 and not shared.mem_mon.disabled and add_stats
        if run_memmon:
            shared.mem_mon.monitor()
        t = time.perf_counter()

        try:
            res = list(func(*args, **kwargs))
        except Exception as e:
            # When printing out our debug argument list,
            # do not print out more than a 100 KB of text
            max_debug_str_len = 131072
            message = "Error completing request"
            arg_str = f"Arguments: {args} {kwargs}"[:max_debug_str_len]
            if len(arg_str) > max_debug_str_len:
                arg_str += f" (Argument list truncated at {max_debug_str_len}/{len(arg_str)} characters)"
            errors.report(f"{message}\n{arg_str}", exc_info=True)

            shared.state.job = ""
            shared.state.job_count = 0

            if extra_outputs_array is None:
                extra_outputs_array = [None, '']

            error_message = f'{type(e).__name__}: {e}'
            res = extra_outputs_array + [f"<div class='error'>{html.escape(error_message)}</div>"]

        shared.state.skipped = False
        shared.state.interrupted = False
        shared.state.job_count = 0

        if not add_stats:
            return tuple(res)

        elapsed = time.perf_counter() - t
        elapsed_m = int(elapsed // 60)
        elapsed_s = elapsed % 60
        elapsed_text = f"{elapsed_s:.2f}s"
        if elapsed_m > 0:
            elapsed_text = f"{elapsed_m}m "+elapsed_text

        if run_memmon:
            mem_stats = {k: -(v//-(1024*1024)) for k, v in shared.mem_mon.stop().items()}
            active_peak = mem_stats['active_peak']
            reserved_peak = mem_stats['reserved_peak']
            sys_peak = mem_stats['system_peak']
            sys_total = mem_stats['total']
            sys_pct = round(sys_peak/max(sys_total, 1) * 100, 2)

            vram_html = f"<p class='vram'>Torch active/reserved: {active_peak}/{reserved_peak} MiB, <wbr>Sys VRAM: {sys_peak}/{sys_total} MiB ({sys_pct}%)</p>"
        else:
            vram_html = ''

        # last item is always HTML
        res[-1] += f"<div class='performance'><p class='time'>Time taken: <wbr>{elapsed_text}</p>{vram_html}</div>"

        return tuple(res)

    return f
