//
//  INSStatisticsInfo.m
//  INSParse
//
//  Created by XueFeng Chen on 2021/6/26.
//

#import "INSStatisticsInfo.h"

#import "INSParseDefines.h"

@implementation INSStatisticsInfo

@dynamic user;
@dynamic profileViews;
@dynamic reputation;
@dynamic topicCount;
@dynamic postCount;
@dynamic followerCount;
@dynamic followingCount;
@dynamic likedCount;

+ (NSString *)parseClassName {
    return INSStatisticsInfoKeyClass;
}

@end
