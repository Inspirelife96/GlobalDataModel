//
//  INSParseOperationManager+Follow.m
//  INSParse
//
//  Created by XueFeng Chen on 2021/6/24.
//

#import "INSParseOperationManager+Follow.h"

#import "INSParseDefines.h"

#import "INSFollow.h"

#import "INSParseOperationManager+Notification.h"
#import "INSParseOperationManager+User.h"
#import "INSParseOperationManager+Block.h"

typedef NS_ENUM(NSInteger, INSUserRelationType) {
    INSUserRelationTypeFollow,
    INSUserRelationTypeFollowed
};

@implementation INSParseOperationManager (Follow)

// 查找user的粉丝
+ (NSArray <PFUser *> *)findFollower:(PFUser *)user
                                page:(NSInteger)page
                           pageCount:(NSInteger)pageCount
                               error:(NSError **)error {
    return [INSParseOperationManager _findUserRelationShip:INSUserRelationTypeFollowed forUser:user page:page pageCount:pageCount error:error];
}

// 查找user的关注
+ (NSArray <PFUser *> *)findFollowing:(PFUser *)user
                                 page:(NSInteger)page
                            pageCount:(NSInteger)pageCount
                                error:(NSError **)error {
    return [INSParseOperationManager _findUserRelationShip:INSUserRelationTypeFollow forUser:user page:page pageCount:pageCount error:error];
}

// Follow表添加
+ (INSFollow *)addFollowFromUser:(PFUser *)fromUser toUser:(PFUser *)toUser error:(NSError **)error {
    // 查询Follow表内是否存在记录
    NSArray<INSFollow *> *followArray = [INSParseOperationManager _findFollowFromUser:fromUser toUser:toUser isDeleted:NO error:error];
    
    if (*error) {
        return nil;
    } else {
        // 存在，则直接返回
        if (followArray.count > 0) {
            return followArray[0];
        }
    }
    
    // 查找Follow表内是否存在记录但标记isDeleted=YES
    followArray = [INSParseOperationManager _findFollowFromUser:fromUser toUser:toUser isDeleted:YES error:error];

    if (*error) {
        return nil;
    } else {
        // 存在，则修改标记位
        if (followArray.count > 0) {
            INSFollow *follow = followArray[0];
            BOOL succeeded = [INSParseOperationManager _updateFollow:follow isDeleted:NO error:error];
            if (!succeeded) {
                return follow;
            }
        }
    }
    
    INSFollow *follow = [[INSFollow alloc] init];
    follow.fromUser = fromUser;
    follow.toUser = toUser;
    follow.isDeleted = NO;
    BOOL succeeded = [follow save:error];
    if (succeeded) {
        // 首次关注，向消息表中添加一条记录
        [INSParseOperationManager addNotificationFromUser:fromUser toUser:toUser type:INSNotificationTypeFollow subType:INSNotificationSubTypeNone topic:nil post:nil reply:nil messageGroup:nil error:error];
        return follow;
    } else {
        return nil;
    }
}

// 逻辑删除
+ (BOOL)deleteFollow:(INSFollow *)follow error:(NSError **)error {
    return [INSParseOperationManager _updateFollow:follow isDeleted:YES error:error];
}

// 逻辑删除
+ (BOOL)deleteFollowFromUser:(PFUser *)fromUser toUser:(PFUser *)toUser error:(NSError **)error {
    NSArray *followArray = [INSParseOperationManager _findFollowFromUser:fromUser toUser:toUser isDeleted:NO error:error];
    
    if (*error) {
        return NO;
    } else {
        // 理论上应该只找到一条记录
        if (followArray.count > 0) {
            // 删除所有
            for (NSInteger i = 0; i < followArray.count; i++) {
                INSFollow *follow = followArray[i];
                BOOL succeeded = [INSParseOperationManager _updateFollow:follow isDeleted:YES error:error];
                if (!succeeded) {
                    return NO;
                }
            }
            return YES;
        } else {
            return YES;//没找到，证明没有关注，不需要删除了
        }
    }
}

#pragma mark Private Methods

+ (NSArray *)_findFollowFromUser:(PFUser *)fromUser toUser:(PFUser *)toUser isDeleted:(BOOL)isDeleted error:(NSError **)error {
    PFQuery *query = [PFQuery queryWithClassName:INSFollowKeyClass];
    [query whereKey:INSFollowKeyFromUser equalTo:fromUser];
    [query whereKey:INSFollowKeyToUser equalTo:toUser];
    [query whereKey:INSFollowKeyIsDeleted equalTo:@(isDeleted)];
    
    return [query findObjects:error];
}

+ (BOOL)_updateFollow:(INSFollow *)follow isDeleted:(BOOL)isDeleted error:(NSError **)error {
    follow.isDeleted = isDeleted;
    return [follow save:error];
}

// 查找user的关注
+ (NSArray <PFUser *> *)_findUserRelationShip:(INSUserRelationType)type
                                      forUser:(PFUser *)user
                                         page:(NSInteger)page
                                    pageCount:(NSInteger)pageCount
                                        error:(NSError **)error {
    PFQuery *query = [PFQuery queryWithClassName:INSFollowKeyClass];
    
    // 删除标记必须为NO
    [query whereKey:INSFollowKeyIsDeleted equalTo:@(NO)];
    
    NSString *conditionKey = INSFollowKeyFromUser;
    NSString *tagetKey = INSFollowKeyToUser;
    
    if (type == INSUserRelationTypeFollowed) {
        conditionKey = INSFollowKeyToUser;
        tagetKey = INSFollowKeyFromUser;
    }
    
    // 根据查找的关系类型，设定条件
    [query whereKey:conditionKey equalTo:user];
    
    // 返回的列表的用户，不能为注销的用户
    PFQuery *deletedUserQuery = [INSParseOperationManager buildUserQueryWhereUserIsDeleted];
    [query whereKey:tagetKey doesNotMatchQuery:deletedUserQuery];
    
    // 不能为锁定用户
    PFQuery *lockedUserQuery = [INSParseOperationManager buildUserQueryWhereUserIsLocked];
    [query whereKey:tagetKey doesNotMatchQuery:lockedUserQuery];
    
    // 如果是登录用户，返回的用户不能在登录用户黑名单中
    if ([PFUser currentUser]) {
        PFQuery *blockQuery = [INSParseOperationManager buildBlockQueryWhereFromUserIs:[PFUser currentUser]];
        [query whereKey:tagetKey doesNotMatchKey:INSBlockKeyToUser inQuery:blockQuery];
    }
    
    [query includeKey:tagetKey];
    
    [query setSkip:pageCount * page];
    [query setLimit:pageCount];
    
    // 逆向排序
    [query orderByDescending:@"createdAt"];
    
    NSArray *followArray = [query findObjects:error];
    
    if (*error) {
        return @[];
    } else {
        NSMutableArray *userMutableArray = [[NSMutableArray alloc] init];
        
        [followArray enumerateObjectsUsingBlock:^(INSFollow *  _Nonnull follow, NSUInteger idx, BOOL * _Nonnull stop) {
            PFUser *user = [follow objectForKey:tagetKey];
            [userMutableArray addObject:user];
        }];
        
        return [userMutableArray copy];
    }
}

@end
