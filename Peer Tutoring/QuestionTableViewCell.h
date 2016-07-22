//
//  QuestionTableViewCell.h
//  Peer Tutoring
//
//  Created by Samuel Noyes on 7/21/16.
//  Copyright © 2016 Samuel Noyes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionTableViewCell : UITableViewCell
- (void) setQuestionText:(NSString *) t;
- (void) setSubjectText: (NSString *) t;
- (void) setAuthorText: (NSString *) t;
@end
