//
// Created by harish on 10.08.20.
//

#ifndef TEST_CUDA_PREDICATE_H
#define TEST_CUDA_PREDICATE_H

#endif //TEST_CUDA_PREDICATE_H

#include <arrayfire.h>
#include <thrust/copy.h>
#include <thrust/host_vector.h>
#include <thrust/device_vector.h>

/*
 * ARRAY FIRE
 */
af::array predicate_arrayfire(af::array deviceData, int value,std::string op);

/*
 * THRUST - support conjunctive or disjunctive predicates as well using copy_if function
 * here let's define for a single predicate condition
 */
thrust::device_vector<int> predicate_thrust(thrust::device_vector<int> deviceData, int value, std::string op);
