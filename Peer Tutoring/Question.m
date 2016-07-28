//
//  Question.m
//  Peer Tutoring
//
//  Created by Samuel Noyes on 7/22/16.
//  Copyright © 2016 Samuel Noyes. All rights reserved.
//

#import "Question.h"
#import "HTTPManager.h"

@implementation Question

- (id) initWithDictionary: (NSDictionary *) dict {
    self = [super init];
    if (self) {
        self.questionText = [dict objectForKey: @"Text"];
        self.author = [dict objectForKey: @"Author"];
        self.subject = [dict objectForKey: @"Subject"];
        self.ID = [[dict objectForKey: @"ID"] intValue];
        NSTimeInterval seconds = [[dict objectForKey: @"Time"] doubleValue];
        self.creationDate = [[NSDate alloc] initWithTimeIntervalSince1970:seconds];
        [HTTPManager getCommentsWithPostID: self.ID completion: ^(NSArray<Comment *> *result){
            self.comments = result;
        }];
    }
    return self;
}

- (id) initNewQuestionWithText: (NSString *) t author: (NSString *) a subject: (NSString *) s {
    self = [super init];
    if (self) {
        self.questionText = t;
        self.author = a;
        self.subject = s;
    }
    return self;
}

- (void) reloadCommentsWithCompletion: (void (^)()) completion {
    [HTTPManager getCommentsWithPostID: self.ID completion: ^(NSArray<Comment *> *result){
            self.comments = result;
            completion();
        }];
}

- (NSString *) description {
    return self.questionText;
}
@end
