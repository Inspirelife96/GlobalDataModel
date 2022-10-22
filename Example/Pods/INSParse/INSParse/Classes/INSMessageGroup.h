//
//  INSMessageGroup.h
//  INSParse
//
//  Created by XueFeng Chen on 2022/5/28.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@class INSMessage;

@interface INSMessageGroup : PFObject <PFSubclassing>

@property (nonatomic, strong) PFUser *fromUser;
@property (nonatomic, strong) PFUser *toUser;
@property (nonatomic, strong) INSMessage *lastMessage;
@property (nonatomic, strong) NSNumber *unreadMessageCount;

@end

NS_ASSUME_NONNULL_END
