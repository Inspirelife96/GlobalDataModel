//
//  INSParseOperationManager+Post.h
//  INSParse
//
//  Created by XueFeng Chen on 2021/6/24.
//

#import "INSParseOperationManager.h"

@class INSCategory;
@class INSTopic;
@class INSPost;
@class INSReply;
@class PFUser;

NS_ASSUME_NONNULL_BEGIN

@interface INSParseOperationManager (Post)

// - 查询某一个Topic的回帖
+ (NSArray <INSPost *> *)findPostsToTopic:(INSTopic *)toTopic
                                  orderBy:(NSString *)orderBy
                                     page:(NSInteger)page
                                pageCount:(NSInteger)pageCount
                                    error:(NSError **)error;

// - 查询某一个Topic下某个人的所有回贴 - 例如：即只看楼主的功能
+ (NSArray <INSPost *> *)findPostsToTopic:(INSTopic *)toTopic
                                 fromUser:(PFUser *)fromUser
                                  orderBy:(NSString *)orderBy
                                     page:(NSInteger)page
                                pageCount:(NSInteger)pageCount
                                    error:(NSError **)error;

// Post表添加
+ (INSPost *)addPostWithIsApproved:(BOOL)isApproved
                  isDeleted:(BOOL)isDeleted
                    content:(NSString *)content
           mediaFileObjects:(NSArray<PFFileObject *> * _Nullable)mediaFileObjects
                     mediaFileType:(NSString *)mediaFileType
                   fromUser:(PFUser *)fromUser
                    toTopic:(INSTopic *)toTopic
                      error:(NSError **)error;

// 更新

// 用户编辑Post的内容
+ (BOOL)updatePost:(INSPost *)post
           content:(NSString * _Nullable)content
  mediaFileObjects:(NSArray<PFFileObject *> * _Nullable)mediaFileObjects
             reply:(NSArray<INSReply *> * _Nullable)replies
             error:(NSError **)error;

//// 管理员可以设置锁定状态
//+ (BOOL)updatePost:(INSPost *)post isLocked:(BOOL)isLocked error:(NSError **)error;

// 管理员或者作者可以设置删除状态
+ (BOOL)updatePost:(INSPost *)post isDeleted:(BOOL)isDeleted error:(NSError **)error;

// 管理员可以设置审核状态
+ (BOOL)updatePost:(INSPost *)post isApproved:(BOOL)isApproved error:(NSError **)error;

// 辅助
+ (PFQuery *)buildPostQueryWhereFromUserIsBlockedByUser:(PFUser *)user;

+ (PFQuery *)buildPostQueryWhereFromUserIsDeleted;

+ (PFQuery *)buildPostQueryWhereFromUserIsLocked;

@end

NS_ASSUME_NONNULL_END
