#import <UIKit/UIKit.h>
#include <UIKit/UIViewController.h>
#import <UIKit/UIView.h>
#import <SwiftUI/SwiftUI.h>
#import <SpringBoard/SpringBoard.h>
#include <RemoteLog.h>

@interface CSProminentDisplayView : UIView
@property NSArray *subviews;
@end
@interface CSProminentDisplayViewController : UIViewController
@end
@interface BSUIVibrancyEffectView : UIView
@end

@interface SBFLockScreenDateView : UIView
@end
@interface CSCombinedListViewController : UIViewController
@end

@interface UIViewController (Private)
- (BOOL)_canShowWhileLocked;
@end