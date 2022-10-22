//
//  INSParseOperationManager+Message.h
//  INSParse
//
//  Created by XueFeng Chen on 2022/7/28.
//

#import "INSParseOperationManager.h"

NS_ASSUME_NONNULL_BEGIN

@class INSMessage;

@interface INSParseOperationManager (Message)

+ (NSArray<INSMessage *> *)findMessagesFromUser:(PFUser *)fromUser
                                         toUser:(PFUser *)toUser
                                           page:(NSInteger)page
                                      pageCount:(NSInteger)pageCount
                                          error:(NSError **)error;

+ (INSMessage *)addMessageFromUser:(PFUser *)fromUser toUser:(PFUser *)toUser content:(NSString *)content error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
