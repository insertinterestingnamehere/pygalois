from __future__ import division, print_function

from subprocess import check_output
from pygalois import run_torus_quiet as run_cython
import sys
import os.path

def run_cpp(threads, grid_size):
    bin_dir = os.path.dirname(sys.executable)
    torus_exe = os.path.join(bin_dir, "Galois", "example-torus")
    command = " ".join(torus_exe, str(threads), str(grid_size))
    output = str(check_output([command], shell=True))
    time = int(output.split(":")[1].split()[0])
    return time

def repeat_run(func, threads, grid_size, samples=20):
    times = [func(threads, grid_size) for i in range(samples)]
    avg = sum(times) / len(times)
    return avg

if __name__ == "__main__":
    thread_nums = map(int, sys.argv[1:])
    sizes = range(500, 1600, 100)
    for threads in thread_nums:
        print("using {} threads".format(threads))
        print("cpp times")
        print([repeat_run(run_cpp, threads, size) for size in sizes])
        print("cython times")
        print([repeat_run(run_cython, threads, size) for size in sizes])
