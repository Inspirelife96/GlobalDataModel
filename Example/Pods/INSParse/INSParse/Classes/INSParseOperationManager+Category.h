//
//  INSParseOperationManager+Category.h
//  INSParse
//
//  Created by XueFeng Chen on 2022/7/25.
//

#import "INSParseOperationManager.h"

NS_ASSUME_NONNULL_BEGIN

@class INSCategory;

@interface INSParseOperationManager (Category)

+ (INSCategory *)addCategoryWithName:(NSString *)name
                             summary:(NSString *)summary
                 iconImageFileObject:(PFFileObject *)iconImageFileObject
           backgroundImageFileObject:(PFFileObject *)backgroundImageFileObject
                               error:(NSError **)error;

+ (INSCategory *)findCategoryWithName:(NSString *)name error:(NSError **)error;

+ (NSArray<INSCategory *> *)findAllCategories:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
