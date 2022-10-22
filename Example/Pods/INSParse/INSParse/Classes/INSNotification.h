//
//  INSNotification.h
//  INSParse
//
//  Created by XueFeng Chen on 2022/5/20.
//

#import <Parse/Parse.h>

@class INSTopic;
@class INSPost;
@class INSReply;
@class INSMessageGroup;

NS_ASSUME_NONNULL_BEGIN

@interface INSNotification : PFObject <PFSubclassing>

@property (nonatomic, strong) PFUser *fromUser;
@property (nonatomic, strong) PFUser *toUser;

// 通知类型，包括
// INSNotificationTypeComment 评论
// INSNotificationTypeLike 赞和喜欢
// INSNotificationTypeMessage 关注
// INSNotificationTypeFollow 私信
// INSNotificationTypeOther 其他（管理员消息）
@property (nonatomic, strong) NSString *type;

// 通知子类型，包括
// INSNotificationSubTypeCommentTopic;
// INSNotificationSubTypeCommentPost;
// INSNotificationSubTypeCommentReply;
// INSNotificationSubTypeLikeTopic;
// INSNotificationSubTypeLikePost;
// INSNotificationSubTypeLikeReply;
// INSNotificationSubTypeOtherTopicIsNotApproved;
// INSNotificationSubTypeOtherPostIsNotApproved;
// INSNotificationSubTypeOtherReplyIsNotApproved;
@property (nonatomic, strong) NSString *subType;

@property (nonatomic, strong) INSTopic *topic;
@property (nonatomic, strong) INSPost *post;
@property (nonatomic, strong) INSReply *reply;

@property (nonatomic, strong) INSMessageGroup *messageGroup;

// 特例：每一个fromUser/toUser组合仅保留最新的一条数据。
// 如果组合不存在，则添加，如果组合存在，则更新。
//@property (nonatomic, strong) INSMessage *message;
//@property (nonatomic, strong) NSNumber *unreadMessageCount;

@end

NS_ASSUME_NONNULL_END
