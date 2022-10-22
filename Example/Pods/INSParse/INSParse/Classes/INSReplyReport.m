//
//  INSReplyReport.m
//  INSParse
//
//  Created by XueFeng Chen on 2022/5/5.
//

#import "INSReplyReport.h"

#import "INSParseDefines.h"

@implementation INSReplyReport

@dynamic fromUser;
@dynamic toReply;
@dynamic reason;

+ (NSString *)parseClassName {
    return INSReplyReportKeyClass;
}

@end
