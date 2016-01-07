//
//  HYUserDefaults.h
//  RuntimeUserDefault
//
//  Created by ND on 16/1/7.
//  Copyright © 2016年 LJH. All rights reserved.
//

#import "NAUserDefaults.h"

@interface HYUserDefaults : NAUserDefaults

@property (retain,nonatomic) NSString *testString;

+ (HYUserDefaults *)shareInstance;

@end
