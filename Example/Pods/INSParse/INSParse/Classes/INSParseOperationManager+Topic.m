//
//  INSParseOperationManager+Topic.m
//  INSParse
//
//  Created by XueFeng Chen on 2021/6/24.
//

#import "INSParseOperationManager+Topic.h"

#import "INSParseDefines.h"

#import "INSTopic.h"

#import "INSParseOperationManager+Block.h"
#import "INSParseOperationManager+User.h"

@implementation INSParseOperationManager (Topic)

// 0 无条件，直接查询Topic表，根据orderBy进行排序，例如查询热门的Topic。
+ (NSArray<INSTopic *> *)findTopicsOrderBy:(NSString *)orderBy page:(NSUInteger)page pageCount:(NSUInteger)pageCount error:(NSError **)error {
    return [INSParseOperationManager findTopicWithCategory:nil tag:nil fromUser:nil orderBy:orderBy page:page pageCount:pageCount error:error];
}

// 1 根据Category查询，一般用来展示某个板块的内容
+ (NSArray<INSTopic *> *)findTopicsWithCategory:(NSString *)category orderBy:(NSString *)orderBy page:(NSUInteger)page pageCount:(NSUInteger)pageCount error:(NSError **)error{
    return [INSParseOperationManager findTopicWithCategory:category tag:nil fromUser:nil orderBy:orderBy page:page pageCount:pageCount error:error];
}

// 2 根据Tag查询，一般用来展示某个标签的内容
+ (NSArray<INSTopic *> *)findTopicsWithTag:(NSString *)tag orderBy:(NSString *)orderBy page:(NSUInteger)page pageCount:(NSUInteger)pageCount error:(NSError **)error {
    return [INSParseOperationManager findTopicWithCategory:nil tag:tag fromUser:nil orderBy:orderBy page:page pageCount:pageCount error:error];
}

// 3 根据fromUser查询，一般用来展示某个用户的内容
+ (NSArray<INSTopic *> *)findTopicsCreatedByUser:(PFUser *)fromUser orderBy:(NSString *)orderBy page:(NSInteger)page pageCount:(NSInteger)pageCount error:(NSError **)error {
    return [INSParseOperationManager findTopicWithCategory:nil tag:nil fromUser:fromUser orderBy:orderBy page:page pageCount:pageCount error:error];
}

// 4 根据关注，一般用来展示用户关注的内容
+ (NSArray<INSTopic *> *)findTopicsFollowedByUser:(PFUser *)fromUser orderBy:(NSString *)orderBy page:(NSInteger)page pageCount:(NSInteger)pageCount error:(NSError **)error {
    
    // 查询公开的Topic
    PFQuery *query = [PFQuery queryWithClassName:INSTopicKeyClass];
    [query whereKey:INSTopicKeyIsDeleted equalTo:@(NO)];
    [query whereKey:INSTopicKeyIsPrivate equalTo:@(NO)];
    [query whereKey:INSTopicKeyIsApproved equalTo:@(YES)];

    // 查询fromUser关注的用户
    PFQuery *followQuery = [PFQuery queryWithClassName:INSFollowKeyClass];
    [followQuery whereKey:INSFollowKeyFromUser equalTo:fromUser];
    
    // 添加条件，Topic的创建者 = fromUser关注的用户
    [query whereKey:INSTopicKeyFromUser matchesKey:INSFollowKeyToUser inQuery:followQuery];
    
    return [INSParseOperationManager _excuteTopicQuery:query orderBy:orderBy page:page pageCount:pageCount error:error];
}

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
                             error:(NSError **)error
{
    INSTopic *topic = [[INSTopic alloc] init];
    topic.isLocked = isLocked;
    topic.isDeleted = isDeleted;
    topic.isPrivate = isPrivate;
    topic.isApproved = isApproved;
    topic.isPopular = isPopular;
    topic.title = title;
    topic.content = content;
    
    if (mediaFileObjects) {
        topic.mediaFileObjects = mediaFileObjects;
        topic.mediaFileType = mediaFileType;
    }
    
    topic.fromUser = fromUser;
    topic.postCount = @0;
    topic.likeCount = @0;
    topic.shareCount = @0;
    
    if (category) {
        topic.category = category;
    }

    if (tags) {
        topic.tags = tags;
    }
    
    BOOL succeeded = [topic save:error];
    
    if (succeeded) {
        return topic;
        //return [INSParseOperationManager addTopicActivity:topic error:error];
    } else {
        return nil;
    }
}

+ (BOOL)updateTopic:(INSTopic *)topic
              title:(NSString * _Nullable)title
            content:(NSString * _Nullable)content
   mediaFileObjects:(NSArray<PFFileObject *> * _Nullable)mediaFileObjects
           category:(NSString * _Nullable)category
               tags:(NSArray<NSString *> * _Nullable)tags
              error:(NSError **)error {
    if (title) {
        topic.title = title;
    }
    
    if (content) {
        topic.content = content;
    }
    
    if (mediaFileObjects) {
        topic.mediaFileObjects = mediaFileObjects;
    }
    
    if (category) {
        topic.category = category;
    }
    
    if (tags) {
        topic.tags = tags;
    }
    
    return [topic save:error];
}

// 管理员可以设置锁定状态
+ (BOOL)updateTopic:(INSTopic *)topic
           isLocked:(BOOL)isLocked error:(NSError **)error {
    topic.isLocked = isLocked;
    
    return [topic save:error];
}

