//
//  INSPostReport.m
//  INSParse
//
//  Created by XueFeng Chen on 2022/5/5.
//

#import "INSPostReport.h"

#import "INSParseDefines.h"

@implementation INSPostReport

@dynamic fromUser;
@dynamic toPost;
@dynamic reason;

+ (NSString *)parseClassName {
    return INSPostReportKeyClass;
}

@end
