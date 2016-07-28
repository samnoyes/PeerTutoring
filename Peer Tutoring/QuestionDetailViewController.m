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
#import "GlobalVals.h"
#import "HTTPManager.h"

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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.question.comments count]+1;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentTableViewCell *cell = (CommentTableViewCell *)[self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSMutableArray *arr = [self.question.comments mutableCopy];
        [arr removeObjectAtIndex:indexPath.row];
        self.question.comments = [arr copy];
        [tableView reloadData]; // tell table to refresh now
        [HTTPManager deleteComment:cell.comment completion:nil];
    }
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
        cell.comment = [self.question.comments objectAtIndex:indexPath.row];
        return cell;
    }
}

- (UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [self.question.comments count]) {
        return UITableViewCellEditingStyleNone;
    }
    else {
        CommentTableViewCell *cell = (CommentTableViewCell *)[self tableView:self.tableView cellForRowAtIndexPath:indexPath];
        if ([cell.comment.author isEqualToString: [GlobalVals sharedGlobalVals].fullName]) {
            return UITableViewCellEditingStyleDelete;
        }
        else {
            return UITableViewCellEditingStyleNone;     
        }
    }
}

- (void) updateView {
    [self.question reloadCommentsWithCompletion: ^{
        [self.tableView performSelectorOnMainThread: @selector(reloadData) withObject:nil waitUntilDone:NO];
    }];
}

- (void) moveView: (CGFloat) f {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    rect.origin.y += f;
    //rect.size.height -= f;
    self.view.frame = rect;
    
    [UIView commitAnimations];
}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    // Get the size of the keyboard.
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    //Given size may not account for screen rotation
    int height = MIN(keyboardSize.height,keyboardSize.width);
    
    //your other code here..........
    [self moveView: -height];
}

- (void) keyboardWillHide: (NSNotification *)notification {
    // Get the size of the keyboard.
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    //Given size may not account for screen rotation
    int height = MIN(keyboardSize.height,keyboardSize.width);
    
    //your other code here..........
    [self moveView: height];
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
