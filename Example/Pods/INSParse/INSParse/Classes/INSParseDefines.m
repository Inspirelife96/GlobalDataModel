//
//  INSParseDefines.m
//  INSParse
//
//  Created by XueFeng Chen on 2021/6/22.
//

#import "INSParseDefines.h"

NSString *const INSTimeLineTypeAddTopic = @"Add Topic";
NSString *const INSTimeLineTypeAddPost = @"Add Post";
NSString *const INSTimeLineTypeAddReply = @"Add Reply";
NSString *const INSTimeLineTypeLikeTopic = @"Like Topic";
NSString *const INSTimeLineTypeLikePost = @"Like Post";
NSString *const INSTimeLineTypeLikeReply = @"Like Reply";
NSString *const INSTimeLineTypeReportTopic = @"Report Topic";
NSString *const INSTimeLineTypeReportPost = @"Report Post";
NSString *const INSTimeLineTypeReportReply = @"Report Reply";
NSString *const INSTimeLineTypeFollow = @"Follow";
NSString *const INSTimeLineTypeUnfollow = @"Unfollow";

NSString *const INSNotificationTypeComment = @"Comment";
NSString *const INSNotificationTypeLike = @"Like";
NSString *const INSNotificationTypeMessage = @"Message";
NSString *const INSNotificationTypeFollow = @"Follow";
NSString *const INSNotificationTypeOther = @"Other";

NSString *const INSNotificationSubTypeNone = @"None";
NSString *const INSNotificationSubTypeCommentTopic = @"Comment Topic";
NSString *const INSNotificationSubTypeCommentPost = @"Comment Post";
NSString *const INSNotificationSubTypeCommentReply = @"Comment Reply";
NSString *const INSNotificationSubTypeLikeTopic = @"Like Topic";
NSString *const INSNotificationSubTypeLikePost = @"Like Post";
NSString *const INSNotificationSubTypeLikeReply = @"Like Reply";
NSString *const INSNotificationSubTypeOtherTopicIsNotApproved = @"Topic Is Not Approved";
NSString *const INSNotificationSubTypeOtherPostIsNotApproved = @"Post Is Not Approved";
NSString *const INSNotificationSubTypeOtherReplyIsNotApproved = @"Reply Is Not Approved";

// PFObject 表自带下面四个字段，所以下面的所有其他表都自带这四个字段

NSString *const INSKeyObjectId = @"objectId";
NSString *const INSKeyCreatedAt = @"createdAt";
NSString *const INSKeyUpdatedAt = @"updateAt";
NSString *const INSKeyACL = @"ACL";

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
NSString *const PFInstalltionKeyClass = @"_Installation";

// Field keys
NSString *const INSInstalltionKeyLinkedUser = @"linkedUser";

#pragma mark - User 表

// User 表 ： 用户表，由Parse Server提供，除了默认的字段之外，需要额外添加一些字段。

// Class key
NSString *const PFUserKeyClass = @"_User";

// Field keys

// 系统提供的字段
//NSString *const PFUserKeyEmailVerified = @"emailVerified";
//NSString *const PFUserKeyAuthData = @"authData";
//NSString *const PFUserKeyUserName = @"userName";
//NSString *const PFUserKeyPassword = @"password";
//NSString *const PFUserKeyEmail = @"email";

// 自定义字段
NSString *const INSUserKeyIsLocked = @"isLocked";
NSString *const INSUserKeyIsDeleted = @"isDeleted";
NSString *const INSUserKeyStatisticsInfo = @"statisticsInfo";
NSString *const INSUserKeyProfileImage = @"profileImage";
NSString *const INSUserKeyBackgroundImage = @"backgroundImage";
NSString *const INSUserKeySignature = @"signature";
NSString *const INSUserKeyBadgeCount = @"badgeCount";
NSString *const INSUserKeyPreferredLanguage = @"preferredLanguage";

# pragma mark - Topics 表

// Topics 表 ： 主题

// Class key
NSString *const INSTopicKeyClass = @"Topic";

// Field keys

// 标记
NSString *const INSTopicKeyIsLocked = @"isLocked";
NSString *const INSTopicKeyIsDeleted = @"isDeleted";
NSString *const INSTopicKeyIsPrivate = @"isPrivate";
NSString *const INSTopicKeyIsApproved = @"isArrpoved";
NSString *const INSTopicKeyIsPopular = @"isPopular";

// 核心字段：
NSString *const INSTopicKeyTitle = @"title"; // 标题 （NSString）
NSString *const INSTopicKeyContent = @"comtent"; // 内容（NSString）
NSString *const INSTopicKeyMediaFileObjects = @"mediaFileObjects"; // 图片，可多图 (NSArray<PFFile *>)
NSString *const INSTopicKeyMediaFileType = @"mediaFileType";
NSString *const INSTopicKeyFromUser = @"fromUser"; // 创建者（PFUser）

