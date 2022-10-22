//
//  INSParseOperationManager+TopicLike.m
//  INSParse
//
//  Created by XueFeng Chen on 2022/5/19.
//

#import "INSParseOperationManager+TopicLike.h"

#import "INSParseDefines.h"

#import "INSTopic.h"
#import "INSTopicLike.h"

#import "INSParseOperationManager+Notification.h"
#import "INSParseOperationManager+User.h"
#import "INSParseOperationManager+Block.h"

@implementation INSParseOperationManager (TopicLike)

// 查找喜欢这个Topic的用户
+ (NSArray<PFUser *> *)findUsersWhoLikesTopic:(INSTopic *)toTopic page:(NSInteger)page pageCount:(NSInteger)pageCount error:(NSError **)error {
    PFQuery *query = [PFQuery queryWithClassName:INSTopicLikeKeyClass];
    
    // 查询的必要条件
    [query whereKey:INSTopicKeyIsDeleted equalTo:@(NO)];
    [query whereKey:INSTopicLikeKeyToTopic equalTo:toTopic];

    // 去除fromUser是注销用户
    PFQuery *deletedUserQuery = [INSParseOperationManager buildUserQueryWhereUserIsDeleted];
    [query whereKey:INSTopicLikeKeyFromUser doesNotMatchQuery:deletedUserQuery];
    
    // 去除fromUser是禁止用户
    PFQuery *lockedUserQuery = [INSParseOperationManager buildUserQueryWhereUserIsLocked];
    [query whereKey:INSTopicLikeKeyFromUser doesNotMatchQuery:lockedUserQuery];

    // 如果是登录用户，屏蔽黑名单
    if ([PFUser currentUser]) {
        PFQuery *blockQuery = [INSParseOperationManager buildBlockQueryWhereFromUserIs:[PFUser currentUser]];
        [query whereKey:INSTopicLikeKeyFromUser doesNotMatchKey:INSBlockKeyToUser inQuery:blockQuery];
    }
    
    [query includeKey:INSTopicLikeKeyFromUser];
    [query includeKey:INSTopicLikeKeyToTopic];
        
    [query orderByDescending:INSKeyCreatedAt];

    [query setSkip:pageCount * page];
    [query setLimit:pageCount];
    
    NSArray<INSTopicLike *> *topicLikes = [query findObjects:error];
    
    if (*error) {
        return @[];
    } else {
        NSMutableArray *userMutableArray = [[NSMutableArray alloc] init];
        
        [topicLikes enumerateObjectsUsingBlock:^(INSTopicLike *  _Nonnull topicLike, NSUInteger idx, BOOL * _Nonnull stop) {
            if (topicLike.isDeleted == NO) {
                PFUser *user = topicLike.fromUser;
                [userMutableArray addObject:user];
            }
        }];
        
        return [userMutableArray copy];
    }
}

// 查找用户喜欢的Topic
+ (NSArray<INSTopic *> *)findTopicsLikedByUser:(PFUser *)fromUser page:(NSInteger)page pageCount:(NSInteger)pageCount error:(NSError **)error {
    PFQuery *query = [PFQuery queryWithClassName:INSTopicLikeKeyClass];
    
    [query whereKey:INSTopicKeyIsDeleted equalTo:@(NO)];
    [query whereKey:INSTopicLikeKeyFromUser equalTo:fromUser];
    
    // 理论上，我们需要继续对toTopic进行筛选，剔除那些无效的toTopic，例如：
    // - Topic本身被作者删除了，被作者隐藏了，被管理员禁了。
    // - Topic的发布者注销了，或者被管理员禁了
    // - Topic的发布者在当前登录用户的黑名单里
    //
    // 但剔除这些无效的toTopic，用户的体验可能会有瑕疵，请看下面的例子：
    // - A用户喜欢了用户B发布的Topic1，
    // - 用户B把Topic1删除了
    // - 用户A查找自己喜欢的Topic，却发现自己明明喜欢了Topic1，却怎么也找不到了
    //
    // 因此，从用户的体验上来说，我更倾向展示这些无效的toTopic，并在用户进一步展开时
    // 提示用户，因为某些原因，这些Topic已经无法展开了。
    
    // 基于上述原因，我们不再对toTopic进行筛选
        
    [query includeKey:INSTopicLikeKeyFromUser];
    [query includeKey:INSTopicLikeKeyToTopic];
        
    [query orderByDescending:INSKeyCreatedAt];

    [query setSkip:pageCount * page];
    [query setLimit:pageCount];
    
    NSArray<INSTopicLike *> *topicLikes =  [query findObjects:error];
    
    if (*error) {
        return @[];
    } else {
        NSMutableArray *userMutableArray = [[NSMutableArray alloc] init];
        
        [topicLikes enumerateObjectsUsingBlock:^(INSTopicLike *  _Nonnull topicLike, NSUInteger idx, BOOL * _Nonnull stop) {
            if (topicLike.isDeleted == NO) {
                INSTopic *topic = topicLike.toTopic;
                [userMutableArray addObject:topic];
            }
        }];
        
        return [userMutableArray copy];
    }
}

