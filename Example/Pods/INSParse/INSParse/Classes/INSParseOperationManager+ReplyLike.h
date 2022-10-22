//
//  INSParseOperationManager+ReplyLike.h
//  INSParse
//
//  Created by XueFeng Chen on 2022/7/17.
//

#import "INSParseOperationManager.h"

NS_ASSUME_NONNULL_BEGIN

@class INSReply;
@class INSReplyLike;

@interface INSParseOperationManager (ReplyLike)

// 判断用户是否喜欢这个Reply
+ (BOOL)isReply:(INSReply *)reply likedbyUser:(PFUser *)user error:(NSError **)error;

// 添加
+ (INSReplyLike *)addReplyLikeWithFromUser:(PFUser *)fromUser toReply:(INSReply *)toReply error:(NSError **)error;

// 删除
+ (BOOL)deleteReplyLike:(INSReplyLike *)replyLike error:(NSError **)error;
+ (BOOL)deleteReplyLikeFromUser:(PFUser *)fromUser toReply:(INSReply *)toReply error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
