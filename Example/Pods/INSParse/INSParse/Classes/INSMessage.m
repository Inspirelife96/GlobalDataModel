//
//  INSMessage.m
//  INSParse
//
//  Created by XueFeng Chen on 2022/5/28.
//

#import "INSMessage.h"

#import <Parse/PFObject+Subclass.h>

#import "INSParseDefines.h"

@implementation INSMessage

@dynamic fromUser;
@dynamic toUser;
@dynamic content;

+ (NSString *)parseClassName {
    return INSMessageKeyClass;
}

@end
