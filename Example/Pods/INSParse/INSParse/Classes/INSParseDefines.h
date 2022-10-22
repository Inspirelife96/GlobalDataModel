//
//  INSParseDefines.h
//  INSParse
//
//  Created by XueFeng Chen on 2021/6/22.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, INSErrorCode) {
    kINSErrorUserIsLocked = 1000,
    kINSErrorUserIsDeleted = 1001,
};

//typedef NS_ENUM(NSInteger, INSTimeLineType) {
//    INSTimeLineTypeLikeTopic = 0,
//    INSTimeLineTypeLikePost = 1,
//    INSTimeLineTypeLikeReply = 2,
//    INSTimeLineTypePost = 3,
//    INSTimeLineTypeReply = 4,
//    INSTimeLineTypeFollow = 5,
//};

//typedef NS_ENUM(NSInteger, INSParseRecordStatus) {
//    INSParseRecordStatusPrivate = 0,
//    INSParseRecordStatusPublic = 1,
//    INSParseRecordStatusBanned = 2
//};

//typedef NS_ENUM(NSInteger, INSParseActivityType) {
//    INSParseActivityTypeAddPost = 100,
//    INSParseActivityTypeAddLike = 200,
//    INSParseActivityTypeAddShare = 300,
//    INSParseActivityTypeAddFollow = 400,
//    INSParseActivityTypeAddReply = 500,
//
//    INSParseActivityTypeAddTopic = 1000,
//    INSParseActivityTypePublicTopic = 1001,
//    INSParseActivityTypeBanTopic = 1002,
//};

//typedef NS_ENUM(NSInteger, INSParseReportType) {
//    INSParseReportTypeTopic = 0,
//    INSParseReportTypePost = 1
//};

//typedef NS_ENUM(NSInteger, INSParseLikeType) {
//    INSParseLikeTypeTopic = 0,
//    INSParseLikeTypePost = 1
//};

typedef NS_ENUM(NSInteger, INSParseReportReason) {
    INSParseReportReasonPornography = 0,
    INSParseReportReasonIllegal = 1,
    INSParseReportReasonIrrelated = 2,
    INSParseReportReasonLost = 3,
    INSParseReportReasonOthers = 4,
};

extern NSString *const INSTimeLineTypeAddTopic;
extern NSString *const INSTimeLineTypeAddPost;
extern NSString *const INSTimeLineTypeAddReply;
extern NSString *const INSTimeLineTypeLikeTopic;
extern NSString *const INSTimeLineTypeLikePost;
extern NSString *const INSTimeLineTypeLikeReply;
extern NSString *const INSTimeLineTypeFollow;
extern NSString *const INSTimeLineTypeUnfollow;

extern NSString *const INSNotificationTypeComment;
extern NSString *const INSNotificationTypeLike;
extern NSString *const INSNotificationTypeMessage;
extern NSString *const INSNotificationTypeFollow;
extern NSString *const INSNotificationTypeOther;

extern NSString *const INSNotificationSubTypeNone;
extern NSString *const INSNotificationSubTypeCommentTopic;
extern NSString *const INSNotificationSubTypeCommentPost;
extern NSString *const INSNotificationSubTypeCommentReply;
extern NSString *const INSNotificationSubTypeLikeTopic;
extern NSString *const INSNotificationSubTypeLikePost;
extern NSString *const INSNotificationSubTypeLikeReply;
extern NSString *const INSNotificationSubTypeOtherTopicIsNotApproved;
extern NSString *const INSNotificationSubTypeOtherPostIsNotApproved;
extern NSString *const INSNotificationSubTypeOtherReplyIsNotApproved;

// 目前不支持转发/赞回帖，暂时不要玩的太大。

// PFObject 表自带下面四个字段，所以下面的所有其他表都自带这四个字段
extern NSString *const INSKeyObjectId; // objectId (String)
extern NSString *const INSKeyCreatedAt; // 创建日期 (Date)
extern NSString *const INSKeyUpdatedAt; // 更新日期 (Date)
extern NSString *const INSKeyACL; // 权限控制 (ACL)

