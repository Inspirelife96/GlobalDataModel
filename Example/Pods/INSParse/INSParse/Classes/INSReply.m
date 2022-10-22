//
//  INSReply.m
//  INSParse
//
//  Created by XueFeng Chen on 2021/12/28.
//

#import "INSReply.h"

#import <Parse/PFObject+Subclass.h>

#import "INSParseDefines.h"

@implementation INSReply

@dynamic isApproved;
@dynamic isDeleted;
@dynamic content;
@dynamic likeCount;
@dynamic fromUser;
@dynamic toPost;
@dynamic toReply;

+ (NSString *)parseClassName {
    return INSReplyKeyClass;
}

@end
