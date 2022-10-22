//
//  INSParseOperationManager+PostLike.m
//  INSParse
//
//  Created by XueFeng Chen on 2022/7/17.
//

#import "INSParseOperationManager+PostLike.h"

#import "INSParseDefines.h"

#import "INSParseOperationManager+User.h"
#import "INSParseOperationManager+Block.h"
#import "INSParseOperationManager+Notification.h"

#import "INSPost.h"
#import "INSPostLike.h"

@implementation INSParseOperationManager (PostLike)

// 判断用户是否喜欢这个Post
+ (BOOL)isPost:(INSPost *)post likedbyUser:(PFUser *)user error:(NSError **)error {
    NSArray<INSPostLike *> *postLikes =  [INSParseOperationManager _findPostLikeFromUser:user toPost:post isDeleted:NO error:error];
    
    if (*error) {
        return NO;
    } else {
        if (postLikes.count > 0) {
            return YES;
        } else {
            return NO;
        }
    }
}

// 添加
+ (INSPostLike *)addPostLikeWithFromUser:(PFUser *)fromUser toPost:(INSPost *)toPost error:(NSError **)error {
    // PostLike是否已经存在
    NSArray<INSPostLike *> *postLikes =  [INSParseOperationManager _findPostLikeFromUser:fromUser toPost:toPost isDeleted:NO error:error];
    if (*error) {
        return nil;
    } else {
        if (postLikes.count > 0) {
            return postLikes[0];
        }
    }
    
    // 存在相应的记录但isDeleted标记为是YES，此时修正为NO即可
    postLikes =  [INSParseOperationManager _findPostLikeFromUser:fromUser toPost:toPost isDeleted:YES error:error];
    if (*error) {
        return nil;
    } else {
        if (postLikes.count > 0) {
            INSPostLike *postLike = postLikes[0];
            BOOL succeeded = [INSParseOperationManager _updatePostLike:postLike isDeleted:NO error:error];
            if (!succeeded) {
                return nil;
            }
            return postLike;
        }
    }
    
    // 不存在记录，那么添加一条新的
    INSPostLike *postLike = [[INSPostLike alloc] init];
    postLike.fromUser = fromUser;
    postLike.toPost = toPost;
    postLike.isDeleted = NO;
    
    BOOL succeeded = [postLike save:error];
    
    if (succeeded) {
        // 首次喜欢，向消息表中添加一条记录
        NSError *notificationError = nil;
        [INSParseOperationManager addNotificationFromUser:fromUser toUser:toPost.fromUser type:INSNotificationTypeLike subType:INSNotificationSubTypeLikePost topic:nil post:toPost reply:nil messageGroup:nil error:&notificationError];
        return postLike;
    } else {
        return nil;
    }
}

// 删除
+ (BOOL)deletePostLike:(INSPostLike *)postLike error:(NSError **)error {
    return [INSParseOperationManager _updatePostLike:postLike isDeleted:YES error:error];
}

+ (BOOL)deletePostLikeFromUser:(PFUser *)fromUser toPost:(INSPost *)toPost error:(NSError **)error {
    NSArray<INSPostLike *> *postLikes =  [INSParseOperationManager _findPostLikeFromUser:fromUser toPost:toPost isDeleted:NO error:error];
    
    if (*error) {
        return NO;
    } else {
        // 理论上应该只找到一条记录
        if (postLikes.count > 0) {
            // 删除所有
            for (NSInteger i = 0; i < postLikes.count; i++) {
                INSPostLike *postLike = postLikes[i];
                BOOL succeeded = [INSParseOperationManager _updatePostLike:postLike isDeleted:YES error:error];
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

+ (NSArray<INSPostLike *> *)_findPostLikeFromUser:(PFUser *)fromUser toPost:(INSPost *)toPost isDeleted:(BOOL)isDeleted error:(NSError **)error {
    PFQuery *query = [PFQuery queryWithClassName:INSPostLikeKeyClass];
    [query whereKey:INSPostLikeKeyFromUser equalTo:fromUser];
    [query whereKey:INSPostLikeKeyToPost equalTo:toPost];
    [query whereKey:INSPostLikeKeyIsDeleted equalTo:@(isDeleted)];
    return [query findObjects:error];
}

+ (BOOL)_updatePostLike:(INSPostLike *)postLike isDeleted:(BOOL)isDeleted error:(NSError **)error {
    postLike.isDeleted = isDeleted;
    return [postLike save:error];
}

@end
