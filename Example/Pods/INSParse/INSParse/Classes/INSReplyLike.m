//
//  INSReplyLike.m
//  INSParse
//
//  Created by XueFeng Chen on 2022/5/3.
//

#import "INSReplyLike.h"

#import "INSParseDefines.h"

@implementation INSReplyLike

@dynamic fromUser;
@dynamic toReply;
@dynamic isDeleted;

+ (NSString *)parseClassName {
    return INSReplyLikeKeyClass;
}

@end
