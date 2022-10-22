//
//  INSParseOperationManager+User.m
//  INSParse
//
//  Created by XueFeng Chen on 2021/6/24.
//

#import "INSParseOperationManager+User.h"

#import "INSParseOperationManager+Installation.h"
#import "INSParseOperationManager+Session.h"

#import "INSParseDefines.h"
#import "INSStatisticsInfo.h"
#import "INSBadgeCount.h"

#import "PFUser.h"

#import <Parse/Parse-umbrella.h>

#import <Parse/PFErrorUtilities.h>

@implementation INSParseOperationManager (User)

+ (void)logInWithUsername:(NSString *)userName password:(NSString *)password error:(NSError **)error {
    // 使用Parse Server提供的登录API进行登录
    PFUser *user = [PFUser logInWithUsername:userName password:password error:error];
    
    if (*error) {
        return;
    } else {
        // 登录成功后，进行后续的处理
        BOOL succeeded = [INSParseOperationManager _configUserAfterLogin:user error:error];
        if (!succeeded) {
            [INSParseOperationManager logOut];
        }
    }
}

+ (void)logInWithAnonymous:(NSError **)error {
    __block NSError *loginError = nil;
    // 调用Parse Server的API进行匿名登录
    [[[PFAnonymousUtils logInInBackground] continueWithBlock:^id _Nullable(BFTask<PFUser *> * _Nonnull task) {
        loginError = task.error;
        if (!task.isCancelled && !task.error) {
            PFUser *user = task.result;
            
            if (user) {
                BOOL succeeded = NO;
                if (user.isNew) {
                    // 如果是第一次登录，那么等同于注册，进行注册的后续处理
                    succeeded = [INSParseOperationManager _configUserAfterSignUp:user error:&loginError];
                } else {
                    // 如果不是第一次登录，那么等同于登录，进行登录的后续处理
                    succeeded = [INSParseOperationManager _configUserAfterLogin:user error:&loginError];
                }
                
                if (!succeeded) {
                    [INSParseOperationManager logOut];
                }
            }
        }
        
        return task;
    }] waitUntilFinished];
    
    *error = loginError;
}

+ (void)upgradeAnonymousUser:(PFUser *)user withUsername:(NSString *)userName password:(NSString *)password email:(NSString *)email error:(NSError **)error {
    user.username = userName;
    user.password = password;
    user.email = email;
    
    [user signUp:error];
    
    return;
}

+ (void)signUpWithUsername:(NSString *)userName password:(NSString *)password email:(NSString *)email error:(NSError **)error {
    // 创建user
    PFUser *user = [PFUser user];
    user.username = userName;
    user.password = password;
    user.email = email;
    
    // 调用signUp注册
    BOOL succeeded = [user signUp:error];
    
    if (succeeded) {
        succeeded = [INSParseOperationManager _configUserAfterSignUp:user error:error];
        if (!succeeded) {
            [INSParseOperationManager logOut];
        }
    } else {
        return;
    }
}

+ (BFTask *)loginWithAppleAuthType:(NSString *)authType authData:(NSDictionary<NSString *, NSString *> *)authData username:(NSString *)userName email:(NSString *)email error:(NSError **)error {
    __block BFTask *appleAuthTask;
    
    __block NSError *loginError = nil;
    
    // 调用由Parse Server 提供的第三方登录API
    [[[PFUser logInWithAuthTypeInBackground:authType authData:authData] continueWithBlock:^id _Nullable(BFTask<__kindof PFUser *> * _Nonnull task) {
        appleAuthTask = task;
        loginError = task.error;
        if (!task.isCancelled && !task.error) {
            PFUser *user = task.result;
            
            if (user) {
                BOOL succeeded = NO;
                if (user.isNew) {
                    // 第一次登录，则按注册走
                    succeeded = [INSParseOperationManager _configUserAfterSignUp:user error:&loginError];
                } else {
                    // 非第一次登录，则按登录走
                    succeeded = [INSParseOperationManager _configUserAfterLogin:user error:&loginError];
                }
 
                if (!succeeded) {
                    [INSParseOperationManager logOut];
                }
            }
        }
        
        return task;
    }] waitUntilFinished];
    
    *error = loginError;
    
    return appleAuthTask;
}

+ (void)logOut {
    [INSParseOperationManager _configUserBeforeLogout];
    [PFUser logOut];
}

