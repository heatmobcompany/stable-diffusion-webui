from modules.priority_lock import PriorityLock

class QueueLock:
    def __init__(self, queue_lock: PriorityLock, pri=100, name=None):
        self._priority = pri
        self._name = name
        self.queue_lock = queue_lock

    def __enter__(self):
        self.queue_lock.acquire(self._priority, self._name)
        return self

    def __exit__(self, exc_type, exc_value, traceback):
        self.queue_lock.release()
