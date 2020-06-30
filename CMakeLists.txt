cmake_minimum_required(VERSION 3.16)
project(test_cuda CUDA)

set(CMAKE_CUDA_STANDARD 14)

add_executable(test_cuda main.cu)

set_target_properties(
        test_cuda
        PROPERTIES
        CUDA_SEPARABLE_COMPILATION ON)