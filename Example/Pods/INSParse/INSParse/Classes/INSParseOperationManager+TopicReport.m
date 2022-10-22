//
//  INSParseOperationManager+TopicReport.m
//  INSParse
//
//  Created by XueFeng Chen on 2022/5/20.
//

#import "INSParseOperationManager+TopicReport.h"

#import "INSTopicReport.h"

@implementation INSParseOperationManager (TopicReport)

+ (INSTopicReport *)addTopicReportFromUser:(PFUser *)fromUser toTopic:(INSTopic *)toTopic forReason:(INSParseReportReason)reason error:(NSError **)error {
    INSTopicReport *topicReport = [[INSTopicReport alloc] init];
    
    topicReport.fromUser = fromUser;
    topicReport.toTopic = toTopic;
    topicReport.reason = @(reason);
    
    BOOL succeeded = [topicReport save:error];
    
    if (succeeded) {
        return topicReport;
    } else {
        return nil;
    }
}

@end
