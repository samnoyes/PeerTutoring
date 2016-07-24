//
//  WriteCommentTableViewCell.m
//  Peer Tutoring
//
//  Created by Samuel Noyes on 7/23/16.
//  Copyright © 2016 Samuel Noyes. All rights reserved.
//

#import "WriteCommentTableViewCell.h"
#import "GlobalVals.h"
#import "HTTPManager.h"

@implementation WriteCommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)submitPressed:(id)sender {
    [GlobalVals sharedGlobalVals].fullName = @"Sam Noyes";
    Comment *c = [[Comment alloc] initNewCommentWithText: self.commentTextView.text postID: self.qdvc.question.ID author: [GlobalVals sharedGlobalVals].fullName];
    [HTTPManager postComment: c completion: ^(BOOL success) {
        [self.qdvc performSelectorOnMainThread: @selector(updateView) withObject:nil waitUntilDone:NO];
        [self.commentTextView performSelectorOnMainThread:@selector(setText:) withObject:@"" waitUntilDone:NO];
        NSLog(success ? @"Success!" : @"Failed.");
    }];
}

@end
