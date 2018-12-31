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
- (void) setQuestionTitle:(NSString *) t;
- (void) setSubjectText: (NSString *) t;
- (void) setAuthorText: (NSString *) t;
@property (weak, nonatomic) IBOutlet UITextView *questionTitleView;
@property (strong, nonatomic) Question *question;
@end
