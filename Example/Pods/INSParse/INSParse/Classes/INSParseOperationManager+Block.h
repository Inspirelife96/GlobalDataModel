//
//  INSParseOperationManager+Block.h
//  INSParse
//
//  Created by XueFeng Chen on 2022/7/21.
//

#import "INSParseOperationManager.h"

NS_ASSUME_NONNULL_BEGIN

@class INSBlock;

@interface INSParseOperationManager (Block)

+ (INSBlock *)addBlockFromUser:(PFUser *)fromUser toUser:(PFUser *)toUser error:(NSError **)error;

+ (PFQuery *)buildBlockQueryWhereFromUserIs:(PFUser *)user;

@end

NS_ASSUME_NONNULL_END
