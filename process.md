

```python
import multiprocessing
import time

def foo():
    name = multiprocessing.current_process().name
    print ("Starting %s \n" %name)
    time.sleep(3)
    print ("Exiting %s \n" %name)
    
if __name__ == '__main__':
    background_process = multiprocessing.Process(name='background_process',target=foo)
    background_process.daemon = True # no child process, exit when parent process exit
    NO_background_process = multiprocessing.Process(name='NO_background_process',target=foo)
    NO_background_process.daemon = False
    background_process.start()
    NO_background_process.start()
    # NO_background_process.terminate() # force terminate
    
# Starting NO_background_process
# Exiting NO_background_process

```


```python
# Queue
import multiprocessing
import random
import time

class producer(multiprocessing.Process):
    def __init__(self, queue):
        multiprocessing.Process.__init__(self)
        self.queue = queue

    def run(self) :
        for i in range(10):
            item = random.randint(0, 256)
            self.queue.put(item)
            print ("Process Producer : item %d appended to queue %s"\
                   % (item,self.name))
            time.sleep(1)
            print ("The size of queue is %s"\
                   % self.queue.qsize())

class consumer(multiprocessing.Process):
    def __init__(self, queue):
        multiprocessing.Process.__init__(self)
        self.queue = queue

    def run(self):
        while True:
            if (self.queue.empty()):
                print("the queue is empty")
            else :
                time.sleep(2)
                item = self.queue.get()
                print ('Process Consumer : item %d popped from by %s \n'\
                       % (item, self.name))
                time.sleep(1)


if __name__ == '__main__':
        queue = multiprocessing.Queue()
        process_producer = producer(queue)
        process_consumer = consumer(queue)
        process_producer.start()
        process_consumer.start()
        process_producer.join()
        process_consumer.join()

```


```python
# Pipes
import multiprocessing

def create_items(pipe):
    output_pipe, _ = pipe
    for item in range(10):
        output_pipe.send(item)
    output_pipe.close()

def multiply_items(pipe_1, pipe_2):
    close, input_pipe = pipe_1
    close.close()
    output_pipe, _ = pipe_2
    try:
        while True:
            item = input_pipe.recv()
            output_pipe.send(item * item)
    except EOFError:
        output_pipe.close()


if __name__== '__main__':

    pipe_1 = multiprocessing.Pipe(True)
    process_pipe_1 = multiprocessing.Process(target=create_items, args=(pipe_1,))
    process_pipe_1.start()

    pipe_2 = multiprocessing.Pipe(True)
    process_pipe_2 =multiprocessing.Process(target=multiply_items, args=(pipe_1, pipe_2,))
    process_pipe_2.start()

    pipe_1[0].close()
    pipe_2[0].close()

    try:
        while True:
            print (pipe_2[1].recv())
    except EOFError:
        print ("End")

```


```python
# Process Pool
import multiprocessing

def function_square(data):
    result = data*data
    return result

if __name__ == '__main__':
    inputs = list(range(0,100))
    pool = multiprocessing.Pool(processes=4)
    pool_outputs = pool.map(function_square, inputs)

    pool.close() 
    pool.join()  
    print ('Pool    :', pool_outputs)

```
