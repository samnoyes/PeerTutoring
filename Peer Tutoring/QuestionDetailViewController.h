//
//  QuestionDetailViewController.h
//  Peer Tutoring
//
//  Created by Samuel Noyes on 7/22/16.
//  Copyright © 2016 Samuel Noyes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Question.h"

@interface QuestionDetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *subjectLabel;
@property (weak, nonatomic) IBOutlet UITextView *questionTitleView;
@property (weak, nonatomic) IBOutlet UITextView *questionDetailsView;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (strong, nonatomic) Question *question;
- (void) updateView;
@end
