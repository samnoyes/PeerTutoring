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

//- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QuestionTableViewCell *cell = (QuestionTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"questionCell"];
    [cell setAuthorText:[self.questions objectAtIndex:indexPath.row].author];
    [cell setQuestionText:[self.questions objectAtIndex:indexPath.row].questionText];
    [cell setSubjectText:[self.questions objectAtIndex:indexPath.row].subject];
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

@end
