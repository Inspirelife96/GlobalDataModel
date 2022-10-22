//
//  INSParseOperationManager+Post.m
//  INSParse
//
//  Created by XueFeng Chen on 2021/6/24.
//

#import "INSParseOperationManager+Post.h"

#import "INSParseDefines.h"

#import "INSPost.h"
#import "INSTopic.h"

#import "INSParseOperationManager+Notification.h"
#import "INSParseOperationManager+User.h"
#import "INSParseOperationManager+Block.h"

#import <Parse/PFErrorUtilities.h>

@implementation INSParseOperationManager (Post)

+ (NSArray <INSPost *> *)findPostsToTopic:(INSTopic *)toTopic
                                  orderBy:(NSString *)orderBy
                                     page:(NSInteger)page
                                pageCount:(NSInteger)pageCount
                                    error:(NSError **)error
{
    return [INSParseOperationManager findPostsToTopic:toTopic fromUser:nil category:nil orderBy:orderBy page:page pageCount:pageCount error:error];
}

// - 查询某一个Topic下某个人的所有回贴 - 例如：即只看楼主的功能
+ (NSArray <INSPost *> *)findPostsToTopic:(INSTopic *)toTopic
                                 fromUser:(PFUser *)fromUser
                                  orderBy:(NSString *)orderBy
                                     page:(NSInteger)page
                                pageCount:(NSInteger)pageCount
                                    error:(NSError **)error
{
    return [INSParseOperationManager findPostsToTopic:toTopic fromUser:fromUser category:nil orderBy:orderBy page:page pageCount:pageCount error:error];
}

+ (NSArray *)findPostsToTopic:(INSTopic * _Nullable)toTopic
                     fromUser:(PFUser * _Nullable)fromUser
                     category:(INSCategory * _Nullable)category
                      orderBy:(NSString *)orderBy
                         page:(NSInteger)page
                    pageCount:(NSInteger)pageCount
                        error:(NSError **)error
{
    PFQuery *query = [PFQuery queryWithClassName:INSPostKeyClass];
    
    // 默认条件1: 必须审核通过
    [query whereKey:INSPostKeyIsApproved equalTo:@(YES)];
    
    // 默认条件2: 不能标记为删除
    [query whereKey:INSPostKeyIsDeleted equalTo:@(NO)];
    
    // 默认条件3:发布者不能被注销
    PFQuery *isDeletedUserQuery = [PFQuery queryWithClassName:PFUserKeyClass];
    [isDeletedUserQuery whereKey:INSUserKeyIsDeleted equalTo:@(YES)];
    [query whereKey:INSPostKeyFromUser doesNotMatchQuery:isDeletedUserQuery];
    
    // 默认条件4:登录状态下，发布者不能在登录用户的黑名单中
    if ([PFUser currentUser]) {
        PFQuery *blockQuery = [PFQuery queryWithClassName:INSBlockKeyClass];
        [blockQuery whereKey:INSBlockKeyFromUser equalTo:[PFUser currentUser]];
        [query whereKey:INSPostKeyFromUser doesNotMatchKey:INSBlockKeyToUser inQuery:blockQuery];
    }

    // 查询条件1: 指定Topic
    if (toTopic) {
        [query whereKey:INSPostKeyToTopic equalTo:toTopic];
    }
    
    // 查询条件2: 指定FromUser
    if (fromUser) {
        [query whereKey:INSPostKeyFromUser equalTo:fromUser];
    }
    
    // 查询条件3: 指定板块
    if (category) {
        PFQuery *innerQuery = [PFQuery queryWithClassName:INSTopicKeyClass];
        [innerQuery whereKey:INSTopicKeyCategory equalTo:category];
        [query whereKey:INSPostKeyToTopic matchesQuery:innerQuery];
    }
    
    [query orderByDescending:orderBy];
    
    [query setSkip:pageCount * page];
    [query setLimit:pageCount];
    
    return [query findObjects:error];
}

+ (INSPost *)addPostWithIsApproved:(BOOL)isApproved
                  isDeleted:(BOOL)isDeleted
                    content:(NSString *)content
           mediaFileObjects:(NSArray<PFFileObject *> * _Nullable)mediaFileObjects
                     mediaFileType:(NSString *)mediaFileType
                   fromUser:(PFUser *)fromUser
                    toTopic:(INSTopic *)toTopic
                      error:(NSError **)error
{
    INSPost *post = [[INSPost alloc] init];
    
    post.isApproved = isApproved;
    post.isDeleted = isDeleted;
    post.content = content;
    
    if (mediaFileObjects) {
        post.mediaFileObjects = mediaFileObjects;
        post.mediaFileType = mediaFileType;
    }
    
    post.replies = @[];
    post.replyCount = @(0);
    
    post.likeCount = @(0);
    
    post.fromUser = fromUser;
    post.toTopic = toTopic;
    
    BOOL succeeded = [post save:error];
    
    if (succeeded) {
        //添加通知
        NSError *notificationError = nil;
        [INSParseOperationManager addNotificationFromUser:fromUser toUser:toTopic.fromUser type:INSNotificationTypeComment subType:INSNotificationSubTypeCommentTopic topic:nil post:post reply:nil messageGroup:nil error:&notificationError];
        return post;
    } else {
        return nil;
    }
}


+ (BOOL)updatePost:(INSPost *)post
           content:(NSString * _Nullable)content
  mediaFileObjects:(NSArray<PFFileObject *> * _Nullable)mediaFileObjects
             reply:(NSArray<INSReply *> * _Nullable)replies
             error:(NSError **)error;
{
    NSAssert([PFUser currentUser], @"必须登录才能更新Post");
    NSAssert([[PFUser currentUser].objectId isEqualToString:post.fromUser.objectId], @"登录用户必须和发布者一致才能更新Post");
    
    post.content = content;
    post.mediaFileObjects = mediaFileObjects;
    post.replies = replies;
    
    return [post save:error];
}

// 管理员或者作者可以设置删除状态
+ (BOOL)updatePost:(INSPost *)post isDeleted:(BOOL)isDeleted error:(NSError **)error {
    post.isDeleted = isDeleted;
    return [post save:error];
}

// 管理员可以设置审核状态
+ (BOOL)updatePost:(INSPost *)post isApproved:(BOOL)isApproved error:(NSError **)error {
    post.isApproved = isApproved;
    return [post save:error];
}

+ (PFQuery *)buildPostQueryWhereFromUserIsBlockedByUser:(PFUser *)user {
    PFQuery *postQuery = [PFQuery queryWithClassName:INSPostKeyClass];
    PFQuery *blockQuery = [INSParseOperationManager buildBlockQueryWhereFromUserIs:user];
    [postQuery whereKey:INSPostKeyFromUser matchesKey:INSBlockKeyToUser inQuery:blockQuery];
    return postQuery;
}

+ (PFQuery *)buildPostQueryWhereFromUserIsDeleted {
    PFQuery *postQuery = [PFQuery queryWithClassName:INSPostKeyClass];
    PFQuery *userQuery = [INSParseOperationManager buildUserQueryWhereUserIsDeleted];
    [postQuery whereKey:INSPostKeyFromUser matchesQuery:userQuery];
    return postQuery;
}

+ (PFQuery *)buildPostQueryWhereFromUserIsLocked {
    PFQuery *postQuery = [PFQuery queryWithClassName:INSPostKeyClass];
    PFQuery *userQuery = [INSParseOperationManager buildUserQueryWhereUserIsLocked];
    [postQuery whereKey:INSPostKeyFromUser matchesQuery:userQuery];
    return postQuery;
}

@end
