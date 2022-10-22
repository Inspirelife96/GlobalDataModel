//
//  INSTopic.m
//  INSParse
//
//  Created by XueFeng Chen on 2021/6/22.
//

#import "INSTopic.h"

#import <Parse/PFObject+Subclass.h>

#import "INSParseDefines.h"

@implementation INSTopic

@dynamic isLocked;
@dynamic isDeleted;
@dynamic isPrivate;
@dynamic isApproved;
@dynamic isPopular;
@dynamic title;
@dynamic content;
@dynamic mediaFileObjects;
@dynamic mediaFileType;
@dynamic fromUser;
@dynamic postCount;
@dynamic likeCount;
@dynamic shareCount;
@dynamic category;
@dynamic tags;

+ (NSString *)parseClassName {
    return INSTopicKeyClass;
}

@end
