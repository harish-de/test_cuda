#include <thrust/host_vector.h>
#include <thrust/device_vector.h>
#include <thrust/remove.h>
#include <thrust/copy.h>
#include <thrust/execution_policy.h>
#include <thrust/find.h>


#include <iostream>
#include <fstream>
#include <sstream>
#include<algorithm>

#define DSIZE 10

int main(void)
{

#ifndef __CUDACC_EXTENDED_LAMBDA__
    std::cout << "compile with extended lambdas " << std::endl;
#endif

    std::string filename = "/home/harish/Documents/lineitem/lineitem.tbl";

    std::vector<std::vector<int>> lineitemData;

    std::vector<int> rowVector;

    std::ifstream lineitemFile(filename);

    if(!lineitemFile.is_open())
        throw std::runtime_error("could not open file");

    std::string row;
    std::string values;

    while (lineitemFile.good()) {
        std::getline(lineitemFile, row);
        std::stringstream ss(row);
        int count = 0;
        while (std::getline(ss,values,'|')){
            if(count < 8 or (count >=10 and count <=12)){
                if(count >= 4 and count <=7) {
                    int val = std::stof(values) * 100;
                    rowVector.push_back(val);
                }
                else if(count >=10 and count <=12){
                    values.erase(remove(values.begin(), values.end(), '-'), values.end());
                    rowVector.push_back(std::stoi(values));
                }
                else{
                    rowVector.push_back(std::stoi(values));
                }
            }
            count++;
        }
        lineitemData.push_back(rowVector);
        rowVector.clear();
    }

    std::vector<std::vector<int>> transposedVec(lineitemData[0].size(),
                                    std::vector<int>(lineitemData.size()));
    for (size_t i = 0; i < lineitemData.size(); ++i)
        for (size_t j = 0; j < lineitemData[0].size(); ++j)
            transposedVec[j][i] = lineitemData[i][j];

    thrust::host_vector<std::vector<int>> H(transposedVec);

    std::cout << "H has size " << H.size() << std::endl;
    std::cout << "H has size " << H[0].size() << std::endl;

    thrust::device_vector<int> D0 = H[8];
    std::cout << "D has size before filtering " << D0.size() << std::endl;

    // Remove_If operation from thrust on device vector
/*    D0.erase(thrust::remove_if(D0.begin(), D0.end(), [=] __device__(const int x){
        return !(x >= 19940101 and x < 19950101);
    }), D0.end());*/

/* does not work this way for cuda 8, this style preferred till cuda 7.5
 * struct test_functor
    {
        __host__ __device__
        bool operator()(const int x){
            return !(x >= 19940101 and x < 19950101);
        }
    };*/

    thrust::device_vector<int> device_result(D0.size());
    auto result_end = thrust::copy_if(D0.begin(), D0.end(), device_result.begin(), [=] __device__(const int x) {
        return (x >= 19940101 and x < 19950101);
    });

    thrust::host_vector<int> host_result(device_result.begin(), result_end);
    std::cout << "result: " << host_result.size() << std::endl;

/* complete implementation of find_if -> returns the first element found with criteria
 * thrust::device_vector<int>::iterator iter;
    iter = thrust::find_if(thrust::device, D0.begin(), D0.end(), [=] __device__(const int x) {
        return !(x >= 19940101 and x < 19950101);
    });*/
    return 0;
}




/*
#include <arrayfire.h>
#include <af/array.h>

void testBackend()
{
    af::info();
    af_print(af::randu(5, 4));
}

int main()
{
    */
/*try {
        printf("Trying CPU Backend\n");
        af::setBackend(AF_BACKEND_CPU);
        testBackend();
    } catch (af::exception& e) {
//        printf("Caught exception when trying CPU backend\n");
        fprintf(stderr, "%s\n", e.what());
    }

    try {
        printf("Trying CUDA Backend\n");
        af::setBackend(AF_BACKEND_CUDA);
        testBackend();
    } catch (af::exception& e) {
        printf("Caught exception when trying CUDA backend\n");
        fprintf(stderr, "%s\n", e.what());
    }

    try {
        printf("Trying OpenCL Backend\n");
        af::setBackend(AF_BACKEND_OPENCL);
        testBackend();
    } catch (af::exception& e) {
        printf("Caught exception when trying OpenCL backend\n");
        fprintf(stderr, "%s\n", e.what());
    }*//*


    // Create an array on the host, copy it into an ArrayFire 2x3 ArrayFire
    // array
    float host_ptr[] = {0, 1, 2, 3, 4, 5};
    af::array a(2, 3, host_ptr);

    // Create a CUDA device pointer, populate it with data from the host
    float *device_ptr;
    cudaMalloc((void **)&device_ptr, 6 * sizeof(float));
    cudaMemcpy(device_ptr, host_ptr, 6 * sizeof(float), cudaMemcpyHostToDevice);

    // Convert the CUDA-allocated device memory into an ArrayFire array:
    af::array b(2, 3, device_ptr, afDevice);  // Note: afDevice (default: afHost)
    // Note that ArrayFire takes ownership over `device_ptr`, so memory will
    // be freed when `b` id destructed. Do not call cudaFree(device_ptr)!

    return 0;
}*/