# pragma mark - Installtion 表

// 表名为：_Installation，系统默认定了如下字段，你可以在 PFInstallationConstants中找到他们的定义
//
// NSString *const PFInstallationKeyParseVersion = @"parseVersion";
// NSString *const PFInstallationKeyDeviceType = @"deviceType";
// NSString *const PFInstallationKeyInstallationId = @"installationId";
// NSString *const PFInstallationKeyDeviceToken = @"deviceToken";
// NSString *const PFInstallationKeyAppName = @"appName";
// NSString *const PFInstallationKeyAppVersion = @"appVersion";
// NSString *const PFInstallationKeyAppIdentifier = @"appIdentifier";
// NSString *const PFInstallationKeyTimeZone = @"timeZone";
// NSString *const PFInstallationKeyLocaleIdentifier = @"localeIdentifier";
// NSString *const PFInstallationKeyBadge = @"badge";
// NSString *const PFInstallationKeyChannels = @"channels";

// 需要追加的定义

// Class key
extern NSString *const PFInstalltionKeyClass;

// Field keys
extern NSString *const INSInstalltionKeyLinkedUser;

#pragma mark - User 表

// User 表 ： 用户表，由Parse Server提供，除了默认的字段之外，需要额外添加一些字段。

// Class key
extern NSString *const PFUserKeyClass;

// Field keys

// 系统提供的字段
//extern NSString *const PFUserKeyEmailVerified;
//extern NSString *const PFUserKeyAuthData;
//extern NSString *const PFUserKeyUserName;
//extern NSString *const PFUserKeyPassword;
//extern NSString *const PFUserKeyEmail;

// 自定义字段
extern NSString *const INSUserKeyIsLocked;
extern NSString *const INSUserKeyIsDeleted;
extern NSString *const INSUserKeyStatisticsInfo;
extern NSString *const INSUserKeyProfileImage;
extern NSString *const INSUserKeyBackgroundImage;
extern NSString *const INSUserKeySignature;
extern NSString *const INSUserKeyBadgeCount;
extern NSString *const INSUserKeyPreferredLanguage;


# pragma mark - Topics 表

// Topics 表 ： 主题

// Class key
extern NSString *const INSTopicKeyClass;

// Field keys

// 标记
extern NSString *const INSTopicKeyIsLocked;
extern NSString *const INSTopicKeyIsDeleted;
extern NSString *const INSTopicKeyIsPrivate;
extern NSString *const INSTopicKeyIsApproved;
extern NSString *const INSTopicKeyIsPopular;

// 核心字段：
extern NSString *const INSTopicKeyTitle; // 标题 （NSString）
extern NSString *const INSTopicKeyContent; // 内容（NSString）
extern NSString *const INSTopicKeyMediaFileObjects; // 图片，可多图 (NSArray<PFFile *>)
extern NSString *const INSTopicKeyMediaFileType;
extern NSString *const INSTopicKeyFromUser; // 创建者（PFUser）

// 统计字段：
extern NSString *const INSTopicKeyPostCount; // 回帖数（NSNumber）
extern NSString *const INSTopicLikeKeyCount; // 点赞数（NSNumber）
extern NSString *const INSTopicKeyShareCount; // 分享数（NSNumber）

// 板块/话题：
extern NSString *const INSTopicKeyCategory; // 标签 （INSCategory）
extern NSString *const INSTopicKeyTags; // 标签 （NSArray）



# pragma mark - Posts 表

// Posts 表 ： 回帖

// Class key
extern NSString *const INSPostKeyClass;

// Field keys

// 标记
extern NSString *const INSPostKeyIsLocked;
extern NSString *const INSPostKeyIsApproved;
extern NSString *const INSPostKeyIsDeleted;

// 核心内容
extern NSString *const INSPostKeyContent;
extern NSString *const INSPostKeyMediaFileObjects;
extern NSString *const INSPostKeyMediaFileType;
extern NSString *const INSPostKeyReplies;

// 统计字段：
extern NSString *const INSPostKeyReplyCount;
extern NSString *const INSPostLikeKeyCount;

