////
//// Created by harish on 17.07.20.
////
//
//// Begin of Thrust libraries
//#include <thrust/host_vector.h>
//#include <thrust/device_vector.h>
//#include <thrust/remove.h>
//#include <thrust/copy.h>
//#include <thrust/execution_policy.h>
//#include <thrust/find.h>
//// End of Thrust libraries
//
#include <chrono>
using namespace std::chrono;
//
//// Begin of Arrayfire libraries
//#include <arrayfire.h>
//#include <af/array.h>
//// End of Arrayfire libraries
//
////#include <cudf.h> //installed using command "sudo apt-get install libcudf-dev"
//
//// Begin of STL libraries
#include <iostream>
#include <fstream>
#include <sstream>
#include<algorithm>
#include <array>

//// End of STL libraries
//
//#include "arrayfireops.h"
//
//***************************************************************************************************//
//*************** READ TABLE DATA FROM .TBL FILES ***************************************************//
//***************************************************************************************************//
std::vector<std::vector<int>> getLineItemData() {
    std::string filename = "/home/harish/Documents/lineitem/lineitem.tbl";

    std::vector<std::vector<int>> lineitemData;

    std::vector<int> rowVector;

    std::ifstream lineitemFile(filename);

/*    if(!lineitemFile.is_open())
        throw std::runtime_error("could not open file");*/

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
    return lineitemData;
}

//***************************************************************************************************//
//*************** TRANSPOSE TABLE DATA FOR COLUMN FORMAT TO LOAD INTO DEVICE ************************//
//***************************************************************************************************//
std::vector<std::vector<int>> getTransposedVector(const std::vector<std::vector<int>> &lineitemData) {
    std::vector<std::vector<int>> transposedVec(lineitemData[0].size(),
                                                std::vector<int>(lineitemData.size()));
    for (size_t i = 0; i < lineitemData.size(); ++i)
        for (size_t j = 0; j < lineitemData[0].size(); ++j)
            transposedVec[j][i] = lineitemData[i][j];
    return transposedVec;
}
//
////***************************************************************************************************//
////*************** ARRAYFIRE - HOW TO SET DIFFERENT BACKENDS *****************************************//
////***************************************************************************************************//
//
//void testBackend()
//{
//    af::info();
//    af_print(af::randu(5, 4));
//}
//
//void testArrayFire()
//{
//    try {
//        printf("Trying CPU Backend\n");
//        af::setBackend(AF_BACKEND_CPU);
//        testBackend();
//    } catch (af::exception& e) {
//        printf("Caught exception when trying CPU backend\n");
//        fprintf(stderr, "%s\n", e.what());
//    }
//
//    try {
//        printf("Trying CUDA Backend\n");
//        af::setBackend(AF_BACKEND_CUDA);
//        testBackend();
//    } catch (af::exception& e) {
//        printf("Caught exception when trying CUDA backend\n");
//        fprintf(stderr, "%s\n", e.what());
//    }
//
//    try {
//        printf("Trying OpenCL Backend\n");
//        af::setBackend(AF_BACKEND_OPENCL);
//        testBackend();
//    } catch (af::exception& e) {
//        printf("Caught exception when trying OpenCL backend\n");
//        fprintf(stderr, "%s\n", e.what());
//    }
//
//
//    // Create an array on the host, copy it into an ArrayFire 2x3 ArrayFire
//    // array
//    float host_ptr[] = {0, 1, 2, 3, 4, 5};
//    af::array a(2, 3, host_ptr);
//
//    // Create a CUDA device pointer, populate it with data from the host
//    float *device_ptr;
//    cudaMalloc((void **)&device_ptr, 6 * sizeof(float));
//    cudaMemcpy(device_ptr, host_ptr, 6 * sizeof(float), cudaMemcpyHostToDevice);
//
//    // Convert the CUDA-allocated device memory into an ArrayFire array:
//    af::array b(2, 3, device_ptr, afDevice);  // Note: afDevice (default: afHost)
//    // Note that ArrayFire takes ownership over `device_ptr`, so memory will
//    // be freed when `b` id destructed. Do not call cudaFree(device_ptr)!
//}
//
////***************************************************************************************************//
////*************** THRUST - FILTER OPERATION *********************************************************//
////***************************************************************************************************//
//
//void filter_thrust() {// this following check confirmed addition of --expt-extended-lambda in CmakeLists.txt
//// is necessary to executed lambda functions
//#ifndef __CUDACC_EXTENDED_LAMBDA__
//    std::cout << "compile with extended lambdas " << std::endl;
//#endif
//
//    // get the table content as 2D vector
//    std::vector<std::vector<int>> lineitemData;
//    lineitemData = getLineItemData();
//
//    // transpose the table data to read in column format
//    std::vector<std::vector<int>> transposedVec = getTransposedVector(lineitemData);
//
//    // the table data in column format is host vector H
//    thrust::host_vector<std::vector<int>> H(transposedVec);
//
//    std::cout << "H has size " << H.size() << std::endl;
//    std::cout << "H has size " << H[0].size() << std::endl;
//
//    // the predicate column data is transferred/copied to the device vector
//    thrust::device_vector<int> D0 = H[8];
//    std::cout << "D has size before filtering " << D0.size() << std::endl;
//
//    // Remove_If operation from thrust on device vector
///*    D0.erase(thrust::remove_if(D0.begin(), D0.end(), [=] __device__(const int x){
//        return !(x >= 19940101 and x < 19950101);
//    }), D0.end());*/
//
//
//    //does not work this way for cuda 8, this style preferred till cuda 7.5
///*    struct test_functor
//    {
//        __host__ __device__
//        bool operator()(const int x){
//            return !(x >= 19940101 and x < 19950101);
//        }
//    };*/
//
//
//    // perform the filter operation and store result in another device vector
//    thrust::device_vector<int> device_result(D0.size());
//    auto result_end = thrust::copy_if(D0.begin(), D0.end(), device_result.begin(), [=] __device__(const int x) {
//        return (x >= 19940101 and x < 19950101);
//    });
//
//
//    // transfer the result back to host memory
//    thrust::host_vector<int> host_result(device_result.begin(), result_end);
//    std::cout << "result: " << host_result.size() << std::endl;
//
//    // complete implementation of find_if -> returns the first element found with criteria
///*    thrust::device_vector<int>::iterator iter;
//    iter = thrust::find_if(thrust::device, D0.begin(), D0.end(), [=] __device__(const int x) {
//        return !(x >= 19940101 and x < 19950101);
//    });*/}
//
////***************************************************************************************************//
////******************************* MAIN FUNCTION *****************************************************//
////***************************************************************************************************//
//
//int main(void)
//{
////    get the table content as 2D vector
//    std::vector<std::vector<int>> lineitemData;
//    lineitemData = getLineItemData();
//
//    // transpose the table data to read in column format
//    std::vector<std::vector<int>> transposedVec = getTransposedVector(lineitemData);
//
//    // send the column data necessary for the query - this hardcoding will be replaced by parser
//    std::vector<int> column_shipdate = transposedVec[8];
//    std::vector<int> column_discount = transposedVec[6];
//    std::vector<int> column_quantity = transposedVec[4];
//
//    af::array result1,result2,result3,result4,result5;
//    af::array temp;
//
//    auto start = high_resolution_clock::now();
//
//    result1 = filter_arrayfire(column_shipdate,"GE",19940101);
//    // write a buffer logic to check if the column data is already in device memory
//    // the logic could be to hold 'n' column data slots in map at a time
//    // or calculate the size of column data using sizeof(vec) and extend the map such that it is lesser than device memory
//    // when one of the case invalidates, evict the column data
//    result2 = filter_arrayfire(column_shipdate,"LE",19950101);
//    result3 = filter_arrayfire(column_discount,"GE",5);
//    result4 = filter_arrayfire(column_discount,"LE",7);
//    result5 = filter_arrayfire(column_quantity,"LT",24);
//
//    auto stop = high_resolution_clock::now();
//    auto duration = duration_cast<microseconds>(stop - start);
//
//    std::cout << "time taken for all predicates: " <<duration.count() << " microseconds" << std::endl;
//
//    start = high_resolution_clock::now();
//    temp = join_arrayfire(result1,result2);
//    temp = join_arrayfire(temp,result3);
//    temp = join_arrayfire(temp,result4);
//    temp = join_arrayfire(temp,result5);
//    stop = high_resolution_clock::now();
//    duration = duration_cast<microseconds>(stop - start);
//
//    std::cout << "time taken for all predicate conjunctions: " <<duration.count() << " microseconds" << std::endl;
//
////    af::print("result", temp);
//
//    return 0;
//}
//

