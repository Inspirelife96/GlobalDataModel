//
//  INSShare.m
//  INSParse
//
//  Created by XueFeng Chen on 2021/6/22.
//

#import "INSShare.h"

#import <Parse/PFObject+Subclass.h>

#import "INSParseDefines.h"

@implementation INSShare

@dynamic topic;
@dynamic fromUser;
@dynamic toPlatform;

+ (NSString *)parseClassName {
    return INSShareKeyClass;
}

@end
