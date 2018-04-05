#import "GlobalVals.h"
//Edits to undo:
// * QuestionDetailViewController.m line 58


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
