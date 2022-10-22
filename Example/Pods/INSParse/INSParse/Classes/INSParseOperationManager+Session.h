//
//  INSParseOperationManager+Session.h
//  INSParse
//
//  Created by XueFeng Chen on 2022/7/1.
//

#import "INSParseOperationManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface INSParseOperationManager (Session)

+ (BOOL)removeInvalidSessions:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
