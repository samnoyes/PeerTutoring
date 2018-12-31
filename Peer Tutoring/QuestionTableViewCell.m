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

- (void) setQuestionTitle:(NSString *) t {
    if ([t length]>65) {
        [self.questionTitleView setText:[NSString stringWithFormat:@"%@...", [t substringToIndex:65]]];
    }
    else {
        [self.questionTitleView setText:t];
    }
}

- (void) setSubjectText: (NSString *) t {
    [self.subjectLabel setText:t];
}

- (void) setAuthorText: (NSString *) t {
    [self.authorLabel setText:t];
}

@end
