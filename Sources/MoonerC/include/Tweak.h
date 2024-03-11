#import <UIKit/UIKit.h>

// iOS 16 Lockscreen interfacing
@interface CSProminentDisplayView : UIView
@property NSArray *subviews;
@end

@interface CSProminentDisplayViewController : UIViewController
@end

// iOS 15 Lockscreen interfacing
@interface SBFLockScreenDateView : UIView
@end

@interface CSCombinedListViewController : UIViewController
@end

// Version Neutral interfacing
@interface UIViewController (Private)
- (BOOL)_canShowWhileLocked;
@end

@interface SBUIProudLockIconView : UIView // iPhone X lock icon
@end

@interface CSPageControl : UIView // Lockscreen Page dots
@end