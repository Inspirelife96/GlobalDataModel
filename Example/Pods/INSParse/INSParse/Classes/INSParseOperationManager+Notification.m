//
//  INSParseOperationManager+Notification.m
//  INSParse
//
//  Created by XueFeng Chen on 2022/5/28.
//

#import "INSParseOperationManager+Notification.h"

#import "INSNotification.h"

#import "INSParseDefines.h"

@implementation INSParseOperationManager (Notification)

+ (NSArray<INSNotification *> *)findCommentNotificationToUser:(PFUser *)toUser
                                                         page:(NSInteger)page
                                                    pageCount:(NSInteger)pageCount
                                                        error:(NSError **)error {
    return [INSParseOperationManager queryNotificationToUser:toUser type:INSNotificationTypeComment page:page pageCount:pageCount error:error];
}

+ (NSArray<INSNotification *> *)findLikeNotificationToUser:(PFUser *)toUser
                                                     page:(NSInteger)page
                                                 pageCount:(NSInteger)pageCount
                                                     error:(NSError **)error {
    return [INSParseOperationManager queryNotificationToUser:toUser type:INSNotificationTypeLike page:page pageCount:pageCount error:error];
}

+ (NSArray<INSNotification *> *)findFollowNotificationToUser:(PFUser *)toUser
                                                        page:(NSInteger)page
                                                   pageCount:(NSInteger)pageCount
                                                       error:(NSError **)error {
    return [INSParseOperationManager queryNotificationToUser:toUser type:INSNotificationTypeFollow page:page pageCount:pageCount error:error];
}

+ (NSArray<INSNotification *> *)findMessageGroupNotificationToUser:(PFUser *)toUser
                                                         page:(NSInteger)page
                                                    pageCount:(NSInteger)pageCount
                                                        error:(NSError **)error {
    return [INSParseOperationManager queryNotificationToUser:toUser type:INSNotificationTypeMessage page:page pageCount:pageCount error:error];
}

+ (NSArray<INSNotification *> *)findOtherNotificationToUser:(PFUser *)toUser
                                                       page:(NSInteger)page
                                                  pageCount:(NSInteger)pageCount
                                                      error:(NSError **)error {
    return [INSParseOperationManager queryNotificationToUser:toUser type:INSNotificationTypeOther page:page pageCount:pageCount error:error];
}


+ (NSArray<INSNotification *> *)queryNotificationToUser:(PFUser *)toUser
                                                   type:(NSString *)type
                                                   page:(NSInteger)page
                                              pageCount:(NSInteger)pageCount
                                                  error:(NSError **)error {
    PFQuery *query = [PFQuery queryWithClassName:INSNotificationKeyClass];
    [query whereKey:INSNotificationKeyToUser equalTo:toUser];
    [query whereKey:INSNotificationKeyType equalTo:type];
    
    [query orderByDescending:INSKeyUpdatedAt];
    
    [query setSkip:pageCount * page];
    [query setLimit:pageCount];
    
    return [query findObjects:error];
}

+ (BOOL)addNotificationFromUser:(PFUser *)fromUser
                         toUser:(PFUser *)toUser
                           type:(NSString *)type
                        subType:(NSString *)subType
                          topic:(INSTopic * _Nullable)topic
                           post:(INSPost * _Nullable)post
                          reply:(INSReply * _Nullable)reply
                   messageGroup:(INSMessageGroup * _Nullable)messageGroup
                          error:(NSError **)error {
    INSNotification *notification = [[INSNotification alloc] init];
    
    notification.fromUser = fromUser;
    notification.toUser = toUser;
    notification.type = type;
    notification.subType = subType;
    
    if (topic) {
        notification.topic = topic;
    }
    
    if (post) {
        notification.post = post;
    }
    
    if (reply) {
        notification.reply = reply;
    }
    
    if (messageGroup) {
        notification.messageGroup = messageGroup;
    }
    
    return [notification save:error];
}

@end
