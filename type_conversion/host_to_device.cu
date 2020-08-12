//
// Created by harish on 10.08.20.
//

#include <arrayfire.h>
#include <thrust/device_vector.h>

af::array getAFDeviceVector(std::vector<int> hostVector){
    int* hostData = &hostVector[0];
    af::array deviceData((dim_t)hostVector.size(), hostData);
    return deviceData;
}

thrust::device_vector<int> getThrustDeviceVector(std::vector<int> hostVector){
    thrust::host_vector<int> hostData(hostVector);
    thrust::device_vector<int> deviceData = hostData;
    return deviceData;
}

