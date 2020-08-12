//
// Created by harish on 10.08.20.
//

#ifndef TEST_CUDA_HOST_TO_DEVICE_H
#define TEST_CUDA_HOST_TO_DEVICE_H

#endif //TEST_CUDA_HOST_TO_DEVICE_H

#include <arrayfire.h>
#include <thrust/execution_policy.h>
#include <thrust/device_vector.h>

af::array getAFDeviceVector(std::vector<int> hostVector);
//
thrust::device_vector<int> getThrustDeviceVector(std::vector<int> hostVector);