

```python
import pycuda.gpuarray as gpuarray
import pycuda.driver as cuda
import pycuda.autoinit
import numpy

a_gpu = gpuarray.to_gpu(numpy.random.randn(5,5).astype(numpy.float32))
a_doubled = (2*a_gpu).get()
print ("ORIGINAL MATRIX")
print( a_doubled)
print ("DOUBLED MATRIX AFTER PyCUDA EXECUTION USING GPUARRAY CALL")
print( a_gpu)

```


      File "<ipython-input-1-6c9d8736f5b5>", line 9
        print a_doubled
                      ^
    SyntaxError: Missing parentheses in call to 'print'. Did you mean print(a_doubled)?
    



```python
import numpy as np
from pycuda import driver, compiler, gpuarray, tools

import pycuda.autoinit

kernel_code_template = """
__global__ void MatrixMulKernel(float *a, float *b, float *c)
{
    int tx = threadIdx.x;
    int ty = threadIdx.y;
    float Pvalue = 0;
    for (int k = 0; k < %(MATRIX_SIZE)s; ++k) {
        float Aelement = a[ty * %(MATRIX_SIZE)s + k];
        float Belement = b[k * %(MATRIX_SIZE)s + tx];
        Pvalue += Aelement * Belement;
    }

    c[ty * %(MATRIX_SIZE)s + tx] = Pvalue;
}
"""

MATRIX_SIZE = 5

a_cpu = np.random.randn(MATRIX_SIZE, MATRIX_SIZE).astype(np.float32)
b_cpu = np.random.randn(MATRIX_SIZE, MATRIX_SIZE).astype(np.float32)

c_cpu = np.dot(a_cpu, b_cpu)

a_gpu = gpuarray.to_gpu(a_cpu) 
b_gpu = gpuarray.to_gpu(b_cpu)

c_gpu = gpuarray.empty((MATRIX_SIZE, MATRIX_SIZE), np.float32)

kernel_code = kernel_code_template % {'MATRIX_SIZE': MATRIX_SIZE}

mod = compiler.SourceModule(kernel_code)

matrixmul = mod.get_function("MatrixMulKernel")

matrixmul(a_gpu, b_gpu, c_gpu, block = (MATRIX_SIZE, MATRIX_SIZE, 1),)

# print the results
print("-" * 80)
print("Matrix A (GPU):")
print(a_gpu.get())

print("-" * 80)
print("Matrix B (GPU):")
print(b_gpu.get())

print("-" * 80)
print("Matrix C (GPU):")
print(c_gpu.get())

print("-" * 80)
print("CPU-GPU difference:")
print(c_cpu - c_gpu.get())

np.allclose(c_cpu, c_gpu.get())

```


      File "<ipython-input-2-dab13421c48c>", line 43
        print "-" * 80
                ^
    SyntaxError: Missing parentheses in call to 'print'. Did you mean print("-" * 80)?
    



```python
import pycuda.gpuarray as gpuarray
import pycuda.autoinit
import numpy
from pycuda.reduction import ReductionKernel

vector_length = 400

input_vector_a = gpuarray.arange(vector_length, dtype=numpy.int)
input_vector_b = gpuarray.arange(vector_length, dtype=numpy.int)
dot_product = ReductionKernel(numpy.int,
                       arguments="int *x, int *y",
                       map_expr="x[i]*y[i]",
                       reduce_expr="a+b", neutral="0")

dot_product = dot_product(input_vector_a, input_vector_b).get()

print("INPUT MATRIX A")
print(input_vector_a)

print("INPUT MATRIX B")
print(input_vector_b)

print("RESULT DOT PRODUCT OF A * B")
print(dot_product)



```
