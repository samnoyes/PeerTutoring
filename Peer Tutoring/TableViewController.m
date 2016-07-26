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


@interface ViewController ()
@property (strong, nonatomic) NSArray<Question *> *questions;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self updateView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.questions count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    QuestionTableViewCell *cell = (QuestionTableViewCell *)[self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    return cell.questionTextView.contentSize.height + 100;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [self.questions count]) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"defaultCell"];
        if (cell==nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"defaultCell"];
            spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            [spinner setCenter:CGPointMake(cell.frame.size.width/2, cell.frame.size.height/2)];
            [cell addSubview:spinner]; // spinner is not visible until started
            [spinner startAnimating];
            return cell;
        }
    }
    QuestionTableViewCell *cell = (QuestionTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"questionCell"];
    [cell setAuthorText:[self.questions objectAtIndex:indexPath.row].author];
    [cell setQuestionText:[self.questions objectAtIndex:indexPath.row].questionText];
    [cell setSubjectText:[self.questions objectAtIndex:indexPath.row].subject];
    cell.question = [self.questions objectAtIndex:indexPath.row];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    QuestionDetailViewController *vc = (QuestionDetailViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"questionDetail"];
    vc.question = [self.questions objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue destinationViewController] isKindOfClass:[AskQuestionViewController class]]) {
        ((AskQuestionViewController *)[segue destinationViewController]).tvc = self;
    }
}

- (void) updateView {
    [HTTPManager getQuestionsWithCompletion: ^(NSArray<Question *> *response){
        self.questions = response;
        self.questions = [[self.questions reverseObjectEnumerator] allObjects];
        [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    }];
}

- (UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QuestionTableViewCell *cell = (QuestionTableViewCell *)[self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    if ([cell.question.author isEqualToString: [GlobalVals sharedGlobalVals].fullName]) {
        return UITableViewCellEditingStyleDelete;
    }
    else {
        return UITableViewCellEditingStyleNone;     
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    QuestionTableViewCell *cell = (QuestionTableViewCell *)[self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSMutableArray *arr = [self.questions mutableCopy];
        [arr removeObjectAtIndex:indexPath.row];
        self.questions = [arr copy];
        [tableView reloadData]; // tell table to refresh now
        [HTTPManager deleteQuestion:cell.question completion:nil];
    }
}

@end
