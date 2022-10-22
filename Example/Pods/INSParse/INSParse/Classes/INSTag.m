//
//  INSTag.m
//  INSParse
//
//  Created by XueFeng Chen on 2022/4/19.
//

#import "INSTag.h"

#import "INSParseDefines.h"

@implementation INSTag

@dynamic name;

+ (NSString *)parseClassName {
    return INSTagKeyClass;
}

@end
