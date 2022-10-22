//
//  INSPostReport.h
//  INSParse
//
//  Created by XueFeng Chen on 2022/5/5.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@class INSPost;

@interface INSPostReport : PFObject <PFSubclassing>

@property (nonatomic, strong) PFUser *fromUser;
@property (nonatomic, strong) INSPost *toPost;
@property (nonatomic, strong) NSNumber *reason;

@end

NS_ASSUME_NONNULL_END
