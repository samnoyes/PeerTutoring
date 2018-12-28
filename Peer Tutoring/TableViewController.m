//
//  ViewController.m
//  Peer Tutoring
//
//  Created by Samuel Noyes on 7/19/16.
//  Copyright © 2016 Samuel Noyes. All rights reserved.
//

#import "TableViewController.h"
#import "QuestionTableViewCell.h"
#import "HTTPManager.h"
#import "QuestionDetailViewController.h"
#import "AskQuestionViewController.h"
#import "GlobalVals.h"
#import "FilterViewController.h"


@interface TableViewController ()
@property (nonatomic) BOOL needsNewBatch;//if we should get a new batch of questions from the server or not
@property (strong, nonatomic) FilterViewController *popoverVC;
@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.needsNewBatch = NO;
    [self updateView];
    
    self.popoverVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"filterViewController"];
    //NSLog(@"View did load.");
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated {
    self.navigationController.navigationBar.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
    self.navigationController.navigationBar.tintAdjustmentMode = UIViewTintAdjustmentModeAutomatic;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.questions count]+1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[self tableView:self.tableView cellForRowAtIndexPath:indexPath] isKindOfClass: [QuestionTableViewCell class]]) {
        QuestionTableViewCell *cell = (QuestionTableViewCell *)[self tableView:self.tableView cellForRowAtIndexPath:indexPath];
        return cell.questionTextView.contentSize.height + 100;
    }
    return [super tableView:self.tableView heightForRowAtIndexPath:indexPath];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [self.questions count]) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"defaultCell"];
        if (cell==nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"defaultCell"];
            cell.userInteractionEnabled = NO;
        }
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [spinner setCenter:CGPointMake(cell.frame.size.width/2, [super tableView:self.tableView heightForRowAtIndexPath:indexPath]/2)];
        [spinner setColor:[UIColor grayColor]];
        [cell addSubview:spinner]; // spinner is not visible until started
        [spinner startAnimating];
        return cell;
    }
    QuestionTableViewCell *cell = (QuestionTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"questionCell"];
    [cell setAuthorText:[self.questions objectAtIndex:indexPath.row].author];
    [cell setQuestionText:[self.questions objectAtIndex:indexPath.row].questionTitle];
    [cell setSubjectText:[self.questions objectAtIndex:indexPath.row].subject];
    cell.question = [self.questions objectAtIndex:indexPath.row];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (![[self tableView:self.tableView cellForRowAtIndexPath:indexPath].reuseIdentifier isEqualToString:@"defaultCell"]) {
        QuestionDetailViewController *vc = (QuestionDetailViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"questionDetail"];
        vc.question = [self.questions objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue destinationViewController] isKindOfClass:[AskQuestionViewController class]]) {
        ((AskQuestionViewController *)[segue destinationViewController]).tvc = self;
    }
}

- (void) updateView {
    if (!self.filteredSubjects || self.filteredSubjects.count == 0) {
        [HTTPManager getQuestionBatchWithOffset:self.questions.count completion: ^(NSArray<Question *> *response){
            
            if (response.count>0) {
                NSLog(@"Getting the question batch and adding to questions.");
                self.needsNewBatch = YES;
                if (!self.questions) {
                    self.questions = [[NSMutableArray alloc] init];
                }
                [self.questions addObjectsFromArray:response];
                [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
            }
            else {
                self.noMoreQuestions = YES;
            }
        }];
    }
    else {
        NSLog(@"Questions: %@\nCurrent question count is %lu",self.filteredSubjects,(unsigned long)self.questions.count);
        [HTTPManager getQuestionBatchWithSubjects: self.filteredSubjects offset: self.questions.count completion: ^(NSArray<Question *> *response){
            self.needsNewBatch = YES;
            [self.questions addObjectsFromArray:response];
            [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
            if ([response count] == 0) {
                self.noMoreQuestions = YES;
            }
        }];
    }
}

- (UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![[self tableView:self.tableView cellForRowAtIndexPath:indexPath].reuseIdentifier isEqualToString:@"defaultCell"]) {
        QuestionTableViewCell *cell = (QuestionTableViewCell *)[self tableView:self.tableView cellForRowAtIndexPath:indexPath];
        if ([cell.question.author isEqualToString: [GlobalVals sharedGlobalVals].fullName]) {
            return UITableViewCellEditingStyleDelete;
        }
        else {
            return UITableViewCellEditingStyleNone;
        }
    }
    else return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    QuestionTableViewCell *cell = (QuestionTableViewCell *)[self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.questions removeObjectAtIndex:indexPath.row];
        [tableView reloadData]; // tell table to refresh now
        [HTTPManager deleteQuestion:cell.question completion:nil];
    }
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.tableView.contentOffset.y >= self.tableView.contentSize.height-self.view.frame.size.height-30 && self.needsNewBatch && !self.noMoreQuestions) {
        NSLog(@"Is this it?  Are we at the bottom?");
        self.needsNewBatch = NO;
        [self updateView];
    }
}
- (IBAction)showFilterDetail:(id)sender {
    self.popoverVC.modalPresentationStyle = UIModalPresentationPopover;
    self.popoverVC.popoverPresentationController.sourceView = self.view;
    self.popoverVC.popoverPresentationController.barButtonItem = sender;
    self.popoverVC.popoverPresentationController.delegate = self;
    
    [self presentViewController:self.popoverVC animated:YES completion:nil];
    NSLog(@"Adding view");
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller traitCollection:(UITraitCollection *)traitCollection {
    // This method is called in iOS 8.3 or later regardless of trait collection, in which case use the original presentation style (UIModalPresentationNone signals no adaptation)
    return UIModalPresentationNone;
}

- (void) popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
    NSLog(@"You dismissed");
    self.questions = [[NSMutableArray alloc] init];
    self.filteredSubjects = [self.popoverVC.selectedSubjects copy];
    self.noMoreQuestions = NO;
    [self updateView];
}

@end
