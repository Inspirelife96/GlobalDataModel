//
//  INSParseOperationManager+ReplyReport.h
//  INSParse
//
//  Created by XueFeng Chen on 2022/7/22.
//

#import "INSParseOperationManager.h"

#import "INSParseDefines.h"

NS_ASSUME_NONNULL_BEGIN

@class INSReply;
@class INSReplyReport;

@interface INSParseOperationManager (ReplyReport)

+ (INSReplyReport *)addReplyReportFromUser:(PFUser *)fromUser toReply:(INSReply *)toReply forReason:(INSParseReportReason)reason error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
