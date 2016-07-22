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


@interface ViewController ()
@property (strong, nonatomic) NSArray<Question *> *questions;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.questions = [HTTPManager getQuestionsWithCompletion: ^(NSArray<Question *> *response){
        self.questions = response;
        [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"Count = %lu", (unsigned long)[self.questions count]);
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
    
}

@end
