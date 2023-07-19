import random
import string
import threading

class MyPriorityQueue:
    def __init__(self):
        self._queue = []

    def put(self, priority, item):
        self._queue.append((priority, item))
        self._queue.sort()  # Sort the list based on priority

    def get(self):
        if self._queue:
            return self._queue.pop(0)[1]  # Return and remove the item with the highest priority
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
        for index, (priority, current_item) in enumerate(self._queue):
            if current_item == item:
                return index
        return -1

class PriorityLock:
    def __init__(self):
        print("=== Initialize queue lock ===")
        self._lock = threading.Lock()
        self._wait_queue = MyPriorityQueue()
        self._locking = False
        self._name = ''
        self._pri = 0
        
    def get_queue_position(self, name):
        pos = self._wait_queue.get_item_position(name)
        len = self._wait_queue.qsize()
        return pos, len

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
                    break

    def release(self):
        with self._lock:
            self._locking = False
