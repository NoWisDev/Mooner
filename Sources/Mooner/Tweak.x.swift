import Orion
import MoonerC
import UIKit
import SwiftUI

struct iOS16Features: HookGroup {}
struct iOS15Features: HookGroup {}

struct Mooner: Tweak {
    init() {
        if #available(iOS 16, *) {
            iOS16Features().activate()
        } else {
            iOS15Features().activate()
        }
    }
}

class iOS16_LSTimeHook : ClassHook<UIView> {
    typealias Group = iOS16Features
    static let targetName = "CSProminentDisplayView"

    func didMoveToWindow() {
        orig.didMoveToWindow()
        target.subviews[1].isHidden = true
    }
}

class iOS15_LSTimeHook : ClassHook<UIView> {
    typealias Group = iOS15Features
    static let targetName = "SBFLockScreenDateView"

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