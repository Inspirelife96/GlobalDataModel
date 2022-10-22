//
//  INSParseOperationManager+Follow.h
//  INSParse
//
//  Created by XueFeng Chen on 2021/6/24.
//

#import "INSParseOperationManager.h"

NS_ASSUME_NONNULL_BEGIN

@class INSFollow;

@interface INSParseOperationManager (Follow)

// Follow表查询

// 查找user的粉丝
+ (NSArray <PFUser *> *)findFollower:(PFUser *)user
                                page:(NSInteger)page
                           pageCount:(NSInteger)pageCount
                               error:(NSError **)error;
// 查找user的关注
+ (NSArray <PFUser *> *)findFollowing:(PFUser *)user
                                 page:(NSInteger)page
                            pageCount:(NSInteger)pageCount
                                error:(NSError **)error;

// 查询fromUser是否关注了toUser
+ (BOOL)isFollowFromUser:(PFUser *)fromUser toUser:(PFUser *)toUser error:(NSError **)error;

// Follow表添加
+ (INSFollow *)addFollowFromUser:(PFUser *)fromUser toUser:(PFUser *)toUser error:(NSError **)error;

// Follow表删除
+ (BOOL)deleteFollowFromUser:(PFUser *)fromUser toUser:(PFUser *)toUser error:(NSError **)error;
+ (BOOL)deleteFollow:(INSFollow *)follow error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
