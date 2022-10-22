//
//  INSParseOperationManager+ReplyReport.m
//  INSParse
//
//  Created by XueFeng Chen on 2022/7/22.
//

#import "INSParseOperationManager+ReplyReport.h"

#import "INSReplyReport.h"

@implementation INSParseOperationManager (ReplyReport)

+ (INSReplyReport *)addReplyReportFromUser:(PFUser *)fromUser toReply:(INSReply *)toReply forReason:(INSParseReportReason)reason error:(NSError **)error {
    INSReplyReport *replyReport = [[INSReplyReport alloc] init];
    
    replyReport.fromUser = fromUser;
    replyReport.toReply = toReply;
    replyReport.reason = @(reason);
    
    BOOL succeeded = [replyReport save:error];
    
    if (succeeded) {
        return replyReport;
    } else {
        return nil;
    }
}

@end