+ (void)unsubscribe:(NSError **)error {
    [INSParseOperationManager _unsubscribeUser:[PFUser currentUser] error:error];
    [INSParseOperationManager logOut];
}

+ (void)requestPasswordResetForEmail:(NSString *)email error:(NSError **)error {
    [PFUser requestPasswordResetForEmail:email error:error];
}

#pragma mark Private Methods

+ (BOOL)_configUserAfterLogin:(PFUser *)user error:(NSError **)error {
    // 判断该用户是否被锁定
    if ([user objectForKey:INSUserKeyIsLocked]) {
        *error = [PFErrorUtilities errorWithCode:kINSErrorUserIsLocked message:@"The User is Locked"];
        return NO;
    }
    
    // 判断该用户是否被注销
    if ([user objectForKey:INSUserKeyIsDeleted]) {
        *error = [PFErrorUtilities errorWithCode:kINSErrorUserIsDeleted message:@"The User is Deleted"];
        return NO;
    }
    
    // 提取statisticsInfo
    BOOL succeeded =  [INSParseOperationManager _fetchStatisticsInfoForUser:user error:error];
    
    if (succeeded) {
        succeeded = [INSParseOperationManager _fetchBadgeCountForUser:user error:error];
    }
    
    // 将当前用户和当前设备进行关联
    if (succeeded) {
        succeeded = [INSParseOperationManager linkCurrentInstalltionWithCurrentUser:error];
    }
    
    if (succeeded) {
        succeeded = [INSParseOperationManager _setPreferredLanguageForUser:user error:error];
    }
    
    // 当前Session为激活的session，删除其他过期的Session
    if (succeeded) {
        succeeded = [INSParseOperationManager removeInvalidSessions:error];
    }
    
    return succeeded;
}

+ (BOOL)_configUserAfterSignUp:(PFUser *)user error:(NSError **)error {
    // 激活用户
    BOOL succeeded = [INSParseOperationManager _activeUser:user error:error];
    
    // 生产StatisticsInfo并关联
    if (succeeded) {
        succeeded = [INSParseOperationManager _createStatisticsInfoForUser:user error:error];
    }
    
    // 加载statisticsInfo
    if (succeeded) {
        succeeded = [INSParseOperationManager _fetchStatisticsInfoForUser:user error:error];
    }
    
    if (succeeded) {
        succeeded = [INSParseOperationManager _createBadgeCountForUser:user error:error];
    }
    
    if (succeeded) {
        succeeded = [INSParseOperationManager _fetchBadgeCountForUser:user error:error];
    }
    
    if (succeeded) {
        succeeded = [INSParseOperationManager _setPreferredLanguageForUser:user error:error];
    }
    
    // 将当前用户和当前设备进行关联
    if (succeeded) {
        succeeded = [INSParseOperationManager linkCurrentInstalltionWithCurrentUser:error];
    }    
    
    return succeeded;
}

+ (BOOL)_setPreferredLanguageForUser:(PFUser *)user error:(NSError **)error {
    NSString *preferredLanguage = [[[NSBundle mainBundle] preferredLocalizations] firstObject];
    [user setObject:preferredLanguage forKey:INSUserKeyPreferredLanguage];
    return [user save:error];
}

// 用户退出登录之前，解除登录用户和当前设备的绑定。这样就不会推送和登录用户相关的信息。
+ (void)_configUserBeforeLogout {
    NSError *error = nil;
    [INSParseOperationManager unlinkCurrentInstalltionWithCurrentUser:&error];
    return;
}

+ (BOOL)_activeUser:(PFUser *)user error:(NSError **)error {
    [user setObject:@(NO) forKey:INSUserKeyIsLocked];
    [user setObject:@(NO) forKey:INSUserKeyIsDeleted];
    return [user save:error];
}

+ (BOOL)_unsubscribeUser:(PFUser *)user error:(NSError **)error {
    
    [user setObject:@(YES) forKey:INSUserKeyIsDeleted];
    return [user save:error];
}

+ (BOOL)_createStatisticsInfoForUser:(PFUser *)user error:(NSError **)error {
    INSStatisticsInfo *statisticsInfo = [[INSStatisticsInfo alloc] init];
    
    statisticsInfo.user = user;
    statisticsInfo.profileViews = @(0);
    statisticsInfo.reputation = @(0);
    statisticsInfo.topicCount = @(0);
    statisticsInfo.postCount = @(0);
    statisticsInfo.followerCount = @(0);
    statisticsInfo.followingCount = @(0);
    statisticsInfo.likedCount = @(0);
    
    BOOL succeeded = [statisticsInfo save:error];
    
    if (succeeded) {
        [user setObject:statisticsInfo forKey:INSUserKeyStatisticsInfo];
        return [user save:error];
    } else {
        return NO;
    }
}

