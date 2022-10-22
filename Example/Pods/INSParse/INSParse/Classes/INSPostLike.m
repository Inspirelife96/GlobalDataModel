//
//  INSPostLike.m
//  INSParse
//
//  Created by XueFeng Chen on 2022/5/2.
//

#import "INSPostLike.h"

#import "INSParseDefines.h"

@implementation INSPostLike

@dynamic fromUser;
@dynamic toPost;
@dynamic isDeleted;

+ (NSString *)parseClassName {
    return INSPostLikeKeyClass;
}

@end
