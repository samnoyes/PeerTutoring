//
//  Question.h
//  Peer Tutoring
//
//  Created by Samuel Noyes on 7/22/16.
//  Copyright © 2016 Samuel Noyes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Comment.h"

@interface Question : NSObject
@property (strong, nonatomic) NSString *questionTitle;
@property (strong, nonatomic) NSString *questionDetails;
@property (strong, nonatomic) NSString *author;
@property (strong, nonatomic) NSString *subject;
@property (strong, nonatomic) NSDate *creationDate;
@property (nonatomic) NSInteger ID;
@property (nonatomic) NSInteger votes;
@property (strong, nonatomic) NSArray<Comment *> *comments;
- (id) initWithDictionary: (NSDictionary *) dict;
- (void) reloadCommentsWithCompletion: (void (^)()) completion;
- (id) initNewQuestionWithTitle: (NSString *) title details: (NSString *) t author: (NSString *) a subject: (NSString *) s;
@end
