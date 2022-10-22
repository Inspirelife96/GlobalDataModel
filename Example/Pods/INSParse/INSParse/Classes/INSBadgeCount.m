//
//  INSBadgeCount.m
//  INSParse
//
//  Created by XueFeng Chen on 2022/5/29.
//

#import "INSBadgeCount.h"

#import <Parse/PFObject+Subclass.h>

#import "INSParseDefines.h"

@implementation INSBadgeCount

@dynamic user;
@dynamic totalCount;
@dynamic commentCount;
@dynamic likeCount;
@dynamic followCount;
@dynamic messageCount;
@dynamic otherCount;

+ (NSString *)parseClassName {
    return INSBadgeCountKeyClass;
}

@end
