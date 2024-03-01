import Orion
import MoonerC
import UIKit
import SwiftUI

class iOS_LSTimeHook : ClassHook<UIView> {
    static var targetName: String {
        if #available(iOS 16, *) {
            return "BSUIVibrancyEffectView"
        } else {
            return "SBFLockScreenDateView"
        }
    }

    func didMoveToWindow() {
        orig.didMoveToWindow()
        target.isHidden = true

    }
}

class iOS_LSTimeViewControllerHook : ClassHook<UIViewController> {
    static var targetName: String {
        if #available(iOS 16, *) {
            return "CSProminentDisplayViewController"
        } else {
            return "CSCombinedListViewController"
        }
    }

    private let MyTimeViewUHC = TimeViewUIHostingController(rootView: RootTimelineView())
    func viewDidLoad() {
        MyTimeViewUHC.view.translatesAutoresizingMaskIntoConstraints = false;
        target.addChild(MyTimeViewUHC)
        target.view.addSubview(MyTimeViewUHC.view)
        MyTimeViewUHC.view.isUserInteractionEnabled = false
        MyTimeViewUHC.view.topAnchor.constraint(equalTo: target.view.topAnchor).isActive = true
        MyTimeViewUHC.view.leadingAnchor.constraint(equalTo: target.view.leadingAnchor).isActive = true
        MyTimeViewUHC.view.trailingAnchor.constraint(equalTo: target.view.trailingAnchor).isActive = true
        MyTimeViewUHC.view.bottomAnchor.constraint(equalTo: target.view.bottomAnchor).isActive = true
        MyTimeViewUHC.view.isOpaque = false
        MyTimeViewUHC.view.backgroundColor = UIColor.clear
        orig.viewDidLoad()
    }
}