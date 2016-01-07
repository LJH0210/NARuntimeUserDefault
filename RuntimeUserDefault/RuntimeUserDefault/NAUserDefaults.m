//
//  NAUserDefaults.m
//  RuntimeUserDefault
//
//  Created by ND on 16/1/7.
//  Copyright © 2016年 LJH. All rights reserved.
//

#import "NAUserDefaults.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation NAUserDefaults

-(void)reset
{
    unsigned int numIvars = 0;
    Ivar * ivars = class_copyIvarList([self class], &numIvars);
    for (int i = 0; i < numIvars ; i++)
    {
        const char* propertyName = ivar_getName(ivars[i]);
        NSString *getName = [[[NSString stringWithCString:propertyName encoding:NSUTF8StringEncoding] stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@""] stringByAppendingFormat:@"_%s",object_getClassName(self)];
        if ([getName rangeOfString:BaseUserDefaultsKeyWord].location == NSNotFound)
        {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:getName];
        }
    }
    
}

-(NSString *)debugDescription{
    NSString *retString = @"";
    unsigned int numIvars = 0;
    Ivar * ivars = class_copyIvarList([self class], &numIvars);
    for (int i = 0; i < numIvars ; i++)
    {
        const char* propertyName = ivar_getName(ivars[i]);
        NSString *getName = [[[NSString stringWithCString:propertyName encoding:NSUTF8StringEncoding] stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@""] stringByAppendingFormat:@"_%s",object_getClassName(self)];
        
        retString = [retString stringByAppendingString:getName];
        retString = [retString stringByAppendingFormat:@" : %@ \n",[[NSUserDefaults standardUserDefaults] objectForKey:getName]];
        
    }
    return  retString;
}


-(id)init
{
    if (self == [super init]) {
        unsigned int numIvars = 0;
        Ivar * ivars = class_copyIvarList([self class], &numIvars);
        for (int i = 0; i < numIvars ; i++)
        {
            const char* propertyName = ivar_getName(ivars[i]);
            NSString *getName = [[NSString stringWithCString:propertyName encoding:NSUTF8StringEncoding] stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@""];
            if ([getName rangeOfString:BaseUserDefaultsKeyWord].location == NSNotFound)
            {
                char firstChar = propertyName[1];
                if (firstChar >= 'a' && firstChar <= 'z') {
                    firstChar-=32;
                }
                NSString *setNameMethod = [[@"set" stringByAppendingString:[getName stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[NSString stringWithFormat:@"%c",firstChar]]] stringByAppendingString:@":"];
                
                const char* typeEncoding =ivar_getTypeEncoding(ivars[i]);
                switch (typeEncoding[0]) {
                        //NSObject
                    case _C_ID:
                    {
                        NSString *st = [NSString stringWithUTF8String:typeEncoding];
                        st = [st stringByReplacingOccurrencesOfString:@"@" withString:@""];
                        st = [st stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                        
                        id thisClass = [[NSClassFromString(st) alloc] init];
                        
                        if ([thisClass isKindOfClass:[NSString class]] || [[NSClassFromString(st) superclass] isKindOfClass:[NSValue class]]
                            ||[thisClass isKindOfClass:[NSArray class]] || [thisClass isKindOfClass:[NSDictionary class]]
                            ||[thisClass isKindOfClass:[NSSet class]] || [thisClass isKindOfClass:[NSError class]]
                            ||[thisClass isKindOfClass:[NSURL class]] ) {
                            //重写get方法
                            class_replaceMethod([self class], NSSelectorFromString(getName), (IMP)customGetMethod, "@@:");
                            //覆盖set方法
                            class_replaceMethod([self class], NSSelectorFromString(setNameMethod), (IMP)customSetMethodWithId, "v@:");
                        }else{
                            //重写get方法
                            class_replaceMethod([self class], NSSelectorFromString(getName), (IMP)customGetMethodWithUnarchiver, "@@:");
                            //覆盖set方法
                            class_replaceMethod([self class], NSSelectorFromString(setNameMethod), (IMP)customSetMethodWithIdArchiver, "v@:");
                        }
                    }
                        break;
                    case _C_INT:
                        //重写get方法
                        class_replaceMethod([self class], NSSelectorFromString(getName), (IMP)customGetMethodWithInt, "i@:");
                        //覆盖set方法
                        class_replaceMethod([self class], NSSelectorFromString(setNameMethod), (IMP)customSetMethodWithInt, "v@:");
                        break;
                    case _C_UINT:
                        //重写get方法
                        class_replaceMethod([self class], NSSelectorFromString(getName), (IMP)customGetMethodWithUInt, "ui@:");
                        //覆盖set方法
                        class_replaceMethod([self class], NSSelectorFromString(setNameMethod), (IMP)customSetMethodWithUInt, "v@:");
                        break;
                    case _C_LNG:
                        //重写get方法
                        class_replaceMethod([self class], NSSelectorFromString(getName), (IMP)customGetMethodWithLong, "l@:");
                        //覆盖set方法
                        class_replaceMethod([self class], NSSelectorFromString(setNameMethod), (IMP)customSetMethodWithLong, "v@:");
                        break;
                    case _C_ULNG:
                        //重写get方法
                        class_replaceMethod([self class], NSSelectorFromString(getName), (IMP)customGetMethodWithULong, "ul@:");
                        //覆盖set方法
                        class_replaceMethod([self class], NSSelectorFromString(setNameMethod), (IMP)customSetMethodWithULong, "v@:");
                        break;
                    case _C_LNG_LNG:
                        //重写get方法
                        class_replaceMethod([self class], NSSelectorFromString(getName), (IMP)customGetMethodWithLLong, "ll@:");
                        //覆盖set方法
                        class_replaceMethod([self class], NSSelectorFromString(setNameMethod), (IMP)customSetMethodWithLLong, "v@:");
                        break;
                    case _C_ULNG_LNG:
                        //重写get方法
                        class_replaceMethod([self class], NSSelectorFromString(getName), (IMP)customGetMethodWithULLong, "ull@:");
                        //覆盖set方法
                        class_replaceMethod([self class], NSSelectorFromString(setNameMethod), (IMP)customSetMethodWithULLong, "v@:");
                        break;
                    case _C_FLT:
                        //重写get方法
                        class_replaceMethod([self class], NSSelectorFromString(getName), (IMP)customGetMethodWithFloat, "f@:");
                        //覆盖set方法
                        class_replaceMethod([self class], NSSelectorFromString(setNameMethod), (IMP)customSetMethodWithFloat, "v@:");
                        break;
                    case _C_BOOL:
                        //重写get方法
                        class_replaceMethod([self class], NSSelectorFromString(getName), (IMP)customGetMethodWithBool, "b@:");
                        //覆盖set方法
                        class_replaceMethod([self class], NSSelectorFromString(setNameMethod), (IMP)customSetMethodWithBool, "v@:");
                        break;
                    case _C_DBL:
                        //重写get方法
                        class_replaceMethod([self class], NSSelectorFromString(getName), (IMP)customGetMethodWithDouble, "d@:");
                        //覆盖set方法
                        class_replaceMethod([self class], NSSelectorFromString(setNameMethod), (IMP)customSetMethodWithDouble, "v@:");
                        break;
                    default:
                        break;
                }
            }
        }
    }
    return self;
}

#pragma mark -
#pragma mark - check ivar property - 检查属性和类变量


#pragma mark -
#pragma mark bool 覆盖方法
void customSetMethodWithBool(id self,SEL _cmd,bool st)
{
    [[NSUserDefaults standardUserDefaults] setBool:st forKey:[self getThisClassPropertyNameBySelect:_cmd class:self]];
}

bool customGetMethodWithBool(id self,SEL _cmd)
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:[NSStringFromSelector(_cmd) stringByAppendingFormat:@"_%s",object_getClassName(self)]] boolValue];
}

