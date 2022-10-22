//
//  INSParseOperationManager+Installation.h
//  INSParse
//
//  Created by XueFeng Chen on 2022/6/8.
//

#import "INSParseOperationManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface INSParseOperationManager (Installation)

+ (BOOL)linkCurrentInstalltionWithCurrentUser:(NSError **)error;

+ (BOOL)unlinkCurrentInstalltionWithCurrentUser:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
