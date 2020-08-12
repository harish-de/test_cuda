//
// Created by harish on 30.07.20.
//

#ifndef TEST_CUDA_ARRAYFIREOPS_H
#define TEST_CUDA_ARRAYFIREOPS_H

#endif //TEST_CUDA_ARRAYFIREOPS_H

#include <af/array.h>

af::array filter_arrayfire(std::vector<int> columndata,std::string op,int value);
void sort_arrayfire(std::vector<int> columndata);
af::array and_arrayfire(std::vector<int> lhs, std::vector<int> rhs); // lhs and rhs as 1/0 values
af::array and_arrayfire(af::array lhs, af::array rhs);
af::array join_arrayfire(std::vector<int> lhs, std::vector<int> rhs);
af::array join_arrayfire(af::array lhs, af::array rhs);
void multVec_arrayfire(std::vector<int> lhs, std::vector<int> rhs);