// 管理员或者作者可以设置删除状态
+ (BOOL)updateTopic:(INSTopic *)topic  isDeleted:(BOOL)isDeleted error:(NSError **)error {
    topic.isDeleted = isDeleted;

    return [topic save:error];
}

// 作者可以设置私有状态
+ (BOOL)updateTopic:(INSTopic *)topic isPrivate:(BOOL)isPrivate error:(NSError **)error {
    topic.isPrivate = isPrivate;
    
    return [topic save:error];
}

// 管理员可以设置审核状态
+ (BOOL)updateTopic:(INSTopic *)topic isApproved:(BOOL)isApproved error:(NSError **)error {
    topic.isApproved = isApproved;

    return [topic save:error];
}

// 管理员可以设置置顶状态
+ (BOOL)updateTopic:(INSTopic *)topic isPopular:(BOOL)isPopular error:(NSError **)error {
    topic.isPopular = isPopular;
    
    return [topic save:error];
}

+ (NSArray<INSTopic *> *)findTopicWithCategory:(NSString * _Nullable)category
                                           tag:(NSString * _Nullable)tag
                                      fromUser:(PFUser * _Nullable)fromUser
                                       orderBy:(NSString *)orderBy
                                          page:(NSUInteger)page
                                     pageCount:(NSUInteger)pageCount
                                         error:(NSError **)error
{
    // 查询Topics表
    PFQuery *publicTopicsQuery = [PFQuery queryWithClassName:INSTopicKeyClass];

    // 默认条件1:软删除标记=NO
    [publicTopicsQuery whereKey:INSTopicKeyIsDeleted equalTo:@(NO)];
    
    // 默认条件2:审核标记=YES
    [publicTopicsQuery whereKey:INSTopicKeyIsApproved equalTo:@(YES)];
    
    // 默认条件3:私有标记=NO
    [publicTopicsQuery whereKey:INSTopicKeyIsPrivate equalTo:@(NO)];
    
    // 默认条件4:发布者不能被注销
    PFQuery *deletedUserQuery = [INSParseOperationManager buildUserQueryWhereUserIsDeleted];
    [publicTopicsQuery whereKey:INSTopicKeyFromUser doesNotMatchQuery:deletedUserQuery];

    // 默认条件5:发布者不能被禁止
    PFQuery *lockedUserQuery = [INSParseOperationManager buildUserQueryWhereUserIsLocked];
    [publicTopicsQuery whereKey:INSTopicKeyFromUser doesNotMatchQuery:lockedUserQuery];

    // 输入条件1:如果设置了Category，那么Category必须一致
    if (category) {
        [publicTopicsQuery whereKey:INSTopicKeyCategory equalTo:category];
    }
    
    // 输入条件2:如果设置了Tag，那么Tag必须在Tags中存在。注意INSTopicKeyTags是数组字段
    if (tag) {
        [publicTopicsQuery whereKey:INSTopicKeyTags equalTo:tag];
    }
    
    // 输入条件2:如果设置了fromUser，那么必须符合
    if (fromUser) {
        [publicTopicsQuery whereKey:INSTopicKeyFromUser equalTo:fromUser];
    }
    
    PFQuery *query = publicTopicsQuery;
    
    // 如果是登录用户，那么需要额外的处理
    if ([PFUser currentUser]) {
        // 特殊条件:发布者不能在当前登录用户的黑名单列表中
        PFQuery *blockQuery = [INSParseOperationManager buildBlockQueryWhereFromUserIs:[PFUser currentUser]];
        [publicTopicsQuery whereKey:INSTopicKeyFromUser doesNotMatchKey:INSBlockKeyToUser inQuery:blockQuery];
    }
    
    // 执行Query
    return [INSParseOperationManager _excuteTopicQuery:query orderBy:orderBy page:page pageCount:pageCount error:error];
}

+ (NSArray *)_excuteTopicQuery:(PFQuery *)query orderBy:(nonnull NSString *)orderBy page:(NSInteger)page pageCount:(NSInteger)pageCount error:(NSError **)error {
    [query orderByDescending:orderBy];
    
    [query setSkip:pageCount * page];
    [query setLimit:pageCount];
    
    return [query findObjects:error];
}


+ (PFQuery *)buildTopicQueryWhereFromUserIsBlockedByUser:(PFUser *)user {
    PFQuery *topicQuery = [PFQuery queryWithClassName:INSTopicKeyClass];
    PFQuery *blockQuery = [INSParseOperationManager buildBlockQueryWhereFromUserIs:user];
    [topicQuery whereKey:INSTopicKeyFromUser matchesKey:INSBlockKeyToUser inQuery:blockQuery];
    return topicQuery;
}

+ (PFQuery *)buildTopicQueryWhereFromUserIsDeleted {
    PFQuery *topicQuery = [PFQuery queryWithClassName:INSTopicKeyClass];
    PFQuery *userQuery = [INSParseOperationManager buildUserQueryWhereUserIsDeleted];
    [topicQuery whereKey:INSTopicKeyFromUser matchesQuery:userQuery];
    return topicQuery;
}

+ (PFQuery *)buildTopicQueryWhereFromUserIsLocked {
    PFQuery *topicQuery = [PFQuery queryWithClassName:INSTopicKeyClass];
    PFQuery *userQuery = [INSParseOperationManager buildUserQueryWhereUserIsLocked];
    [topicQuery whereKey:INSTopicKeyFromUser matchesQuery:userQuery];
    return topicQuery;
}

@end
