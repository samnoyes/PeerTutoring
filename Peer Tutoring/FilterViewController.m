//
//  FilterViewController.m
//  Peer Tutoring
//
//  Created by Samuel Noyes on 7/28/16.
//  Copyright © 2016 Samuel Noyes. All rights reserved.
//

#import "FilterViewController.h"
#import "AskQuestionViewController.h"
#import "SubjectTableViewCell.h"

@implementation FilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView setFrame: self.popoverPresentationController.containerView.frame];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SubjectTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"subjectCell"];
    if ([cell.subjectLabel.text isEqualToString:@"Subject"])
        [cell.subjectLabel setText:[[AskQuestionViewController subjectArray] objectAtIndex: indexPath.row]];
    //cell.accessoryType = UITableViewCellAccessoryCheckmark;
    return cell;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[AskQuestionViewController subjectArray] count];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SubjectTableViewCell *cell = (SubjectTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    //[tableView reloadRowsAtIndexPaths: [NSArray arrayWithObject: indexPath]
                    // withRowAnimation: UITableViewRowAnimationNone];
    NSLog(@"Selected");
}

- (NSArray<NSString *> *) selectedSubjects {
    NSArray *indexPathArray = [self.tableView indexPathsForSelectedRows];
    NSMutableArray<NSString *> *subjects = [[NSMutableArray alloc] init];
    for(NSIndexPath *index in indexPathArray)
    {
        NSString *subject = [[AskQuestionViewController subjectArray] objectAtIndex:index.row];
        [subjects addObject:subject];
    }
    return [subjects copy];
}

@end
