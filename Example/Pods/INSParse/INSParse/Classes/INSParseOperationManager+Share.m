//
//  INSParseOperationManager+Share.m
//  INSParse
//
//  Created by XueFeng Chen on 2021/6/24.
//

#import "INSParseOperationManager+Share.h"

#import "INSParseDefines.h"
#import "INSShare.h"

@implementation INSParseOperationManager (Share)

+ (BOOL)addShareTopic:(INSTopic *)Topic
             fromUser:(PFUser *)fromUser
           toPlatform:(NSString *)toPlatform
                error:(NSError **)error {
    INSShare *share = [[INSShare alloc] init];

    share.fromUser = fromUser;
    share.topic = Topic;
    share.toPlatform = toPlatform;
    
    return [share save:error];
//
//    BOOL succeeded = [share save:error];
//
//    if (succeeded) {
//        return [INSParseOperationManager addShareActivity:share error:error];
//    } else {
//        return succeeded;
//    }
}

@end
