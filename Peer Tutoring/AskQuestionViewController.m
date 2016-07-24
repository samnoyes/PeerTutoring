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

@interface AskQuestionViewController ()
@property (weak, nonatomic) IBOutlet UIPickerView *subjectPicker;
@property (weak, nonatomic) IBOutlet UITextView *questionTextView;
@property (strong, nonatomic) NSArray *subjects;
@end

@implementation AskQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.subjects = [[NSArray alloc] initWithObjects:@"English", @"Math", @"Biology", @"Chemistry", @"Physics", @"Computer Science", @"History", @"Religion", nil];
    self.subjectPicker.delegate = self;
    self.subjectPicker.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    row = [self.subjectPicker selectedRowInComponent:0];
    NSString *sel = [self.subjects objectAtIndex:row];
    Question *q = [[Question alloc] initNewQuestionWithText:self.questionTextView.text author:[GlobalVals sharedGlobalVals].fullName subject:sel];
    [HTTPManager postQuestion:q completion:^(BOOL success){
        NSNumber *n = [NSNumber numberWithBool:YES];
        [self.navigationController performSelectorOnMainThread:@selector(popViewControllerAnimated:) withObject:n waitUntilDone:NO];
        [self.tvc performSelectorOnMainThread:@selector(updateView) withObject:nil waitUntilDone:NO];
    }];
}



// tell the picker the width of each row for a given component
/*- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    int sectionWidth = 300;
    
    return sectionWidth;
    
}*/




@end