+ (BOOL)_fetchStatisticsInfoForUser:(PFUser *)user error:(NSError **)error {
    INSStatisticsInfo *statisticsInfo = [user objectForKey:INSUserKeyStatisticsInfo];
    if (statisticsInfo) {
        return [statisticsInfo fetchIfNeeded:error];
    } else {
        return [INSParseOperationManager _createStatisticsInfoForUser:user error:error];
    }
}

+ (BOOL)_createBadgeCountForUser:(PFUser *)user error:(NSError **)error {
    INSBadgeCount *badgeCount = [[INSBadgeCount alloc] init];
    
    badgeCount.user = user;
    badgeCount.totalCount = @(0);
    badgeCount.commentCount = @(0);
    badgeCount.likeCount = @(0);
    badgeCount.followCount = @(0);
    badgeCount.messageCount = @(0);
    badgeCount.otherCount = @(0);
    
    BOOL succeeded = [badgeCount save:error];
    
    if (succeeded) {
        [user setObject:badgeCount forKey:INSUserKeyBadgeCount];
        return [user save:error];
    } else {
        return NO;
    }
}

+ (BOOL)_fetchBadgeCountForUser:(PFUser *)user error:(NSError **)error {
    INSBadgeCount *badgeCount = [user objectForKey:INSUserKeyBadgeCount];
    if (badgeCount) {
        return [badgeCount fetchIfNeeded:error];
    } else {
        return [INSParseOperationManager _createBadgeCountForUser:user error:error];
    }
}

+ (PFQuery *)deletedOrLockedUserQuery {
    PFQuery *deletedUserQuery = [PFQuery queryWithClassName:PFUserKeyClass];
    [deletedUserQuery whereKey:INSUserKeyIsDeleted equalTo:@(YES)];
    
    PFQuery *lockedUserQuery = [PFQuery queryWithClassName:PFUserKeyClass];
    [lockedUserQuery whereKey:INSUserKeyIsLocked equalTo:@(YES)];
    
    return [PFQuery orQueryWithSubqueries:@[deletedUserQuery, lockedUserQuery]];
}

+ (PFQuery *)buildUserQueryWhereUserIsDeleted {
    PFQuery *query = [PFQuery queryWithClassName:PFUserKeyClass];
    [query whereKey:INSUserKeyIsDeleted equalTo:@(YES)];
    return query;
}

+ (PFQuery *)buildUserQueryWhereUserIsLocked {
    PFQuery *query = [PFQuery queryWithClassName:PFUserKeyClass];
    [query whereKey:INSUserKeyIsLocked equalTo:@(YES)];
    return query;
}

// 绑定用户和设备，重置badge
//+ (BOOL)_linkPushWithUser:(PFUser *)user error:(NSError **)error {
//    [[PFInstallation currentInstallation] setObject:user forKey:@"user"];
//    [[PFInstallation currentInstallation] setBadge:0];
//    return [[PFInstallation currentInstallation] save:error];
//}
//
//// 解除用户和设备绑定，重置badge
//+ (void)_unlinkPushWithUser {
//    [[PFInstallation currentInstallation] removeObjectForKey:@"user"];
//    [[PFInstallation currentInstallation] setBadge:0];
//    [[PFInstallation currentInstallation] saveEventually];
//}

// 一个用户仅允许一个session登录。查询当前用户的其他session，然后删除。
//+ (BOOL)_removeSessions:(PFUser *)user error:(NSError **)error {
//    PFQuery *querySession = [PFQuery queryWithClassName:@"_Session"];
//    [querySession whereKey:@"user" equalTo:user];
//    [querySession whereKey:@"sessionToken" notEqualTo:user.sessionToken];
//
//    NSArray *sessionArray = [querySession findObjects:error];
//
//    if (*error) {
//        return NO;
//    } else {
//        for (NSInteger i = 0; i < sessionArray.count; i++) {
//            PFSession *sessionObject = sessionArray[i];
//            [sessionObject delete:error];
//
//            if (*error) {
//                return NO;
//            }
//        }
//
//        return YES;
//    }
//}

@end
