//
//  AskQuestionViewController.m
//  Peer Tutoring
//
//  Created by Samuel Noyes on 7/23/16.
//  Copyright © 2016 Samuel Noyes. All rights reserved.
//

#import "AskQuestionViewController.h"
#import "Question.h"
#import "GlobalVals.h"
#import "HTTPManager.h"
#import "TableViewController.h"
#import "SubjectPickerTableViewController.h"

@interface AskQuestionViewController ()
@property (weak, nonatomic) IBOutlet UITextView *questionDetailsTextView;
@property (weak, nonatomic) IBOutlet UITextField *questionTitleTextField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *submitButton;
@property (strong, nonatomic) NSArray *subjects;
@property (nonatomic) BOOL editing;
@property (strong, nonatomic) UIColor *textPreviewColor;
@end

@implementation AskQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.subjects = [AskQuestionViewController subjectArray];
    self.editing = NO;
    self.questionTitleTextField.delegate = self;
    self.questionDetailsTextView.delegate = self;
    self.textPreviewColor = self.questionDetailsTextView.textColor;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (NSArray *) subjectArray {
    return [[NSArray alloc] initWithObjects:@"English", @"Math", @"Calculus", @"Statistics", @"French", @"Spanish", @"German", @"Russian", @"Biology", @"Chemistry", @"Physics", @"Computer Science", @"History", @"Religion", @"Arabic", nil];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    // Handle the selection
}

// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return [self.subjects count];
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *title;
    
    title = [self.subjects objectAtIndex:row];
    
    return title;
}

- (IBAction)submitPressed:(id)sender {
    //NSInteger row;
    if (!self.editing) {
        if ([self.questionDetailsTextView.text isEqualToString:@""] || [self.questionTitleTextField.text isEqualToString:@""]) {
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Title and Details cannot be left blank."preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alert animated:NO completion:nil];
        }
        Question *q = [[Question alloc] initNewQuestionWithTitle:self.questionTitleTextField.text details:self.questionDetailsTextView.text author:[GlobalVals sharedGlobalVals].fullName subject:@""];
        [HTTPManager postQuestion:q completion:^(BOOL success){
            NSNumber *n = [NSNumber numberWithBool:YES];
            [self.tvc.questions insertObject:q atIndex:0];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:n];
                [self.tvc.tableView reloadData];
            });
        }];
    }
    else {
        NSLog(@"ending editing");
        [self.questionTitleTextField endEditing:YES];
        [self.questionDetailsTextView endEditing:YES];
    }
}

- (void) textViewDidBeginEditing:(UITextView *)textView {
    if (![self.questionDetailsTextView.textColor isEqual:[UIColor blackColor]]) {
        [self.questionDetailsTextView setTextColor: [UIColor blackColor]];
        [self.questionDetailsTextView setText:@""];
    }
    [self.submitButton setTitle:@"Done"];
    self.editing = YES;
}

- (void) textViewDidEndEditing:(UITextView *)textView {
    if ([self.questionDetailsTextView.text isEqualToString:@""]) {
        [self.questionDetailsTextView setTextColor: self.textPreviewColor];
        [self.questionDetailsTextView setText:@"Details"];
    }
    [self.submitButton setTitle:@"Submit"];
    self.editing = NO;
}

- (void) textFieldDidBeginEditing:(UITextView *)textView {
    [self.submitButton setTitle:@"Done"];
    self.editing = YES;
}

- (void) textFieldDidEndEditing:(UITextField *)textField {
    [self.submitButton setTitle:@"Submit"];
    self.editing = NO;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && indexPath.row == 0) {
        SubjectPickerTableViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"subjectPicker" ];
        [self.navigationController pushViewController:vc animated:YES];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}



@end