// 统计字段：
NSString *const INSTopicKeyPostCount = @"postCount"; // 回帖数（NSNumber）
NSString *const INSTopicLikeKeyCount = @"likeCount"; // 点赞数（NSNumber）
NSString *const INSTopicKeyShareCount = @"shareCount"; // 分享数（NSNumber）

// 板块/话题：
NSString *const INSTopicKeyCategory = @"category"; // 标签 （INSCategory）
NSString *const INSTopicKeyTags = @"tags"; // 标签 （NSArray）

# pragma mark - Posts 表

// Posts 表 ： 回帖

// Class key
NSString *const INSPostKeyClass = @"Post";

// Field keys

// 标记
NSString *const INSPostKeyIsLocked = @"isLocked";
NSString *const INSPostKeyIsApproved = @"isApproved";
NSString *const INSPostKeyIsDeleted = @"isDeleted";

// 核心内容
NSString *const INSPostKeyContent = @"content";
NSString *const INSPostKeyMediaFileObjects = @"mediaFileObjects";
NSString *const INSPostKeyMediaFileType = @"mediaFileType";
NSString *const INSPostKeyReplies = @"replies";

// 统计字段：
NSString *const INSPostKeyReplyCount = @"replyCount";
NSString *const INSPostLikeKeyCount = @"likeCount";

// 关系
NSString *const INSPostKeyFromUser = @"fromUser";
NSString *const INSPostKeyToTopic = @"toTopic";

# pragma mark - Replies 表

// Replies 表 ： 回复表 指用户针对回帖发表的内容，只能是文字。

// Class key
NSString *const INSReplyKeyClass = @"Reply";

// Field keys

// 标记
NSString *const INSReplyKeyIsLocked = @"isLocked";
NSString *const INSReplyKeyIsApproved = @"isApproved";
NSString *const INSReplyKeyIsDeleted = @"isDeleted";

// 核心内容
NSString *const INSReplyKeyContent = @"content";

// 统计字段：
NSString *const INSReplyLikeKeyCount = @"likeCount";

// 关系
NSString *const INSReplyKeyFromUser = @"fromUser";
NSString *const INSReplyKeyToPost = @"toPost";
NSString *const INSReplyKeyToReply = @"toReply";

# pragma mark - Categories 表

// Categories 表 ： 板块

// Class key
NSString *const INSCategoryKeyClass = @"Category";

// Field keys
NSString *const INSCategoryKeyName = @"name";

# pragma mark - Tags 表

// Tags 表 ： 标签

// Class key
NSString *const INSTagKeyClass = @"Tag";

// Field keys
NSString *const INSTagKeyName = @"name";

# pragma mark - TopicLikes 表

// TopicLikes 表 ：主题点赞

// Class key
NSString *const INSTopicLikeKeyClass = @"TopicLike";

// Field keys
NSString *const INSTopicLikeKeyFromUser = @"fromUser";
NSString *const INSTopicLikeKeyToTopic = @"toTopic";
NSString *const INSTopicLikeKeyIsDeleted = @"isDeleted";

# pragma mark - PostLikes 表

// PostLikes 表 ：回帖点赞

// Class key
NSString *const INSPostLikeKeyClass = @"PostLike";

// Field keys
NSString *const INSPostLikeKeyFromUser = @"fromUser";
NSString *const INSPostLikeKeyToPost = @"toPost";
NSString *const INSPostLikeKeyIsDeleted = @"isDeleted";

# pragma mark - ReplyLikes 表

// ReplyLikes 表 ：回复点赞

// Class key
NSString *const INSReplyLikeKeyClass = @"ReplyLike";

// Field keys
NSString *const INSReplyLikeKeyFromUser = @"fromUser";
NSString *const INSReplyLikeKeyToReply = @"toReply";
NSString *const INSReplyLikeKeyIsDeleted = @"isDeleted";

# pragma mark - TopicReports 表

// TopicReports 表 ：主题举报

// Class key
NSString *const INSTopicReportKeyClass = @"TopicReport";

// Field keys
NSString *const INSTopicReportKeyFromUser = @"fromUser";
NSString *const INSTopicReportKeyToTopic = @"toTopic";

# pragma mark - PostReports 表

// PostReports 表 ：回帖举报

// Class key
NSString *const INSPostReportKeyClass = @"PostReport";

// Field keys
NSString *const INSPostReportKeyFromUser = @"fromUser";
NSString *const INSPostReportKeyToPost = @"toPost";

# pragma mark - ReplyReports 表

// ReplyReports 表 ：回复举报

// Class key
NSString *const INSReplyReportKeyClass = @"ReplyReport";

// Field keys
NSString *const INSReplyReportKeyFromUser = @"fromUser";
NSString *const INSReplyReportKeyToReply = @"toReply";


# pragma mark - Shares 表

// Shares 表 指用户分享Topic

// Class key
NSString *const INSShareKeyClass = @"Share";

