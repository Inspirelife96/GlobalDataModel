//
//  INSParseOperationManager+Message.m
//  INSParse
//
//  Created by XueFeng Chen on 2022/7/28.
//

#import "INSParseOperationManager+Message.h"

#import "INSParseDefines.h"

#import "INSMessage.h"

@implementation INSParseOperationManager (Message)

+ (NSArray<INSMessage *> *)findMessagesFromUser:(PFUser *)fromUser
                                         toUser:(PFUser *)toUser
                                           page:(NSInteger)page
                                      pageCount:(NSInteger)pageCount
                                          error:(NSError **)error {
    PFQuery *query = [PFQuery queryWithClassName:INSMessageKeyClass];
    [query whereKey:INSMessageKeyFromUser equalTo:fromUser];
    [query whereKey:INSMessageKeyToUser equalTo:toUser];
    
    [query orderByDescending:INSKeyCreatedAt];
    
    [query setSkip:pageCount * page];
    [query setLimit:pageCount];
    
    return [query findObjects:error];
}

+ (INSMessage *)addMessageFromUser:(PFUser *)fromUser toUser:(PFUser *)toUser content:(NSString *)content error:(NSError **)error {
    INSMessage *message = [[INSMessage alloc] init];
    message.fromUser = fromUser;
    message.toUser = toUser;
    message.content = content;
    
    BOOL succeeded = [message save:error];
    if (succeeded) {
        return message;
    } else {
        return nil;
    }
}

@end
