//
//  INSParseOperationManager+ReplyLike.m
//  INSParse
//
//  Created by XueFeng Chen on 2022/7/17.
//

#import "INSParseOperationManager+ReplyLike.h"

#import "INSParseDefines.h"

#import "INSReply.h"
#import "INSReplyLike.h"

#import "INSParseOperationManager+User.h"
#import "INSParseOperationManager+Notification.h"

@implementation INSParseOperationManager (ReplyLike)

// 判断用户是否喜欢这个Reply
+ (BOOL)isReply:(INSReply *)reply likedbyUser:(PFUser *)user error:(NSError **)error {
    NSArray<INSReplyLike *> *replyLikes = [INSParseOperationManager _findReplyLikeFromUser:user toReply:reply isDeleted:NO error:error];
    
    if (*error) {
        return NO;
    } else {
        if (replyLikes.count > 0) {
            return YES;
        } else {
            return NO;
        }
    }
}

// 添加
+ (INSReplyLike *)addReplyLikeWithFromUser:(PFUser *)fromUser toReply:(INSReply *)toReply error:(NSError **)error {
    // ReplyLike是否已经存在
    NSArray<INSReplyLike *> *replyLikes =  [INSParseOperationManager _findReplyLikeFromUser:fromUser toReply:toReply isDeleted:NO error:error];
    if (*error) {
        return nil;
    } else {
        if (replyLikes.count > 0) {
            return replyLikes[0];
        }
    }
    
    // 存在相应的记录但isDeleted标记为是YES，此时修正为NO即可
    replyLikes =  [INSParseOperationManager _findReplyLikeFromUser:fromUser toReply:toReply isDeleted:YES error:error];
    if (*error) {
        return nil;
    } else {
        if (replyLikes.count > 0) {
            INSReplyLike *replyLike = replyLikes[0];
            BOOL succeeded = [INSParseOperationManager _updateReplyLike:replyLike isDeleted:NO error:error];
            if (!succeeded) {
                return nil;
            }
            return replyLike;
        }
    }
    
    // 不存在记录，那么添加一条新的
    INSReplyLike *replyLike = [[INSReplyLike alloc] init];
    replyLike.fromUser = fromUser;
    replyLike.toReply = toReply;
    replyLike.isDeleted = NO;
    
    BOOL succeeded = [replyLike save:error];
    
    if (succeeded) {
        // 首次喜欢，向消息表中添加一条记录
        NSError *notificationError = nil;
        [INSParseOperationManager addNotificationFromUser:fromUser toUser:toReply.fromUser type:INSNotificationTypeLike subType:INSNotificationSubTypeLikeReply topic:nil post:nil reply:toReply messageGroup:nil error:&notificationError];
        return replyLike;
    } else {
        return nil;
    }
}

// 删除
+ (BOOL)deleteReplyLike:(INSReplyLike *)replyLike error:(NSError **)error {
    return [INSParseOperationManager _updateReplyLike:replyLike isDeleted:YES error:error];
}

+ (BOOL)deleteReplyLikeFromUser:(PFUser *)fromUser toReply:(INSReply *)toReply error:(NSError **)error {
    NSArray<INSReplyLike *> *replyLikes =  [INSParseOperationManager _findReplyLikeFromUser:fromUser toReply:toReply isDeleted:NO error:error];
    
    if (*error) {
        return NO;
    } else {
        // 理论上应该只找到一条记录
        if (replyLikes.count > 0) {
            // 删除所有
            for (NSInteger i = 0; i < replyLikes.count; i++) {
                INSReplyLike *replyLike = replyLikes[i];
                BOOL succeeded = [INSParseOperationManager _updateReplyLike:replyLike isDeleted:YES error:error];
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

+ (NSArray<INSReplyLike *> *)_findReplyLikeFromUser:(PFUser *)fromUser toReply:(INSReply *)toReply isDeleted:(BOOL)isDeleted error:(NSError **)error {
    PFQuery *query = [PFQuery queryWithClassName:INSReplyLikeKeyClass];
    [query whereKey:INSReplyLikeKeyFromUser equalTo:fromUser];
    [query whereKey:INSReplyLikeKeyToReply equalTo:toReply];
    [query whereKey:INSReplyLikeKeyIsDeleted equalTo:@(isDeleted)];
    return [query findObjects:error];
}

+ (BOOL)_updateReplyLike:(INSReplyLike *)replyLike isDeleted:(BOOL)isDeleted error:(NSError **)error {
    replyLike.isDeleted = isDeleted;
    return [replyLike save:error];
}

@end
