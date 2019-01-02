//
//  AskQuestionViewController.h
//  Peer Tutoring
//
//  Created by Samuel Noyes on 7/23/16.
//  Copyright © 2016 Samuel Noyes. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TableViewController;

@interface AskQuestionViewController : UITableViewController <UITextViewDelegate, UITextFieldDelegate>
@property (strong, nonatomic) TableViewController *tvc;
+ (NSArray *) subjectArray;
@end
