//
// Created by harish on 30.07.20.
//

#include <vector>
#include <af/array.h>
#include <arrayfire.h>
#include <af/algorithm.h>

#include <chrono>
using namespace std::chrono;

af::array filter_arrayfire(std::vector<int> columndata,std::string op,int value){

    int* hostColumnDataToBeFiltered = &columndata[0];

    // copy host data to device
    auto start = high_resolution_clock::now();
    af::array deviceColumnDataToBeFiltered((dim_t)columndata.size(), hostColumnDataToBeFiltered); // columndata.size() = number of tuples
    auto stop = high_resolution_clock::now();
    auto duration = duration_cast<microseconds>(stop - start);

    std::cout << "Time taken for tranfer of data: "
         << duration.count() << " microseconds" << std::endl;

    af::array indexOut;
//    af::print("data", deviceColumnDataToBeFiltered);
//    af::array result = af::operator>>(deviceDate, 19940101);
    if (op == "GE"){
        indexOut = af::where(af::operator>=(deviceColumnDataToBeFiltered, value));
    }else if(op == "LE"){
        indexOut = af::where(af::operator<=(deviceColumnDataToBeFiltered, value));
    }else if(op == "LT"){
        indexOut = af::where(af::operator<(deviceColumnDataToBeFiltered, value));
    }
    else if(op == "GT"){
        indexOut = af::where(af::operator>(deviceColumnDataToBeFiltered, value));
    }
    else if(op == "EQ"){
        indexOut = af::where(af::operator==(deviceColumnDataToBeFiltered, value));
    }
    else {
        indexOut = af::where(af::operator!=(deviceColumnDataToBeFiltered, value));
    }
//    af::print("result", indexOut);
    return indexOut;

}

void sort_arrayfire(std::vector<int> columndata){

    int* hostColumnDataToBeFiltered = &columndata[0];

    // copy host data to device
    af::array deviceColumnDataToBeSorted((dim_t)columndata.size(), hostColumnDataToBeFiltered);

    //result container
    af::array deviceSortedOutputData((dim_t)columndata.size());

    //checking the unsortedness in data before sort() operation
    //    af::print("unsorted_data",deviceColumnDataToBeSorted);

    // sort the data, default paramters: dim=0 and isAscending=true
    deviceSortedOutputData = af::sort(deviceColumnDataToBeSorted);

    af::print("sorted_data",deviceSortedOutputData);
}

af::array and_arrayfire(std::vector<int> lhs, std::vector<int> rhs){

    int* hostLHS = &lhs[0];
    int* hostRHS = &rhs[0];

    // copy host data to device
    af::array deviceLHS((dim_t)lhs.size(),hostLHS);
    af::array deviceRHS((dim_t)rhs.size(),hostRHS);
    af::array result((dim_t)lhs.size());

    result = af::operator&(deviceLHS,deviceRHS);
    return result;
//    af::print("logicalAND", result);
}

af::array and_arrayfire(af::array lhs, af::array rhs){
    return af::operator&(lhs,rhs);
}

af::array join_arrayfire(std::vector<int> lhs, std::vector<int> rhs){

    int* hostLHS = &lhs[0];
    int* hostRHS = &rhs[0];

    // copy host data to device
    af::array deviceLHS((dim_t)lhs.size(),hostLHS);
    af::array deviceRHS((dim_t)rhs.size(),hostRHS);

    af::array joinResult = af::setIntersect(deviceLHS,deviceRHS);

    af::print("join", joinResult);
    return joinResult;
}

af::array join_arrayfire(af::array lhs, af::array rhs){
    af::array joinResult = af::setIntersect(lhs,rhs);
//    af::print("join", joinResult);
    return joinResult;
}

void multVec_arrayfire(std::vector<int> lhs, std::vector<int> rhs){
    int* hostLHS = &lhs[0];
    int* hostRHS = &rhs[0];

    // copy host data to device
    af::array deviceLHS((dim_t)lhs.size(),hostLHS);
    af::array deviceRHS((dim_t)rhs.size(),hostRHS);
    af::array result((dim_t)lhs.size());

    result = af::operator*(deviceLHS,deviceRHS);

    af::print("multVec", result);
}

void sumaggreg_groupby_arrayfire(std::vector<int> keyCol, std::vector<int> valCol){
    int* keys = &keyCol[0];
    int* vals = &valCol[0];

    //copy host to device
    af::array deviceKeys((dim_t)keyCol.size(), keys);
    af::array deviceColumnValues((dim_t)valCol.size(),vals);

    //sumByKey arrayfire function here cannot be implemented
    //this function is valid from version 3.7 (this version needs cuda 10.*)
    // but ours is version 3.5 with cuda 8.0, so implement the same alternatively

}
