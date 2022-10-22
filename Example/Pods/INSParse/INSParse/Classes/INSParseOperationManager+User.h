//
//  INSParseOperationManager+User.h
//  INSParse
//
//  Created by XueFeng Chen on 2021/6/24.
//

#import "INSParseOperationManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface INSParseOperationManager (User)

/**
 登录

 可以由error判断登录是否成功
 登录成功后可以调用[PFUser currentUser]获取当前的登录用户

 @param userName 用户名
 @param password 密码
 @param error 出错信息
 */
+ (void)logInWithUsername:(NSString *)userName password:(NSString *)password error:(NSError **)error;

+ (BFTask *)loginWithAppleAuthType:(NSString *)authType authData:(NSDictionary<NSString *, NSString *> *)authData username:(NSString *)userName email:(NSString *)email error:(NSError **)error;

+ (void)logInWithAnonymous:(NSError **)error;

+ (void)upgradeAnonymousUser:(PFUser *)user withUsername:(NSString *)userName password:(NSString *)password email:(NSString *)email error:(NSError **)error;

+ (void)signUpWithUsername:(NSString *)userName password:(NSString *)password email:(NSString *)email error:(NSError **)error;

+ (void)logOut;

+ (void)requestPasswordResetForEmail:(NSString *)email error:(NSError **)error;

+ (void)unsubscribe:(NSError **)error;

+ (void)setPreferredLanguage:(NSString *)preferredLanguage error:(NSError **)error;

+ (PFQuery *)buildUserQueryWhereUserIsDeleted;

+ (PFQuery *)buildUserQueryWhereUserIsLocked;

@end

NS_ASSUME_NONNULL_END