// 关系
extern NSString *const INSPostKeyFromUser;
extern NSString *const INSPostKeyToTopic;

# pragma mark - Replies 表

// Replies 表 ： 回复表 指用户针对回帖发表的内容，只能是文字。

// Class key
extern NSString *const INSReplyKeyClass;

// Field keys

// 标记
extern NSString *const INSReplyKeyIsLocked;
extern NSString *const INSReplyKeyIsApproved;
extern NSString *const INSReplyKeyIsDeleted;

// 核心内容
extern NSString *const INSReplyKeyContent;

// 统计字段：
extern NSString *const INSReplyLikeKeyCount;

// 关系
extern NSString *const INSReplyKeyFromUser;
extern NSString *const INSReplyKeyToPost;
extern NSString *const INSReplyKeyToReply;

# pragma mark - Categories 表

// Categories 表 ： 板块

// Class key
extern NSString *const INSCategoryKeyClass;

// Field keys
extern NSString *const INSCategoryKeyName;

# pragma mark - Tags 表

// Tags 表 ： 标签

// Class key
extern NSString *const INSTagKeyClass;

// Field keys
extern NSString *const INSTagKeyName;

# pragma mark - TopicLikes 表

// TopicLikes 表 ：主题点赞

// Class key
extern NSString *const INSTopicLikeKeyClass;

// Field keys
extern NSString *const INSTopicLikeKeyFromUser;
extern NSString *const INSTopicLikeKeyToTopic;
extern NSString *const INSTopicLikeKeyIsDeleted;

# pragma mark - PostLikes 表

// PostLikes 表 ：回帖点赞

// Class key
extern NSString *const INSPostLikeKeyClass;

// Field keys
extern NSString *const INSPostLikeKeyFromUser;
extern NSString *const INSPostLikeKeyToPost;
extern NSString *const INSPostLikeKeyIsDeleted;

# pragma mark - ReplyLikes 表

// ReplyLikes 表 ：回复点赞

// Class key
extern NSString *const INSReplyLikeKeyClass;

// Field keys
extern NSString *const INSReplyLikeKeyFromUser;
extern NSString *const INSReplyLikeKeyToReply;
extern NSString *const INSReplyLikeKeyIsDeleted;

# pragma mark - TopicReports 表

// TopicReports 表 ：主题举报

// Class key
extern NSString *const INSTopicReportKeyClass;

// Field keys
extern NSString *const INSTopicReportKeyFromUser;
extern NSString *const INSTopicReportKeyToTopic;

# pragma mark - PostReports 表

// PostReports 表 ：回帖举报

// Class key
extern NSString *const INSPostReportKeyClass;

// Field keys
extern NSString *const INSPostReportKeyFromUser;
extern NSString *const INSPostReportKeyToPost;

# pragma mark - ReplyReports 表

// ReplyReports 表 ：回复举报

// Class key
extern NSString *const INSReplyReportKeyClass;

// Field keys
extern NSString *const INSReplyReportKeyFromUser;
extern NSString *const INSReplyReportKeyToReply;


# pragma mark - Shares 表

// Shares 表 指用户分享Topic

// Class key
extern NSString *const INSShareKeyClass;

// Field keys
extern NSString *const INSShareKeyTopic; // 分享的Topic
extern NSString *const INSShareKeyFromUser; // 谁分享的
extern NSString *const INSShareKeyToPlatform; // 分享到什么地方了

# pragma mark - Follows 表

// Follows 表： 指用户之间的关系

// Class key
extern NSString *const INSFollowKeyClass;

// Field keys
extern NSString *const INSFollowKeyFromUser; // 关注
extern NSString *const INSFollowKeyToUser; // 被关注
extern NSString *const INSFollowKeyIsDeleted;


# pragma mark - Blocks 表

// Blocks 表： 黑名单表

// Class key
extern NSString *const INSBlockKeyClass;

// Field keys
extern NSString *const INSBlockKeyFromUser; // 发起者
extern NSString *const INSBlockKeyToUser; // 黑名单用户


