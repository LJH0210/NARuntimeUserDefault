//
//  NAUserDefaults.h
//  RuntimeUserDefault
//
//  Created by ND on 16/1/7.
//  Copyright © 2016年 LJH. All rights reserved.
//

#import <Foundation/Foundation.h>

#define BaseUserDefaultsKeyWord @"_NoDuplication"

@interface NAUserDefaults : NSObject

/** key - property name
 *  NSString  (nil - remove , return nil)
 *  bool BOOL Boolean (nil - false , return flase)
 *  id (nil - remove , return nil)
 *  int (nil - 0)
 *
 *  （NSInteger、float、double），NSString，NSDate，NSArray，NSDictionary，BOOL.
 *  except : NSNumber NSValue and NSValue childclass
 */

-(void)reset;

@end
