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

@interface AskQuestionViewController ()
@property (weak, nonatomic) IBOutlet UIPickerView *subjectPicker;
@property (weak, nonatomic) IBOutlet UITextView *questionDetailsTextView;
@property (weak, nonatomic) IBOutlet UITextField *questionTitleTextView;
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
    self.subjectPicker.delegate = self;
    self.subjectPicker.dataSource = self;
    self.editing = NO;
    self.questionTitleTextView.delegate = self;
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
    NSInteger row;
    if (!self.editing) {
        if ([self.questionDetailsTextView.text isEqualToString:@""] || [self.questionTitleTextView.text isEqualToString:@""]) {
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Title and Details cannot be left blank."preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alert animated:NO completion:nil];
        }
        row = [self.subjectPicker selectedRowInComponent:0];
        NSString *sel = [self.subjects objectAtIndex:row];
        Question *q = [[Question alloc] initNewQuestionWithTitle:self.questionTitleTextView.text details:self.questionDetailsTextView.text author:[GlobalVals sharedGlobalVals].fullName subject:sel];
        [HTTPManager postQuestion:q completion:^(BOOL success){
            NSNumber *n = [NSNumber numberWithBool:YES];
            [self.navigationController performSelectorOnMainThread:@selector(popViewControllerAnimated:) withObject:n waitUntilDone:NO];
            [self.tvc.questions insertObject:q atIndex:0];
            [self.tvc.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        }];
    }
    else {
        [self.questionTitleTextView resignFirstResponder];
        [self.questionDetailsTextView resignFirstResponder];
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
        [self.questionDetailsTextView setText:@" Details"];
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



@end
