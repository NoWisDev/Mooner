#import <UIKit/UIKit.h>
#include <UIKit/UIViewController.h>
#import <UIKit/UIView.h>
#import <SwiftUI/SwiftUI.h>
#import <SpringBoard/SpringBoard.h>

@interface SBFLockScreenDateView : UIView
@end
@interface SBFLockScreenDateViewController : UIViewController
@end
@interface BSUIVibrancyEffectView : UIView
@end
@interface CSProminentDisplayViewController : UIViewController
@end
@interface UIViewController (Private)
- (BOOL)_canShowWhileLocked;
@end
@interface CSCombinedListViewController : UIViewController
@end