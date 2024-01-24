import random
import string
import threading
import time

def custom_sort_key(item):
    # sort by priority
    return item[0]
class MyPriorityQueue:
    def __init__(self):
        self._queue = []

    def put(self, priority, item):
        self._queue.append((priority, item))
        self._queue.sort(key=custom_sort_key)

    def get(self):
        if self._queue:
            return self._queue.pop(0)[1]
        else:
            raise IndexError("PriorityQueue is empty")

    def empty(self):
        return not bool(self._queue)

    def qsize(self):
        return len(self._queue)

    def get_highest_priority(self):
        if self._queue:
            return self._queue[0][0]
        else:
            return None

    def get_lowest_priority(self):
        if self._queue:
            return self._queue[-1][0]
        else:
            return None

    def get_item_highest_priority(self):
        if self._queue:
            return self._queue[0][1]
        else:
            return None

    def get_item_lowest_priority(self):
        if self._queue:
            return self._queue[-1][1]
        else:
            return None

    def get_item_position(self, item):
        pos = -1
        for index, (priority, current_item) in enumerate(self._queue):
            if current_item == item:
                pos = index
                break
        total = len(self._queue)
        return pos, total

    def get_task_position(self, task):
        pos = -1
        filtered_list = [(pri, item) for (pri, item) in self._queue if item.startswith('task(')]
        for index, (pri, item) in enumerate(filtered_list):
            if item == task:
                pos = index
                break
        total = len(filtered_list)
        return pos, total

class PriorityLock:
    def __init__(self, name=None):
        print(f"=== Initialize queue lock: {name if name else 'unknown'} ===")
        self._lock = threading.Lock()
        self._wait_queue = MyPriorityQueue()
        self._locking = False
        self._name = ''
        self._pri = 0
        
    def get_queue_position(self, name):
        return self._wait_queue.get_item_position(name)

    def get_task_position(self, name):
        return self._wait_queue.get_task_position(name)

    def acquire(self, priority=0, name=None):
        if not name:
            letters = string.ascii_letters
            name = ''.join(random.choice(letters) for i in range(10))

        with self._lock:
            self._wait_queue.put(priority, name)

        while True:
            with self._lock:
                if self._wait_queue.get_item_highest_priority() is name and not self._locking:
                    self._locking = True
                    self._name = name
                    self._pri = priority
                    self._wait_queue.get()
                    return
            time.sleep(1)

    def release(self):
        with self._lock:
            self._locking = False
