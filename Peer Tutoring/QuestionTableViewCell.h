//
//  QuestionTableViewCell.h
//  Peer Tutoring
//
//  Created by Samuel Noyes on 7/21/16.
//  Copyright © 2016 Samuel Noyes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Question.h"

@interface QuestionTableViewCell : UITableViewCell
- (void) setQuestionText:(NSString *) t;
- (void) setSubjectText: (NSString *) t;
- (void) setAuthorText: (NSString *) t;
@property (weak, nonatomic) IBOutlet UITextView *questionTextView;
@property (strong, nonatomic) Question *question;
@end
