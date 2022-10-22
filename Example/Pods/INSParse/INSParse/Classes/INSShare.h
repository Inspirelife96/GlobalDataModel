//
//  INSShare.h
//  INSParse
//
//  Created by XueFeng Chen on 2021/6/22.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@class INSTopic;

@interface INSShare : PFObject <PFSubclassing>

@property (nonatomic, strong) INSTopic *topic;
@property (nonatomic, strong) PFUser *fromUser;
@property (nonatomic, copy) NSString *toPlatform;

@end

NS_ASSUME_NONNULL_END
