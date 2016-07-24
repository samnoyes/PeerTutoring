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

#define kOFFSET_FOR_KEYBOARD 200
#define kOFFSET_FOR_KEYBOARD_IPAD 300

@interface QuestionDetailViewController ()

@end

@implementation QuestionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.subjectLabel setText:self.question.subject];
    [self.questionTextView setText:self.question.questionText];
    [self.authorLabel setText:self.question.author];
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
        [self.tableView performSelectorOnMainThread: @selector(reloadData) withObject:nil waitUntilDone:NO];
    }];
}

- (void) moveViewUp {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        rect.origin.y -= kOFFSET_FOR_KEYBOARD_IPAD;
        rect.size.height += kOFFSET_FOR_KEYBOARD_IPAD;
    } else {
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
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
