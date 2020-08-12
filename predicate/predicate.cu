//
// Created by harish on 10.08.20.
//
#include <vector>

#include <af/array.h>
#include <arrayfire.h>
#include <af/algorithm.h>


#include <thrust/device_vector.h>
#include <thrust/copy.h>

#include <chrono>
using namespace std::chrono;

af::array predicate_arrayfire(af::array columndata,int value, std::string op){
    /*
     * returns the index of tuples matching the given criteria,
     * if..else is used instead of switch as switch is not supported in cuda programs
     */
    af::array indexOut;

//    if (op == "GE"){
//        indexOut = af::where(af::operator>=(columndata, value));
//    }else if(op == "LE"){
//        indexOut = af::where(af::operator<=(columndata, value));
//    }else if(op == "LT"){
//        indexOut = af::where(af::operator<(columndata, value));
//    }
//    else if(op == "GT"){
//        indexOut = af::where(af::operator>(columndata, value));
//    }
//    else if(op == "EQ"){
//        indexOut = af::where(af::operator==(columndata, value));
//    }
//    else {
//        indexOut = af::where(af::operator!=(columndata, value));
//    }
    indexOut = af::where(af::operator>=(columndata,19940101));
    return indexOut;
}

thrust::device_vector<int> predicate_thrust(thrust::device_vector<int> deviceData, int value, std::string op){
    thrust::device_vector<int> device_result(deviceData.size());
//    auto result_end = thrust::copy_if(deviceData.begin(), deviceData.end(), device_result.begin(), [=] __device__(const int x) {
//        return (x >= 19940101 and x < 19950101);
//    });
    auto result_end = thrust::copy_if(deviceData.begin(), deviceData.end(), device_result.begin(), [=] __device__(const int x) {
        return (x >= 19940101);
    });
    thrust::device_vector<int> result(device_result.begin(), result_end);
    return result;
}
