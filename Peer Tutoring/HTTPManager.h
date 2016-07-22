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
+ (NSArray<Comment *> *) getCommentsWithPostID: (NSInteger) ID;
+ (NSArray<Question *> *) getQuestions;

@end
