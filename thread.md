

```python
# Lock
import threading
shared_resource_with_lock     = 0
shared_resource_with_no_lock     = 0
COUNT = 100000
shared_resource_lock = threading.Lock()

def increment_with_lock():
    global shared_resource_with_lock
    for i in range(COUNT):
        shared_resource_lock.acquire()
        shared_resource_with_lock += 1
        shared_resource_lock.release()

def decrement_with_lock():
    global shared_resource_with_lock
    for i in range(COUNT):
        shared_resource_lock.acquire()
        shared_resource_with_lock -= 1
        shared_resource_lock.release()
        
def increment_without_lock():
    global shared_resource_with_no_lock
    for i in range(COUNT):
        shared_resource_with_no_lock += 1
 
def decrement_without_lock():
    global shared_resource_with_no_lock
    for i in range(COUNT):
        shared_resource_with_no_lock -= 1
 
if __name__ == "__main__":
    ts=[threading.Thread(target = increment_with_lock),
        threading.Thread(target = decrement_with_lock),
        threading.Thread(target = increment_without_lock),
        threading.Thread(target = decrement_without_lock)]
    for t in ts: t.start()
    for t in ts: t.join()
    print ("the value of shared variable with lock management is %s"%shared_resource_with_lock)
    print ("the value of shared variable with race condition is %s"%shared_resource_with_no_lock)
    

```

    the value of shared variable with lock management is 0
    the value of shared variable with race condition is 0
    


```python
# RLock
import threading
import time

class Box(object):
    lock = threading.RLock()
    def __init__(self):
        self.total_items = 0
    def add(self):
        Box.lock.acquire()
        self.total_items+=1
        Box.lock.release()
    def remove(self):
        Box.lock.acquire()
        self.total_items-=1
        Box.lock.release()

def adder(box,items):
    while items > 0:
        print ("adding 1 item in the box\n")
        box.add()
        time.sleep(3)
        items -= 1

def remover(box,items):
    while items > 0:
        print ("removing 1 item in the box")
        box.remove()
        time.sleep(1)
        items -= 1

if __name__ == "__main__":
    items = 5
    print ("putting %s items in the box " % items)
    box = Box()
    ts=[threading.Thread(target=adder,args=(box,items)),
        threading.Thread(target=remover,args=(box,items))]
    for t in ts: t.start()
    for t in ts: t.join()
    print ("%s items still remain in the box " % box.total_items)

```

    putting 5 items in the box 
    adding 1 item in the box
    
    removing 1 item in the box
    removing 1 item in the box
    removing 1 item in the box
    adding 1 item in the box
    
    removing 1 item in the box
    removing 1 item in the box
    adding 1 item in the box
    
    adding 1 item in the box
    
    adding 1 item in the box
    
    0 items still remain in the box 
    


```python
# Queue
from threading import Thread, Event
from queue import Queue
import time
import random

class producer(Thread):
    def __init__(self, queue):
        Thread.__init__(self)
        self.queue = queue

    def run(self) :
        for i in range(10):
            item = random.randint(0, 256)
            self.queue.put(item)
            print ('Producer notify : item N° %d appended to queue by %s \n' % (item, self.name))
            time.sleep(1)

class consumer(Thread):
    def __init__(self, queue):
        Thread.__init__(self)
        self.queue = queue

    def run(self):
        while True:
            item = self.queue.get()
            print ('Consumer notify : %d popped from queue by %s' % (item, self.name))
            self.queue.task_done()

if __name__ == '__main__':
        queue = Queue()
        t1 = producer(queue)
        t2 = consumer(queue)
        t3 = consumer(queue)
        t1.start()
        t2.start()
        t3.start()
        t1.join()
        t2.join()
        t3.join()
```

    Producer notify : item N° 249 appended to queue by Thread-1502486 
    
    Consumer notify : 249 popped from queue by Thread-1502487
    Producer notify : item N° 64 appended to queue by Thread-1502486 
    Consumer notify : 64 popped from queue by Thread-1502487
    
    Producer notify : item N° 89 appended to queue by Thread-1502486 
    Consumer notify : 89 popped from queue by Thread-1502488
    
    Producer notify : item N° 160 appended to queue by Thread-1502486 
    Consumer notify : 160 popped from queue by Thread-1502487
    
    Producer notify : item N° 120 appended to queue by Thread-1502486 
    Consumer notify : 120 popped from queue by Thread-1502488
    
    Producer notify : item N° 172 appended to queue by Thread-1502486 
    Consumer notify : 172 popped from queue by Thread-1502487
    
    Producer notify : item N° 158 appended to queue by Thread-1502486 
    Consumer notify : 158 popped from queue by Thread-1502488
    
    Producer notify : item N° 176 appended to queue by Thread-1502486 
    Consumer notify : 176 popped from queue by Thread-1502487
    
    Producer notify : item N° 152 appended to queue by Thread-1502486 
    Consumer notify : 152 popped from queue by Thread-1502488
    
    Producer notify : item N° 210 appended to queue by Thread-1502486 
    Consumer notify : 210 popped from queue by Thread-1502487
    
    


```python
# Semaphore
import threading
import time
import random

# The optional argument init value for the internal counter (defaults to 1)
# If the value given is less than 0, ValueError is raised.
semaphore = threading.Semaphore(0)

def consumer():
    print ("consumer is waiting.")
    semaphore.acquire()
    print ("Consumer notify : consumed item number %s " %item)

def producer():
    global item
    time.sleep(10)
    item = random.randint(0,1000)
    print ("producer notify : producted item number %s" %item)
    semaphore.release()

if __name__ == '__main__':
    for i in range (0,5) :
        t1 = threading.Thread(target=producer)
        t2 = threading.Thread(target=consumer)
        t1.start()
        t2.start()
        t1.join()
        t2.join()
    print ("program terminated")

```

    consumer is waiting.
    producer notify : producted item number 345
    Consumer notify : consumed item number 345 
    consumer is waiting.
    producer notify : producted item number 712
    Consumer notify : consumed item number 712 
    consumer is waiting.
    producer notify : producted item number 388
    Consumer notify : consumed item number 388 
    consumer is waiting.
    producer notify : producted item number 102
    Consumer notify : consumed item number 102 
    consumer is waiting.
    producer notify : producted item number 106
    Consumer notify : consumed item number 106 
    program terminated
    