+ (BOOL)isTopic:(INSTopic *)topic likedbyUser:(PFUser *)user error:(NSError **)error {
    NSArray<INSTopicLike *> *topicLikes = [INSParseOperationManager _findTopicLikeFromUser:user toTopic:topic isDeleted:NO error:error];

    if (*error) {
        return NO;
    } else {
        if (topicLikes.count > 0) {
            return YES;
        } else {
            return NO;
        }
    }
}

// 添加
+ (INSTopicLike *)addTopicLikeWithFromUser:(PFUser *)fromUser toTopic:(INSTopic *)toTopic error:(NSError **)error {
    NSArray<INSTopicLike *> *topicLikes = [INSParseOperationManager _findTopicLikeFromUser:fromUser toTopic:toTopic isDeleted:NO error:error];
    
    if (*error) {
        return nil;
    } else {
        if (topicLikes.count > 0) {
            return topicLikes[0];
        }
    }
    
    topicLikes = [INSParseOperationManager _findTopicLikeFromUser:fromUser toTopic:toTopic isDeleted:YES error:error];

    if (*error) {
        return nil;
    } else {
        if (topicLikes.count > 0) {
            INSTopicLike *topicLike = topicLikes[0];
            BOOL succeeded = [INSParseOperationManager _updateTopicLike:topicLike isDeleted:NO error:error];
            if (!succeeded) {
                return nil;
            }
            return topicLike;
        }
    }
    
    INSTopicLike *topicLike = [[INSTopicLike alloc] init];
    topicLike.fromUser = fromUser;
    topicLike.toTopic = toTopic;
    topicLike.isDeleted = NO;
    
    BOOL succeeded = [topicLike save:error];
    
    if (succeeded) {
        // 首次喜欢，向消息表中添加一条记录
        // 该操作不管是否成功，不会影响addTopicLike的操作，因此操作执行后，返回YES。
        NSError *notificationError = nil;
        [INSParseOperationManager addNotificationFromUser:fromUser toUser:toTopic.fromUser type:INSNotificationTypeLike subType:INSNotificationSubTypeLikeTopic topic:toTopic post:nil reply:nil messageGroup:nil error:&notificationError];
        
        return topicLike;
    } else {
        return nil;
    }
}

// 逻辑删除
+ (BOOL)deleteTopicLike:(INSTopicLike *)topicLike error:(NSError **)error {
    return [INSParseOperationManager _updateTopicLike:topicLike isDeleted:YES error:error];
}

// 逻辑删除
+ (BOOL)deleteTopicLikeFromUser:(PFUser *)fromUser toTopic:(INSTopic *)toTopic error:(NSError **)error {
    NSArray<INSTopicLike *> *topicLikes = [INSParseOperationManager _findTopicLikeFromUser:fromUser toTopic:toTopic isDeleted:NO error:error];
    
    if (*error) {
        return NO;
    } else {
        // 理论上应该只找到一条记录
        if (topicLikes.count > 0) {
            // 删除所有
            for (NSInteger i = 0; i < topicLikes.count; i++) {
                INSTopicLike *topicLike = topicLikes[i];
                BOOL succeeded = [INSParseOperationManager _updateTopicLike:topicLike isDeleted:YES error:error];
                if (!succeeded) {
                    return NO;
                }
            }
            return YES;
        } else {
            return YES;//没找到，证明已经删除了
        }
    }
}

+ (NSArray<INSTopicLike *> *)_findTopicLikeFromUser:(PFUser *)fromUser toTopic:(INSTopic *)toTopic isDeleted:(BOOL)isDeleted error:(NSError **)error {
    PFQuery *query = [PFQuery queryWithClassName:INSTopicLikeKeyClass];
    [query whereKey:INSTopicLikeKeyFromUser equalTo:fromUser];
    [query whereKey:INSTopicLikeKeyToTopic equalTo:toTopic];
    [query whereKey:INSTopicLikeKeyIsDeleted equalTo:@(isDeleted)];
    return [query findObjects:error];
}

+ (BOOL)_updateTopicLike:(INSTopicLike *)topicLike isDeleted:(BOOL)isDeleted error:(NSError **)error {
    topicLike.isDeleted = isDeleted;
    return [topicLike save:error];
}

@end
