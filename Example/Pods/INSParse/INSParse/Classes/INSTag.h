//
//  INSTag.h
//  INSParse
//
//  Created by XueFeng Chen on 2022/4/19.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface INSTag : PFObject <PFSubclassing>

@property (nonatomic, strong) NSString *name;

@end

NS_ASSUME_NONNULL_END
