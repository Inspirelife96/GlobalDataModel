//
//  INSParseOperationManager+TopicReport.h
//  INSParse
//
//  Created by XueFeng Chen on 2022/5/20.
//

#import "INSParseOperationManager.h"

#import "INSParseDefines.h"

NS_ASSUME_NONNULL_BEGIN

@class INSTopic;
@class INSTopicReport;

@interface INSParseOperationManager (TopicReport)

+ (INSTopicReport *)addTopicReportFromUser:(PFUser *)fromUser toTopic:(INSTopic *)toTopic forReason:(INSParseReportReason)reason error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
