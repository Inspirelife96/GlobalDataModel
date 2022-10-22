//
//  INSBlock.m
//  INSParse
//
//  Created by XueFeng Chen on 2021/9/7.
//

#import "INSBlock.h"

#import <Parse/PFObject+Subclass.h>

#import "INSParseDefines.h"

@implementation INSBlock

@dynamic fromUser;
@dynamic toUser;

+ (NSString *)parseClassName {
    return INSBlockKeyClass;
}

@end
