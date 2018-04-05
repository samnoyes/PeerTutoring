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
    //if ([cell.subjectLabel.text isEqualToString:@"Subject"])
    [cell.subjectLabel setText:[[AskQuestionViewController subjectArray] objectAtIndex: indexPath.row]];
    if ([self.selectedSubjects containsObject:[[AskQuestionViewController subjectArray] objectAtIndex: indexPath.row]]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[AskQuestionViewController subjectArray] count];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SubjectTableViewCell *cell = (SubjectTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [self.selectedSubjects removeObject:[[AskQuestionViewController subjectArray] objectAtIndex: indexPath.row]];
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.selectedSubjects addObject:[[AskQuestionViewController subjectArray] objectAtIndex: indexPath.row]];
    }
    //[tableView reloadRowsAtIndexPaths: [NSArray arrayWithObject: indexPath]
                    // withRowAnimation: UITableViewRowAnimationNone];
    NSLog(@"Selected array is %@", self.selectedSubjects);
}

- (NSArray<NSString *> *) selectedSubjects {
    if (!_selectedSubjects) {
        _selectedSubjects = [[NSMutableArray alloc] init];
    }
    return _selectedSubjects;
}
//    NSArray *indexPathArray = [self.tableView indexPathsForSelectedRows];
//    NSMutableArray<NSString *> *subjects = [[NSMutableArray alloc] init];
//    for(NSIndexPath *index in indexPathArray)
//    {
//        NSString *subject = [[AskQuestionViewController subjectArray] objectAtIndex:index.row];
//        [subjects addObject:subject];
//    }
//    NSLog(@"Hello from inside filter view.  Here's the selected subjects: %@\nHere's the index paths: %@", subjects, indexPathArray);
//    return [subjects copy];
//}

@end
