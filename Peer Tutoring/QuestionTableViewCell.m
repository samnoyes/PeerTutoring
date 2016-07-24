//
//  QuestionTableViewCell.m
//  Peer Tutoring
//
//  Created by Samuel Noyes on 7/21/16.
//  Copyright © 2016 Samuel Noyes. All rights reserved.
//

#import "QuestionTableViewCell.h"

@interface QuestionTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *subjectLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;

@end

@implementation QuestionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setQuestionText:(NSString *) t {
    if ([t length]>50) {
        [self.questionTextView setText:[NSString stringWithFormat:@"%@...", [t substringToIndex:50]]];
    }
    else {
        [self.questionTextView setText:t];
    }
    //CGRect frame = self.questionTextView.frame;
    //frame.size.height = self.questionTextView.contentSize.height;
    //self.questionTextView.frame = frame;
    //[self.authorLabel setFrame:CGRectMake(self.authorLabel.frame.origin.x, self.questionTextView.frame.origin.y+self.questionTextView.frame.size.height, self.authorLabel.frame.size.width, self.authorLabel.frame.size.height)];
}

- (void) setSubjectText: (NSString *) t {
    [self.subjectLabel setText:t];
}

- (void) setAuthorText: (NSString *) t {
    [self.authorLabel setText:t];
}

@end
