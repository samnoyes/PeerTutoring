//
//  Comment.m
//  Peer Tutoring
//
//  Created by Samuel Noyes on 7/22/16.
//  Copyright © 2016 Samuel Noyes. All rights reserved.
//

#import "Comment.h"
#import "HTTPManager.h"

@implementation Comment

- (id) initWithDictionary: (NSDictionary *) dict {
    self = [super init];
    if (self) {
        self.commentText = [dict objectForKey: @"Text"];
        self.author = [dict objectForKey: @"Author"];
        self.postID = [[dict objectForKey: @"postID"] intValue];
        NSTimeInterval seconds = [[dict objectForKey: @"Time"] doubleValue];
        self.creationDate = [[NSDate alloc] initWithTimeIntervalSince1970:seconds];
    }
    return self;
}

- (id) initNewCommentWithText: (NSString *) t postID: (NSInteger) ID author: (NSString *) author {
    self = [super init];
    if (self) {
        self.commentText = t;
        self.author = author;
        self.postID = ID;
        self.creationDate = [NSDate date];
    }
    return self;
}

- (NSString *) description {
    return self.commentText;
}

@end