#pragma mark -
#pragma mark float 覆盖方法
void customSetMethodWithDouble(id self,SEL _cmd,double st)
{
    [self setUserDefaultsObject:[NSNumber numberWithDouble:st] forKey:[self getThisClassPropertyNameBySelect:_cmd class:self]];
}

float customGetMethodWithDouble(id self,SEL _cmd)
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:[NSStringFromSelector(_cmd) stringByAppendingFormat:@"_%s",object_getClassName(self)]] doubleValue];
}

#pragma mark -
#pragma mark float 覆盖方法
void customSetMethodWithFloat(id self,SEL _cmd,float st)
{
    [self setUserDefaultsObject:[NSNumber numberWithFloat:st] forKey:[self getThisClassPropertyNameBySelect:_cmd class:self]];
}

float customGetMethodWithFloat(id self,SEL _cmd)
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:[NSStringFromSelector(_cmd) stringByAppendingFormat:@"_%s",object_getClassName(self)]] floatValue];
}

#pragma mark -
#pragma mark long long 覆盖方法
void customSetMethodWithLLong(id self,SEL _cmd,long long st)
{
    [self setUserDefaultsObject:[NSNumber numberWithLongLong:st] forKey:[self getThisClassPropertyNameBySelect:_cmd class:self]];
}

long long customGetMethodWithLLong(id self,SEL _cmd)
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:[NSStringFromSelector(_cmd) stringByAppendingFormat:@"_%s",object_getClassName(self)]] longLongValue];
}

#pragma mark -
#pragma mark unsigned long  long 覆盖方法
void customSetMethodWithULLong(id self,SEL _cmd,unsigned long long st)
{
    [self setUserDefaultsObject:[NSNumber numberWithUnsignedLongLong:st] forKey:[self getThisClassPropertyNameBySelect:_cmd class:self]];
}

