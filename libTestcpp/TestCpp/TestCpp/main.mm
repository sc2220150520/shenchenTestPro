//
//  main.m
//  TestCpp
//
//  Created by shen chen on 2018/6/21.
//  Copyright © 2018年 shenchen. All rights reserved.
//

#include <iostream>
#include <pthread.h>
#include <unistd.h>
using namespace std;
#include "libyy.hpp"
#include "libxx.hpp"

int main(int argc, const char * argv[]) {
    xx a;
    a.fun();
    yy b;
    b.fun();
    return 0;
}
