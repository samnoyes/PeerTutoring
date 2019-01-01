#import "GlobalVals.h"
//Edits to undo:
// * QuestionDetailViewController.m line 58
//TODO:
//Change AskQuestionViewController to TableViewController? So the text entry would be on a separate page rather than embedded in the current one.
//Fix commenting. Maybe add a separate CommentDetailViewController where the user could see an expanded version of the comment and reply?
//Related: add replying to comments
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
