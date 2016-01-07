//
//  HYUserDefaults.m
//  RuntimeUserDefault
//
//  Created by ND on 16/1/7.
//  Copyright © 2016年 LJH. All rights reserved.
//

#import "HYUserDefaults.h"

static HYUserDefaults *instance;

@implementation HYUserDefaults

+ (HYUserDefaults *)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [HYUserDefaults new];
    });
    return instance;
}

@end
