//
//  INSParseOperationManager+Reply.m
//  INSParse
//
//  Created by XueFeng Chen on 2021/12/28.
//

#import "INSParseOperationManager+Reply.h"

#import "INSParseDefines.h"

#import "INSParseOperationManager+Notification.h"
#import "INSParseOperationManager+User.h"
#import "INSParseOperationManager+Block.h"

#import "INSPost.h"
#import "INSReply.h"

@implementation INSParseOperationManager (Reply)

+ (NSArray <INSReply *> *)findRepliesToPost:(INSPost *)toPost
                                    orderBy:(NSString *)orderBy
                                       page:(NSInteger)page
                                  pageCount:(NSInteger)pageCount
                                      error:(NSError **)error
{
    PFQuery *query = [PFQuery queryWithClassName:INSReplyKeyClass];
    
    // 默认条件1: 必须审核通过
    [query whereKey:INSReplyKeyIsApproved equalTo:@(YES)];
    
    // 默认条件2: 不能标记为删除
    [query whereKey:INSReplyKeyIsDeleted equalTo:@(NO)];
    
    // 默认条件4:登录状态下，发布者不能在登录用户的黑名单中
    PFQuery *isDeletedUserQuery = [PFQuery queryWithClassName:PFUserKeyClass];
    [isDeletedUserQuery whereKey:INSUserKeyIsDeleted equalTo:@(YES)];
    [query whereKey:INSPostKeyFromUser doesNotMatchQuery:isDeletedUserQuery];
    
    // 如果时登录用户，屏蔽黑名单
    if ([PFUser currentUser]) {
        PFQuery *blockQuery = [PFQuery queryWithClassName:INSBlockKeyClass];
        [blockQuery whereKey:INSBlockKeyFromUser equalTo:[PFUser currentUser]];
        [query whereKey:INSReplyKeyFromUser doesNotMatchKey:INSBlockKeyToUser inQuery:blockQuery];
    }
    
    [query whereKey:INSReplyKeyToPost equalTo:toPost];
    
    [query orderByDescending:orderBy];
    
    [query setSkip:pageCount * page];
    [query setLimit:pageCount];
    
    return [query findObjects:error];
}

+ (INSReply *)addReplyToPost:(INSPost *)toPost
            isApproved:(BOOL)isApproved
             isDeleted:(BOOL)isDeleted
               content:(NSString *)content
              fromUser:(PFUser *)fromUser
                 error:(NSError **)error {
    return [INSParseOperationManager addReplyToPost:toPost isApproved:isApproved isDeleted:isDeleted content:content fromUser:fromUser toReply:nil error:error];
}


+ (INSReply *)addReplyToReply:(INSReply *)toReply
            isApproved:(BOOL)isApproved
             isDeleted:(BOOL)isDeleted
               content:(NSString *)content
              fromUser:(PFUser *)fromUser
                  error:(NSError **)error {
    return [INSParseOperationManager addReplyToPost:toReply.toPost isApproved:isApproved isDeleted:isDeleted content:content fromUser:fromUser toReply:toReply error:error];
}

+ (INSReply *)addReplyToPost:(INSPost *)toPost
            isApproved:(BOOL)isApproved
             isDeleted:(BOOL)isDeleted
               content:(NSString *)content
              fromUser:(PFUser *)fromUser
               toReply:(INSReply * _Nullable)toReply
                 error:(NSError **)error
{
    INSReply *reply = [[INSReply alloc] init];
    
    reply.isApproved = isApproved;
    reply.isDeleted = isDeleted;
    
    reply.content = content;
    reply.fromUser = fromUser;
    reply.toPost = toPost;
    
    reply.likeCount = @(0);
    
    if (toReply) {
        reply.toReply = toReply;
    }
    
    BOOL succeeded = [reply save:error];
    
    // 这里我们不处理toPost里对应的计数和replies,交由服务器处理！！！重要
    
    // 添加通知
    // 如果是针对Post的回复，则发给Post的所有者
    // 如果是针对Reply的回复，则发给Reply的所有者
    if (succeeded) {
        PFUser *toUser = toPost.fromUser;
        NSString *subType = INSNotificationSubTypeCommentPost;
        if (toReply) {
            toUser = toReply.fromUser;
            subType = INSNotificationSubTypeCommentReply;
        }
        
        NSError *notificationError = nil;
        [INSParseOperationManager addNotificationFromUser:fromUser toUser:toUser type:INSNotificationTypeComment subType:subType topic:nil post:nil reply:reply messageGroup:nil error:&notificationError];
        
        return reply;
    } else {
        return nil;
    }
}

+ (BOOL)updateReply:(INSReply *)reply content:(NSString *)content error:(NSError **)error {
    NSAssert([PFUser currentUser], @"必须登录才能更新Reply");
    NSAssert([[PFUser currentUser].objectId isEqualToString:reply.fromUser.objectId], @"登录用户必须和发布者一致才能更新Post");

    reply.content = content;
    return [reply save:error];
}

+ (BOOL)updateReply:(INSReply *)reply isDeleted:(BOOL)isDeleted error:(NSError **)error {
    reply.isDeleted = isDeleted;
    return [reply save:error];
}

+ (BOOL)updateReply:(INSReply *)reply isApproved:(BOOL)isApproved error:(NSError **)error {
    reply.isApproved = isApproved;
    return [reply save:error];
}

+ (PFQuery *)buildReplyQueryWhereFromUserIsBlockedByUser:(PFUser *)user {
    PFQuery *replyQuery = [PFQuery queryWithClassName:INSReplyKeyClass];
    PFQuery *blockQuery = [INSParseOperationManager buildBlockQueryWhereFromUserIs:user];
    [replyQuery whereKey:INSReplyKeyFromUser matchesKey:INSBlockKeyToUser inQuery:blockQuery];
    return replyQuery;
}

+ (PFQuery *)buildReplyQueryWhereFromUserIsDeleted {
    PFQuery *replyQuery = [PFQuery queryWithClassName:INSReplyKeyClass];
    PFQuery *userQuery = [INSParseOperationManager buildUserQueryWhereUserIsDeleted];
    [replyQuery whereKey:INSReplyKeyFromUser matchesQuery:userQuery];
    return replyQuery;
}

+ (PFQuery *)buildReplyQueryWhereFromUserIsLocked {
    PFQuery *replyQuery = [PFQuery queryWithClassName:INSReplyKeyClass];
    PFQuery *userQuery = [INSParseOperationManager buildUserQueryWhereUserIsLocked];
    [replyQuery whereKey:INSReplyKeyFromUser matchesQuery:userQuery];
    return replyQuery;
}

@end
