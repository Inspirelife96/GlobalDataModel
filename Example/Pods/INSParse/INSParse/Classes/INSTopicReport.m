//
//  INSTopicReport.m
//  INSParse
//
//  Created by XueFeng Chen on 2022/5/5.
//

#import "INSTopicReport.h"

#import "INSParseDefines.h"

@implementation INSTopicReport

@dynamic fromUser;
@dynamic toTopic;
@dynamic reason;

+ (NSString *)parseClassName {
    return INSTopicReportKeyClass;
}

@end
