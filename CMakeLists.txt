cmake_minimum_required(VERSION 3.16)
project(test_cuda CUDA)

set(CMAKE_CUDA_STANDARD 14)
#set(CUDA_NVCC_FLAGS "${CUDA_NVCC_FLAGS};--expt-extended-lambda;")

FIND_PACKAGE(ArrayFire REQUIRED)
INCLUDE_DIRECTORIES(${ArrayFire_INCLUDE_DIRS})

add_executable(test_cuda main.cu filter_arrayfire.cu)

TARGET_LINK_LIBRARIES(test_cuda ${ArrayFire_LIBRARIES})

set(CMAKE_CUDA_FLAGS "${CMAKE_CUDA_FLAGS} \
    --expt-extended-lambda \
    ")

set_target_properties(
        test_cuda
        PROPERTIES
        CUDA_SEPARABLE_COMPILATION ON)