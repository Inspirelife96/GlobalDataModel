//
//  INSParseOperationManager+Category.m
//  INSParse
//
//  Created by XueFeng Chen on 2022/7/25.
//

#import "INSParseOperationManager+Category.h"

#import "INSCategory.h"

#import "INSParseDefines.h"

@implementation INSParseOperationManager (Category)

+ (INSCategory *)addCategoryWithName:(NSString *)name
                             summary:(NSString *)summary
                 iconImageFileObject:(PFFileObject *)iconImageFileObject
           backgroundImageFileObject:(PFFileObject *)backgroundImageFileObject
                               error:(NSError **)error {
    INSCategory *category = [[INSCategory alloc] init];
    category.name = name;
    category.summary = summary;
    category.iconImageFileObject = iconImageFileObject;
    category.backgroundImageFileObject = iconImageFileObject;
    
    BOOL succeeded = [category save:error];
    
    if (succeeded) {
        return category;
    } else {
        return nil;
    }
}

+ (INSCategory *)findCategoryWithName:(NSString *)name error:(NSError **)error {
    PFQuery *query = [PFQuery queryWithClassName:INSCategoryKeyClass];
    [query whereKey:INSCategoryKeyName equalTo:name];
    
    NSArray<INSCategory *> *categories = [query findObjects:error];
    
    if (*error) {
        return nil;
    } else {
        if (categories.count > 0) {
            return categories[0];
        } else {
            return nil;
        }
    }
}

+ (NSArray<INSCategory *> *)findAllCategories:(NSError **)error {
    PFQuery *query = [PFQuery queryWithClassName:INSCategoryKeyClass];
    return [query findObjects:error];
}

@end
