//
//  INSParseOperationManager+TopicLike.h
//  INSParse
//
//  Created by XueFeng Chen on 2022/5/19.
//

#import "INSParseOperationManager.h"

NS_ASSUME_NONNULL_BEGIN

@class INSTopic;
@class INSTopicLike;

@interface INSParseOperationManager (TopicLike)

// 查找喜欢这个Topic的用户
+ (NSArray<PFUser *> *)findUsersWhoLikesTopic:(INSTopic *)toTopic page:(NSInteger)page pageCount:(NSInteger)pageCount error:(NSError **)error;

// 查找用户喜欢的Topic
+ (NSArray<INSTopic *> *)findTopicsLikedByUser:(PFUser *)fromUser page:(NSInteger)page pageCount:(NSInteger)pageCount error:(NSError **)error;

// 判断用户是否喜欢这个Topic
+ (BOOL)isTopic:(INSTopic *)topic likedbyUser:(PFUser *)user error:(NSError **)error;

// 添加
+ (INSTopicLike *)addTopicLikeWithFromUser:(PFUser *)fromUser toTopic:(INSTopic *)toTopic error:(NSError **)error;

// 删除
+ (BOOL)deleteTopicLike:(INSTopicLike *)topicLike error:(NSError **)error;
+ (BOOL)deleteTopicLikeFromUser:(PFUser *)fromUser toTopic:(INSTopic *)toTopic error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
