//
//  INSParseOperationManager+PostLike.h
//  INSParse
//
//  Created by XueFeng Chen on 2022/7/17.
//

#import "INSParseOperationManager.h"

@class INSPost;
@class INSPostLike;

NS_ASSUME_NONNULL_BEGIN

@interface INSParseOperationManager (PostLike)

// 判断用户是否喜欢这个Post
+ (BOOL)isPost:(INSPost *)post likedbyUser:(PFUser *)user error:(NSError **)error;

// 添加
+ (INSPostLike *)addPostLikeWithFromUser:(PFUser *)fromUser toPost:(INSPost *)toPost error:(NSError **)error;

// 删除
+ (BOOL)deletePostLike:(INSPostLike *)postLike error:(NSError **)error;
+ (BOOL)deletePostLikeFromUser:(PFUser *)fromUser toPost:(INSPost *)toPost error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
