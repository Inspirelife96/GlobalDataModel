//
//  INSNotification.m
//  INSParse
//
//  Created by XueFeng Chen on 2022/5/20.
//

#import "INSNotification.h"

#import <Parse/PFObject+Subclass.h>

#import "INSParseDefines.h"

@implementation INSNotification

@dynamic fromUser;
@dynamic toUser;
@dynamic type;
@dynamic subType;
@dynamic topic;
@dynamic post;
@dynamic reply;
@dynamic messageGroup;

+ (NSString *)parseClassName {
    return INSNotificationKeyClass;
}

@end
