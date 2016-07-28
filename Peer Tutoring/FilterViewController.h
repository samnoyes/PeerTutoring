//
//  FilterViewController.h
//  Peer Tutoring
//
//  Created by Samuel Noyes on 7/28/16.
//  Copyright © 2016 Samuel Noyes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>
//@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray<NSString *> *selectedSubjects;
@end