# pragma mark - Notifications 表

// Notifications 表 该表每存入一条记录（后台就会发送一条推送给消息接受者）

// Class key
extern NSString *const INSTimeLineKeyClass;

extern NSString *const INSTimeLineKeyFromUser; // 消息发送者
extern NSString *const INSTimeLineKeyToUser; // 消息接受者
extern NSString *const INSTimeLineKeyType;
extern NSString *const INSTimeLineKeyPost;
extern NSString *const INSTimeLineKeyReply;
extern NSString *const INSTimeLineKeyLikeTopic;
extern NSString *const INSTimeLineKeyLikePost;
extern NSString *const INSTimeLineKeyLikeReply;
extern NSString *const INSTimeLineKeyFollow;


# pragma mark - StatisticsInfos 表

// StatisticsInfos表 User表创建StatisticsInfo字段和其关联，方便读取用户的关注/粉丝/Topic数/获得的赞等统计记录记录。

// Class key
extern NSString *const INSStatisticsInfoKeyClass;

// Field keys
extern NSString *const INSStatisticsInfoKeyUser; // 用户
extern NSString *const INSStatisticsInfoKeyProfileviews; // 用户
extern NSString *const INSStatisticsInfoKeyReputation; // 用户
extern NSString *const INSStatisticsInfoKeyTopicCount; // 用户
extern NSString *const INSStatisticsInfoKeyPostCount; // 用户
extern NSString *const INSStatisticsInfoKeyFollowerCount; // 关注
extern NSString *const INSStatisticsInfoKeyFollowingCount; // 粉丝
extern NSString *const INSStatisticsInfoKeyLikedCount; // 获赞数

# pragma mark - Notification 表

// Class key
extern NSString *const INSNotificationKeyClass;

// Field keys

extern NSString *const INSNotificationKeyFromUser;
extern NSString *const INSNotificationKeyToUser;
extern NSString *const INSNotificationKeyType;
extern NSString *const INSNotificationKeySubType;
extern NSString *const INSNotificationKeyTopic;
extern NSString *const INSNotificationKeyPost;
extern NSString *const INSNotificationKeyReply;
extern NSString *const INSNotificationKeyMessage;

# pragma mark - NotificationCount 表

// Class key
extern NSString *const INSNotificationCountKeyClass;

// Field keys

extern NSString *const INSNotificationCountKeyUser;
extern NSString *const INSNotificationCountKeyTotalCount;
extern NSString *const INSNotificationCountKeyCommentCount;
extern NSString *const INSNotificationCountKeyLikeCount;
extern NSString *const INSNotificationCountKeyFollowCount;
extern NSString *const INSNotificationCountKeyMessageCount;
extern NSString *const INSNotificationCountKeyOtherCount;

# pragma mark - Message 表

// Message表 保存用户的私信信息

// Class key
extern NSString *const INSMessageKeyClass;

// Field keys
extern NSString *const INSMessageKeyFromUser;
extern NSString *const INSMessageKeyToUser;
extern NSString *const INSMessageKeyContent;


# pragma mark - MessageGroup 表

// Message表 保存用户的私信信息

// Class key
extern NSString *const INSMessageGroupKeyClass;

// Field keys
extern NSString *const INSMessageGroupKeyFromUser;
extern NSString *const INSMessageGroupKeyToUser;
extern NSString *const INSMessageGroupKeyLastMessage;
extern NSString *const INSMessageGroupKeyUnreadMessageCount;


# pragma mark - BadgeCount 表

// Message表 保存用户的私信信息

// Class key
extern NSString *const INSBadgeCountKeyClass;

// Field keys
extern NSString *const INSBadgeCountKeyUser;
extern NSString *const INSBadgeCountKeyTotalCount;
extern NSString *const INSBadgeCountKeyCommentCount;
extern NSString *const INSBadgeCountKeyLikeCount;
extern NSString *const INSBadgeCountKeyFollowCount;
extern NSString *const INSBadgeCountKeyMessageCount;
extern NSString *const INSBadgeCountKeyOtherCount;
