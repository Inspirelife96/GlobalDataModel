//
//  INSTopicLike.m
//  INSParse
//
//  Created by XueFeng Chen on 2022/5/2.
//

#import "INSTopicLike.h"

#import "INSParseDefines.h"

@implementation INSTopicLike

@dynamic fromUser;
@dynamic toTopic;
@dynamic isDeleted;

+ (NSString *)parseClassName {
    return INSTopicLikeKeyClass;
}

@end
