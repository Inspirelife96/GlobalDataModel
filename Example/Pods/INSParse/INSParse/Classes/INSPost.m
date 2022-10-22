//
//  INSPost.m
//  INSParse
//
//  Created by XueFeng Chen on 2021/6/22.
//

#import "INSPost.h"

#import <Parse/PFObject+Subclass.h>

#import "INSParseDefines.h"

@implementation INSPost

@dynamic isApproved;
@dynamic isDeleted;
@dynamic content;
@dynamic mediaFileObjects;
@dynamic mediaFileType;
@dynamic replies;
@dynamic replyCount;
@dynamic likeCount;
@dynamic fromUser;
@dynamic toTopic;

+ (NSString *)parseClassName {
    return INSPostKeyClass;
}

@end