#include "type_conversion/host_to_device.h"
#include "predicate/predicate.h"

int main(void) {

    //get the table content as 2D vector
    std::vector<std::vector<int>> lineitemData;
    lineitemData = getLineItemData();

    // transpose the table data to read in column format
    std::vector<std::vector<int>> transposedVec = getTransposedVector(lineitemData);

    std::vector<int> columnData = transposedVec[8];
    std::vector<int> durations_thr;
    for (int i = 0; i <= 5; i++) {
        auto start_thr = high_resolution_clock::now();
        thrust::device_vector<int> thrust_device_data = getThrustDeviceVector(columnData);
        auto stop_thr = high_resolution_clock::now();
        auto duration_thr = duration_cast<microseconds>(stop_thr - start_thr);
        durations_thr.push_back(duration_thr.count());
    }
    std::cout << "transfer time - Thrust: " << std::accumulate(durations_thr.begin(),
                                                               durations_thr.end(), 0) / durations_thr.size()
              << " microseconds" << std::endl;

    std::vector<int> durations_af;

    for (int i = 0; i <= 5; i++) {
        auto start_af = high_resolution_clock::now();
        af::array af_device_data = getAFDeviceVector(columnData);
        auto stop_af = high_resolution_clock::now();
        auto duration_af = duration_cast<microseconds>(stop_af - start_af);
        durations_af.push_back(duration_af.count());
    }
    std::cout << "transfer time - AF: " << std::accumulate(durations_af.begin(),
                                                           durations_af.end(), 0) / durations_af.size()
              << " microseconds" << std::endl;


    thrust::device_vector<int> thrust_device_data = getThrustDeviceVector(columnData);

    auto start_pred_thr = high_resolution_clock::now();
    predicate_thrust(thrust_device_data,19940101,"GE");
    auto stop_pred_thr = high_resolution_clock::now();
    auto duration_predthr = duration_cast<microseconds>(stop_pred_thr - start_pred_thr);
    std::cout << "Predicate - Thrust: " << duration_predthr.count()
              << " microseconds" << std::endl;

    af::array af_device_data = getAFDeviceVector(columnData);

    auto start_pred_af = high_resolution_clock::now();
    predicate_arrayfire(af_device_data,19940101,"GE");
    auto stop_pred_af = high_resolution_clock::now();
    auto duration_predAF = duration_cast<microseconds>(stop_pred_af - start_pred_af);
    std::cout << "Predicate - AF: " << duration_predAF.count()
              << " microseconds" << std::endl;

    return 0;
}
