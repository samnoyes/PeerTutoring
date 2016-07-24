//
//  AskQuestionViewController.h
//  Peer Tutoring
//
//  Created by Samuel Noyes on 7/23/16.
//  Copyright © 2016 Samuel Noyes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewController.h"

@interface AskQuestionViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate>
@property (strong, nonatomic) UITableViewController *tvc;
@end
