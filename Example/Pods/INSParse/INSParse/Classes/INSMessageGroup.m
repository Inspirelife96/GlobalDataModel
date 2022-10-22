//
//  INSMessageGroup.m
//  INSParse
//
//  Created by XueFeng Chen on 2022/5/28.
//

#import "INSMessageGroup.h"

#import <Parse/PFObject+Subclass.h>

#import "INSParseDefines.h"

@implementation INSMessageGroup

@dynamic fromUser;
@dynamic toUser;
@dynamic lastMessage;
@dynamic unreadMessageCount;

+ (NSString *)parseClassName {
    return INSMessageGroupKeyClass;
}

@end
