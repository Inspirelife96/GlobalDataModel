//
//  INSCategory.m
//  INSParse
//
//  Created by XueFeng Chen on 2022/4/19.
//

#import "INSCategory.h"

#import "INSParseDefines.h"

@implementation INSCategory

@dynamic name;
@dynamic summary;
@dynamic iconImageFileObject;
@dynamic backgroundImageFileObject;

+ (NSString *)parseClassName {
    return INSCategoryKeyClass;
}

@end
