//
//  INSParseOperationManager+Topic.h
//  INSParse
//
//  Created by XueFeng Chen on 2021/6/24.
//

#import "INSParseOperationManager.h"

@class INSTopic;
@class INSCategory;
@class INSTag;

NS_ASSUME_NONNULL_BEGIN

@interface INSParseOperationManager (Topic)

// 查询API

// 0 无条件，直接查询Topic表，根据orderBy进行排序，例如查询热门的Topic。
+ (NSArray<INSTopic *> *)findTopicsOrderBy:(NSString *)orderBy
                                      page:(NSUInteger)page
                                 pageCount:(NSUInteger)pageCount
                                     error:(NSError **)error;

// 1 根据Category查询，一般用来展示某个板块的内容
+ (NSArray<INSTopic *> *)findTopicsWithCategory:(NSString *)category
                                        orderBy:(NSString *)orderBy
                                           page:(NSUInteger)page
                                      pageCount:(NSUInteger)pageCount
                                          error:(NSError **)error;

// 2 根据Tag查询，一般用来展示某个标签的内容
+ (NSArray<INSTopic *> *)findTopicsWithTag:(NSString *)tag
                                   orderBy:(NSString *)orderBy
                                      page:(NSUInteger)page
                                 pageCount:(NSUInteger)pageCount
                                     error:(NSError **)error;

// 3 根据fromUser查询，一般用来展示某个用户的内容
+ (NSArray<INSTopic *> *)findTopicsCreatedByUser:(PFUser *)fromUser
                                         orderBy:(NSString *)orderBy
                                            page:(NSInteger)page
                                       pageCount:(NSInteger)pageCount
                                           error:(NSError **)error;

// 4 根据关注，一般用来展示用户关注的内容
+ (NSArray<INSTopic *> *)findTopicsFollowedByUser:(PFUser *)fromUser
                                          orderBy:(NSString *)orderBy
                                             page:(NSInteger)page
                                        pageCount:(NSInteger)pageCount
                                            error:(NSError **)error;

// 添加
+ (INSTopic *)addTopicWithIsLocked:(BOOL)isLocked
                         isDeleted:(BOOL)isDeleted
                         isPrivate:(BOOL)isPrivate
                        isApproved:(BOOL)isApproved
                         isPopular:(BOOL)isPopular
                             title:(NSString *)title
                           content:(NSString *)content
                  mediaFileObjects:(NSArray<PFFileObject *> * _Nullable)mediaFileObjects
                     mediaFileType:(NSString *)mediaFileType
                          fromUser:(PFUser *)fromUser
                          category:(NSString * _Nullable)category
                              tags:(NSArray<NSString *> * _Nullable)tags
                             error:(NSError **)error;

// 更新

// 用户编辑Topic的内容
+ (BOOL)updateTopic:(INSTopic *)topic
              title:(NSString * _Nullable)title
            content:(NSString * _Nullable)content
   mediaFileObjects:(NSArray<PFFileObject *> * _Nullable)mediaFileObjects
           category:(NSString * _Nullable)category
               tags:(NSArray<NSString *> * _Nullable)tags
              error:(NSError **)error;

// 作者可以设置锁定状态
+ (BOOL)updateTopic:(INSTopic *)topic
           isLocked:(BOOL)isLocked error:(NSError **)error;

// 管理员或者作者可以设置删除状态
+ (BOOL)updateTopic:(INSTopic *)topic  isDeleted:(BOOL)isDeleted error:(NSError **)error;

// 作者可以设置私有状态
+ (BOOL)updateTopic:(INSTopic *)topic isPrivate:(BOOL)isPrivate error:(NSError **)error;

// 管理员可以设置审核状态
+ (BOOL)updateTopic:(INSTopic *)topic isApproved:(BOOL)isApproved error:(NSError **)error;

// 管理员可以设置置顶状态
+ (BOOL)updateTopic:(INSTopic *)topic isPopular:(BOOL)isPopular error:(NSError **)error;


// 辅助
+ (PFQuery *)buildTopicQueryWhereFromUserIsBlockedByUser:(PFUser *)user;

+ (PFQuery *)buildTopicQueryWhereFromUserIsDeleted;

+ (PFQuery *)buildTopicQueryWhereFromUserIsLocked;

@end

NS_ASSUME_NONNULL_END