unsigned long long customGetMethodWithULLong(id self,SEL _cmd)
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:[[NSStringFromSelector(_cmd) stringByAppendingFormat:@"_%s",object_getClassName(self)] stringByAppendingFormat:@"_%s",object_getClassName(self)]] unsignedLongLongValue];
}

#pragma mark -
#pragma mark unsigned long 覆盖方法
void customSetMethodWithULong(id self,SEL _cmd,unsigned long st)
{
    [self setUserDefaultsObject:[NSNumber numberWithUnsignedLong:st] forKey:[self getThisClassPropertyNameBySelect:_cmd class:self]];
}

unsigned long customGetMethodWithULong(id self,SEL _cmd)
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:[NSStringFromSelector(_cmd) stringByAppendingFormat:@"_%s",object_getClassName(self)]] unsignedLongValue];
}

#pragma mark -
#pragma mark long 覆盖方法
void customSetMethodWithLong(id self,SEL _cmd,long st)
{
    [self setUserDefaultsObject:[NSNumber numberWithLong:st] forKey:[self getThisClassPropertyNameBySelect:_cmd class:self]];
}

long customGetMethodWithLong(id self,SEL _cmd)
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:[NSStringFromSelector(_cmd) stringByAppendingFormat:@"_%s",object_getClassName(self)]] longValue];
}

#pragma mark -
#pragma mark unsigned int 覆盖方法
void customSetMethodWithUInt(id self,SEL _cmd,unsigned int st)
{
    [self setUserDefaultsObject:[NSNumber numberWithUnsignedInteger:st] forKey:[self getThisClassPropertyNameBySelect:_cmd class:self]];
}

unsigned int customGetMethodWithUInt(id self,SEL _cmd)
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:[NSStringFromSelector(_cmd) stringByAppendingFormat:@"_%s",object_getClassName(self)]] unsignedIntValue];
}

#pragma mark -
#pragma mark int 覆盖方法
void customSetMethodWithInt(id self,SEL _cmd,int st)
{
    [self setUserDefaultsObject:[NSNumber numberWithInt:st] forKey:[self getThisClassPropertyNameBySelect:_cmd class:self]];
}

int customGetMethodWithInt(id self,SEL _cmd)
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:[NSStringFromSelector(_cmd) stringByAppendingFormat:@"_%s",object_getClassName(self)]] intValue];
}


#pragma mark -
#pragma mark Object-C类覆盖方法
void customSetMethodWithId(id self,SEL _cmd,id st)
{
    [self setUserDefaultsObject:st forKey:[self getThisClassPropertyNameBySelect:_cmd class:self]];
}

id customGetMethod(id self,SEL _cmd)
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:[NSStringFromSelector(_cmd) stringByAppendingFormat:@"_%s",object_getClassName(self)]];
}

#pragma mark -
#pragma mark Object-C类覆盖方法-序列化
void customSetMethodWithIdArchiver(id self,SEL _cmd,id st)
{
    [self setUserDefaultsObject:[NSKeyedArchiver archivedDataWithRootObject:st] forKey:[self getThisClassPropertyNameBySelect:_cmd class:self]];
}

id customGetMethodWithUnarchiver(id self,SEL _cmd)
{
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:[NSStringFromSelector(_cmd) stringByAppendingFormat:@"_%s",object_getClassName(self)]];
    if (data == nil) return nil;
    id retObj = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return retObj;
    //    return [[NSUserDefaults standardUserDefaults] objectForKey:[NSStringFromSelector(_cmd) stringByAppendingFormat:@"_%s",object_getClassName(self)]];
}


#pragma mark 抽取工具类

-(void)setUserDefaultsObject:(id)obj forKey:(NSString *)aKey
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    obj ? [userDefaults setObject:obj forKey:aKey] : [userDefaults removeObjectForKey:aKey];
    //    if (obj && ![obj isKindOfClass:[NSString class]]) {
    //        NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:obj];
    //        [userDefaults setObject:myEncodedObject forKey:aKey];
    //    }else{
    //        [userDefaults removeObjectForKey:aKey];
    //    }
    [userDefaults synchronize];
}

-(NSString *)getThisClassPropertyNameBySelect:(SEL) cmd class:(id) class
{
    NSString *setName = NSStringFromSelector(cmd);
    setName = [setName stringByReplacingCharactersInRange:NSMakeRange(0, 3) withString:@""];
    const char *setNameChar = [setName UTF8String];
    char firstChar = setNameChar[0];
    if (firstChar >= 'A' && firstChar <= 'Z') {
        firstChar+=32;
    }
    NSString *propertyName = [setName stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[NSString stringWithFormat:@"%c",firstChar]];
    propertyName = [propertyName stringByReplacingOccurrencesOfString:@":" withString:@""];
    propertyName = [propertyName stringByAppendingFormat:@"_%s",object_getClassName(self)];
    return propertyName;
}


@end
