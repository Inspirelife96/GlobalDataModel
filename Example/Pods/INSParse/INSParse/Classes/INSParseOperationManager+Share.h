//
//  INSParseOperationManager+Share.h
//  INSParse
//
//  Created by XueFeng Chen on 2021/6/24.
//

#import "INSParseOperationManager.h"

@class INSTopic;

NS_ASSUME_NONNULL_BEGIN

@interface INSParseOperationManager (Share)

// Share表添加

// Share表的内容不做删除，不激活Activity。

+ (BOOL)addShareTopic:(INSTopic *)Topic
             fromUser:(PFUser *)fromUser
           toPlatform:(NSString *)toPlatform
                error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
