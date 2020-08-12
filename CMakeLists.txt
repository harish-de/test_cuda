cmake_minimum_required(VERSION 3.16)
project(test_cuda CUDA)

set(CMAKE_CUDA_STANDARD 14)
#set(CUDA_NVCC_FLAGS "${CUDA_NVCC_FLAGS};--expt-extended-lambda;")

FIND_PACKAGE(ArrayFire REQUIRED)

find_package( Boost REQUIRED )

include_directories(
        ${BOOST_INCLUDE_DIRS}
)

INCLUDE_DIRECTORIES(${ArrayFire_INCLUDE_DIRS})

add_executable(test_cuda main.cu arrayfireops.h arrayfireops.cu predicate/predicate.h predicate/predicate.cu type_conversion/host_to_device.h type_conversion/host_to_device.cu)

TARGET_LINK_LIBRARIES(test_cuda ${ArrayFire_LIBRARIES})

set(CMAKE_CUDA_FLAGS "${CMAKE_CUDA_FLAGS} \
    --expt-extended-lambda \
    ")

set_target_properties(
        test_cuda
        PROPERTIES
        CUDA_SEPARABLE_COMPILATION ON)
