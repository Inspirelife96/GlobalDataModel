//
//  INSReplyLike.h
//  INSParse
//
//  Created by XueFeng Chen on 2022/5/3.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@class INSReply;

@interface INSReplyLike : PFObject <PFSubclassing>

@property (nonatomic, strong) PFUser *fromUser;
@property (nonatomic, strong) INSReply *toReply;
@property (nonatomic, assign) BOOL isDeleted;

@end

NS_ASSUME_NONNULL_END
