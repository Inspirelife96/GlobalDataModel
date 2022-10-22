//
//  INSParseOperationManager+Block.m
//  INSParse
//
//  Created by XueFeng Chen on 2022/7/21.
//

#import "INSParseOperationManager+Block.h"

#import "INSParseDefines.h"

#import "INSBlock.h"

@implementation INSParseOperationManager (Block)

+ (INSBlock *)addBlockFromUser:(PFUser *)fromUser toUser:(PFUser *)toUser error:(NSError **)error {
    INSBlock *block = [[INSBlock alloc] init];
    block.fromUser = fromUser;
    block.toUser = toUser;
    
    BOOL succeeded = [block save:error];
    
    if (succeeded) {
        return block;
    } else {
        return nil;
    }
}

+ (PFQuery *)buildBlockQueryWhereFromUserIs:(PFUser *)user {
    PFQuery *query = [PFQuery queryWithClassName:INSBlockKeyClass];
    [query whereKey:INSBlockKeyFromUser equalTo:user];
    return query;
}

@end
