//
//  QuestionDetailViewController.m
//  Peer Tutoring
//
//  Created by Samuel Noyes on 7/22/16.
//  Copyright © 2016 Samuel Noyes. All rights reserved.
//

#import "QuestionDetailViewController.h"
#import "CommentTableViewCell.h"
#import "WriteCommentTableViewCell.h"

@interface QuestionDetailViewController ()

@end

@implementation QuestionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.subjectLabel setText:self.question.subject];
    [self.questionTextView setText:self.question.questionText];
    [self.authorLabel setText:self.question.author];
    NSLog(@"%@", self.question.comments);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.question.comments count]+1;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [self.question.comments count]) {
        WriteCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"writeCommentCell"];
        [cell.commentTextView setUserInteractionEnabled:YES];
        cell.qdvc = self;
        return cell;
    }
    else {
        CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentCell"];
        [cell.commentTextView setText:[NSString stringWithFormat:@"%@: %@", [self.question.comments objectAtIndex:indexPath.row].author, [self.question.comments objectAtIndex:indexPath.row].commentText]];
        return cell;
    }
}

- (void) updateView {
    [self.question reloadCommentsWithCompletion: ^{
        [self.tableView performSelectorOnMainThread: @selector(reloadData)];
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
