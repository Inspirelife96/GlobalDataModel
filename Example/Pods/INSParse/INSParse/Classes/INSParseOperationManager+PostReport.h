//
//  INSParseOperationManager+PostReport.h
//  INSParse
//
//  Created by XueFeng Chen on 2022/7/22.
//

#import "INSParseOperationManager.h"

#import "INSParseDefines.h"

NS_ASSUME_NONNULL_BEGIN

@class INSPost;
@class INSPostReport;

@interface INSParseOperationManager (PostReport)

+ (INSPostReport *)addPostReportFromUser:(PFUser *)fromUser toPost:(INSPost *)toPost forReason:(INSParseReportReason)reason error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
