//
//  ViewController.h
//  Peer Tutoring
//
//  Created by Samuel Noyes on 7/19/16.
//  Copyright © 2016 Samuel Noyes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Question.h"

@interface TableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, UIPopoverPresentationControllerDelegate>

@property (strong, nonatomic) NSMutableArray<Question *> *questions;
@property (strong, nonatomic) NSArray<NSString *> *filteredSubjects;
@property (nonatomic) BOOL noMoreQuestions;
-(void) updateView;
@end

