//
//  INSParseOperationManager+Notification.h
//  INSParse
//
//  Created by XueFeng Chen on 2022/5/28.
//

#import "INSParseOperationManager.h"

NS_ASSUME_NONNULL_BEGIN

@class INSTopic;
@class INSPost;
@class INSReply;
@class INSMessageGroup;
@class INSNotification;

@interface INSParseOperationManager (Notification)

+ (NSArray<INSNotification *> *)findCommentNotificationToUser:(PFUser *)toUser
                                                         page:(NSInteger)page
                                                    pageCount:(NSInteger)pageCount
                                                        error:(NSError **)error;

+ (NSArray<INSNotification *> *)findLikeNotificationToUser:(PFUser *)toUser
                                                      page:(NSInteger)page
                                                 pageCount:(NSInteger)pageCount
                                                     error:(NSError **)error;

+ (NSArray<INSNotification *> *)findFollowNotificationToUser:(PFUser *)toUser
                                                        page:(NSInteger)page
                                                   pageCount:(NSInteger)pageCount
                                                       error:(NSError **)error;

+ (NSArray<INSNotification *> *)findMessageGroupNotificationToUser:(PFUser *)toUser
                                                              page:(NSInteger)page
                                                         pageCount:(NSInteger)pageCount
                                                             error:(NSError **)error;

+ (NSArray<INSNotification *> *)findOtherNotificationToUser:(PFUser *)toUser
                                                       page:(NSInteger)page
                                                  pageCount:(NSInteger)pageCount
                                                      error:(NSError **)error;

// 部分在客户端实现，部分会在服务器端实现
+ (BOOL)addNotificationFromUser:(PFUser *)fromUser
                         toUser:(PFUser *)toUser
                           type:(NSString *)type
                        subType:(NSString *)subType
                          topic:(INSTopic * _Nullable)topic
                           post:(INSPost * _Nullable)post
                          reply:(INSReply * _Nullable)reply
                   messageGroup:(INSMessageGroup * _Nullable)messageGroup
                          error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
