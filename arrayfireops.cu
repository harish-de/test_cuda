//
// Created by harish on 30.07.20.
//

#include <vector>
#include <af/array.h>
#include <arrayfire.h>
#include <af/algorithm.h>

void filter_arrayfire(std::vector<int> columndata){

    int* hostColumnDataToBeFiltered = &columndata[0];

    // copy host data to device
    af::array deviceColumnDataToBeFiltered((dim_t)columndata.size(), hostColumnDataToBeFiltered); // columndata.size() = number of tuples

//    af::array result = af::operator>>(deviceDate, 19940101);
    af::array index = af::where(af::operator>(deviceColumnDataToBeFiltered, 19940101)); // operator (in method definition)
                                                                // and value (in parameter 'rhs') is specified
    af::print("result", index);
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

void and_arryfire(std::vector<int> lhs, std::vector<int> rhs){

    int* hostLHS = &lhs[0];
    int* hostRHS = &rhs[0];

    // copy host data to device
    af::array deviceLHS((dim_t)lhs.size(),hostLHS);
    af::array deviceRHS((dim_t)rhs.size(),hostRHS);
    af::array result((dim_t)lhs.size());

    result = af::operator&(deviceLHS,deviceRHS);

    af::print("logicalAND", result);
}

void join_arrayfire(std::vector<int> lhs, std::vector<int> rhs){

    int* hostLHS = &lhs[0];
    int* hostRHS = &rhs[0];

    // copy host data to device
    af::array deviceLHS((dim_t)lhs.size(),hostLHS);
    af::array deviceRHS((dim_t)rhs.size(),hostRHS);

    af::array joinResult = af::setIntersect(deviceLHS,deviceRHS);

    af::print("join", joinResult);
}
