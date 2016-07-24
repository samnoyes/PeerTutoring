#import <UIKit/UIKit.h>

@interface GlobalVals : NSObject
@property (strong, nonatomic) NSString *fullName;
+ (GlobalVals *) sharedGlobalVals;
@end
