//
//  INSParseOperationManager+PostReport.m
//  INSParse
//
//  Created by XueFeng Chen on 2022/7/22.
//

#import "INSParseOperationManager+PostReport.h"

#import "INSPostReport.h"

@implementation INSParseOperationManager (PostReport)

+ (INSPostReport *)addPostReportFromUser:(PFUser *)fromUser toPost:(INSPost *)toPost forReason:(INSParseReportReason)reason error:(NSError **)error {
    INSPostReport *postReport = [[INSPostReport alloc] init];
    
    postReport.fromUser = fromUser;
    postReport.toPost = toPost;
    postReport.reason = @(reason);
    
    BOOL succeeded = [postReport save:error];
    
    if (succeeded) {
        return postReport;
    } else {
        return nil;
    }
}

@end
