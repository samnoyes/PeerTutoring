#import "GlobalVals.h"

@implementation GlobalVals

+ (GlobalVals *) sharedGlobalVals
{
    static GlobalVals *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[GlobalVals alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}
@end