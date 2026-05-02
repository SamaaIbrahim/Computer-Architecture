import numpy as np
import cupy as cp
import time
import matplotlib.pyplot as plt


SIZES = [128, 256, 512, 1024, 1536, 2048, 4000, 8000, 10000]
REPEATS = 10

def benchmark_cpu(n):
    times = []

    for _ in range(REPEATS):
        A = np.random.rand(n, n)
        B = np.random.rand(n, n)
        C = np.random.rand(n, n)

        start = time.perf_counter()
        D = A @ B @ C + A
        end = time.perf_counter()

        times.append(end - start)

    return np.mean(times)


def benchmark_gpu(n):
    times = []

    for _ in range(REPEATS):
        A = cp.random.rand(n, n, dtype=cp.float32)
        B = cp.random.rand(n, n, dtype=cp.float32)
        C = cp.random.rand(n, n, dtype=cp.float32)

        start = cp.cuda.Event()
        stop = cp.cuda.Event()

        start.record()

        D = A @ B @ C + A

        stop.record()
        stop.synchronize()

        gpu_time_ms = cp.cuda.get_elapsed_time(start, stop)
        times.append(gpu_time_ms / 1000.0)   # convert to sec

        del A, B, C, D
        cp.get_default_memory_pool().free_all_blocks()

    return np.mean(times)


cpu_times = []
gpu_times = []
speedups = []

print("Running benchmark...\n")

for n in SIZES:
    print(f"Matrix size: {n}x{n}")

    cpu_t = benchmark_cpu(n)
    gpu_t = benchmark_gpu(n)

    cpu_times.append(cpu_t)
    gpu_times.append(gpu_t)

    speedups.append(cpu_t / gpu_t)

    print(f"  CPU  : {cpu_t:.6f} sec")
    print(f"  GPU  : {gpu_t:.6f} sec")
    print(f"  Speedup (CPU/GPU): {cpu_t / gpu_t:.2f}x\n")


plt.figure(figsize=(10, 5))

plt.plot(SIZES, cpu_times, marker='o', label="NumPy (CPU)")
plt.plot(SIZES, gpu_times, marker='o', label="CuPy (GPU)")

plt.xlabel("Matrix Size (N x N)")
plt.ylabel("Time (seconds)")
plt.title("CPU vs GPU Matrix Multiplication Performance")
plt.legend()
plt.grid(True)

plt.show()


# Speedup plot
plt.figure(figsize=(10, 5))
plt.plot(SIZES, speedups, marker='o', color='green')
plt.xlabel("Matrix Size (N x N)")
plt.ylabel("Speedup (CPU / GPU)")
plt.title("GPU Speedup over CPU")
plt.grid(True)

plt.show()