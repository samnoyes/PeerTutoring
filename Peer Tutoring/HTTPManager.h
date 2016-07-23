//
//  HTTPManager.h
//  Peer Tutoring
//
//  Created by Samuel Noyes on 7/22/16.
//  Copyright © 2016 Samuel Noyes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Comment.h"
#import "Question.h"

@interface HTTPManager : NSObject
+ (void) getCommentsWithPostID: (NSInteger) ID completion: (void (^)(NSArray<Comment *> *result)) completion;
+ (void) getQuestionsWithCompletion: (void (^)(NSArray<Question *> *result)) completion;
+ (void) postComment: (Comment *) c completion: (void (^)(BOOL success)) completion;
@end
