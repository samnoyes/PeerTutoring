//
//  WriteCommentTableViewCell.h
//  Peer Tutoring
//
//  Created by Samuel Noyes on 7/23/16.
//  Copyright © 2016 Samuel Noyes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionDetailViewController.h"

@interface WriteCommentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property (strong, nonatomic) QuestionDetailViewController *qdvc;
@end
