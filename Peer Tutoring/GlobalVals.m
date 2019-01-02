#import "GlobalVals.h"
//Edits to undo:
// * QuestionDetailViewController.m line 58
//TODO:
//Add refreshing functionality to question list.
//Fix commenting. Maybe add a separate CommentDetailViewController where the user could see an expanded version of the comment and reply?
//Related: add replying to comments
//Add login/signup page
//Add tagging
//Add push notifications when you get tagged


@implementation GlobalVals

+ (GlobalVals *) sharedGlobalVals
{
    static GlobalVals *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[GlobalVals alloc] init];
        sharedInstance.fullName = @"Sam Noyes";
    });
    return sharedInstance;
}
@end
