//
//  Comment.h
//  Peer Tutoring
//
//  Created by Samuel Noyes on 7/22/16.
//  Copyright © 2016 Samuel Noyes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Question.h"

@interface Comment : NSObject
@property (strong, nonatomic) NSString *commentText;
@property (strong, nonatomic) NSString *author;
@property (strong, nonatomic) NSDate *creationDate;
@property (nonatomic) NSInteger postID;
- (id) initWithDictionary: (NSDictionary *) dict;
- (id) initWithText: (NSString *) t postID: (NSInteger) ID author: (NSString *) author;
@end
