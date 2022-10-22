//
//  INSFollow.m
//  INSParse
//
//  Created by XueFeng Chen on 2021/6/22.
//

#import "INSFollow.h"

#import <Parse/PFObject+Subclass.h>

#import "INSParseDefines.h"

@implementation INSFollow

@dynamic fromUser;
@dynamic toUser;
@dynamic isDeleted;

+ (NSString *)parseClassName {
    return INSFollowKeyClass;
}

@end