// Field keys
NSString *const INSShareKeyTopic = @"topic"; // 分享的Topic
NSString *const INSShareKeyFromUser = @"fromUser"; // 谁分享的
NSString *const INSShareKeyToPlatform = @"toPlatform"; // 分享到什么地方了

# pragma mark - Follows 表

// Follows 表： 指用户之间的关系

// Class key
NSString *const INSFollowKeyClass = @"Follow";

// Field keys
NSString *const INSFollowKeyFromUser = @"fromUser"; // 关注
NSString *const INSFollowKeyToUser = @"toUser"; // 被关注
NSString *const INSFollowKeyIsDeleted = @"isDeleted"; // 被关注


# pragma mark - Blocks 表

// Blocks 表： 黑名单表

// Class key
NSString *const INSBlockKeyClass = @"Block";

// Field keys
NSString *const INSBlockKeyFromUser = @"fromUser"; // 发起者
NSString *const INSBlockKeyToUser = @"toUser"; // 黑名单用户


# pragma mark - Notifications 表

// Notifications 表 该表每存入一条记录（后台就会发送一条推送给消息接受者）

// Class key
NSString *const INSTimeLineKeyClass = @"TimeLine";

NSString *const INSTimeLineKeyFromUser = @"fromUser"; // 消息发送者
NSString *const INSTimeLineKeyToUser = @"toUser"; // 消息接受者
NSString *const INSTimeLineKeyType = @"type";
NSString *const INSTimeLineKeyPost = @"post";
NSString *const INSTimeLineKeyReply = @"reply";
NSString *const INSTimeLineKeyLikeTopic = @"likeTopic";
NSString *const INSTimeLineKeyLikePost = @"likePost";
NSString *const INSTimeLineKeyLikeReply = @"likeReply";
NSString *const INSTimeLineKeyFollow = @"follow";


# pragma mark - StatisticsInfos 表

// StatisticsInfos表 User表创建StatisticsInfo字段和其关联，方便读取用户的关注/粉丝/Topic数/获得的赞等统计记录记录。

// Class key
NSString *const INSStatisticsInfoKeyClass = @"StatisticsInfo";

// Field keys
NSString *const INSStatisticsInfoKeyUser = @"user"; // 用户
NSString *const INSStatisticsInfoKeyProfileviews = @"profileViews"; // 用户
NSString *const INSStatisticsInfoKeyReputation = @"reputation"; // 用户
NSString *const INSStatisticsInfoKeyTopicCount = @"topicCount"; // 用户
NSString *const INSStatisticsInfoKeyPostCount = @"postCount"; // 用户
NSString *const INSStatisticsInfoKeyFollowerCount = @"followerCount"; // 粉丝
NSString *const INSStatisticsInfoKeyFollowingCount = @"followingCount"; // 关注
NSString *const INSStatisticsInfoKeyLikedCount = @"likedCount"; // 获赞数


# pragma mark - Notification 表

// Class key
NSString *const INSNotificationKeyClass = @"Notification";

// Field keys

NSString *const INSNotificationKeyFromUser = @"fromUser";
NSString *const INSNotificationKeyToUser = @"toUser";
NSString *const INSNotificationKeyType = @"type";
NSString *const INSNotificationKeySubType = @"subType";
NSString *const INSNotificationKeyTopic = @"topic";
NSString *const INSNotificationKeyPost = @"post";
NSString *const INSNotificationKeyReply = @"reply";
NSString *const INSNotificationKeyMessage = @"message";

# pragma mark - Message 表

// Message表 保存用户的私信信息

// Class key
NSString *const INSMessageKeyClass = @"Message";

// Field keys
NSString *const INSMessageKeyFromUser = @"fromUser"; // 用户
NSString *const INSMessageKeyToUser = @"toUser"; // 用户
NSString *const INSMessageKeyContent = @"content"; // 用户


# pragma mark - MessageGroup 表

// Message表 保存用户的私信信息

// Class key
NSString *const INSMessageGroupKeyClass = @"MessageGroup";

// Field keys
NSString *const INSMessageGroupKeyFromUser = @"fromUser";
NSString *const INSMessageGroupKeyToUser = @"toUser";
NSString *const INSMessageGroupKeyLastMessage = @"lastMessage";
NSString *const INSMessageGroupKeyUnreadMessageCount = @"unreadMessageCount";


# pragma mark - BadgeCount 表

// Message表 保存用户的私信信息

// Class key
NSString *const INSBadgeCountKeyClass = @"BadgeCount";

// Field keys
NSString *const INSBadgeCountKeyUser = @"user";
NSString *const INSBadgeCountKeyTotalCount = @"totalCount";
NSString *const INSBadgeCountKeyCommentCount = @"commentCount";
NSString *const INSBadgeCountKeyLikeCount = @"likeCount";
NSString *const INSBadgeCountKeyFollowCount = @"followCount";
NSString *const INSBadgeCountKeyMessageCount = @"messageCount";
NSString *const INSBadgeCountKeyOtherCount = @"otherCount";


