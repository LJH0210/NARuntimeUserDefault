How to Use

1、inherit NAUserDefaults first
.h
#import "NAUserDefaults.h"
@interface HYUserDefaults : NAUserDefaults
@property (retain,nonatomic) NSString *testString;
+ (HYUserDefaults *)shareInstance;
@end

.m
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

2、[HYUserDefaults shareInstance].testString = @"testString" //this can store testString in NSUserDefaults
3、[[HYUserDefaults shareInstance] reset]; //clean all property in HYUserDefaults
