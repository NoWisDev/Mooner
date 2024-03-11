import Orion
import SwiftUI
import MoonerC

// preference vars
var isTweakEnabled: Bool?
var lockscreenAlignment: Int?
var isDayNightIconEnabled: Bool?
var isShowAMPMEnabled: Bool?
var isHideProudLockEnabled: Bool?
var isHidePageDotsEnabled: Bool?
var userTimeFormat: String?
var userDateFormat: String?

// variable that contains the visibility of the lockscreen
var isLSMainView = true

// Hooks & Stuff

struct iOS16Features: HookGroup {}
struct iOS15Features: HookGroup {}
struct VersionNeutralFeatures: HookGroup {}

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

class ProudLockHook : ClassHook<UIView> {
    typealias Group = VersionNeutralFeatures
    static let targetName = "SBUIProudLockIconView"

    func didMoveToWindow() {
        orig.didMoveToWindow()
        target.isHidden = isHideProudLockEnabled!
    }
}

class LSPageDotsHook : ClassHook<UIView> {
    typealias Group = VersionNeutralFeatures
    static let targetName = "CSPageControl"

    func didMoveToWindow() {
        orig.didMoveToWindow()
        target.isHidden = isHidePageDotsEnabled!
    }
}

class iOS_LSTimeViewControllerHook : ClassHook<UIViewController> {
    typealias Group = VersionNeutralFeatures
    static var targetName: String {
        if #available(iOS 16, *) {
            return "CSProminentDisplayViewController"
        } else {
            return "CSCombinedListViewController"
        }
    }
    func viewDidAppear(_ animated: Bool) {
        orig.viewDidAppear(animated)
        isLSMainView = true
    }
    func viewDidDisappear(_ animated: Bool) {
        orig.viewDidDisappear(animated)
        isLSMainView = false
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

// Preference updates and initializer
func preferencesChanged() {
    let prefs = UserDefaults(suiteName: "com.now.moonerprefs")
        isTweakEnabled = (prefs?.object(forKey: "isTweakEnabled") as? Bool) ?? true
        lockscreenAlignment = (prefs?.object(forKey: "lockscreenAlignment") as? Int) ?? 0
        isDayNightIconEnabled = (prefs?.object(forKey: "isDayNightIconEnabled") as? Bool) ?? false
        isShowAMPMEnabled = (prefs?.object(forKey: "isShowAMPMEnabled") as? Bool) ?? true
        isHideProudLockEnabled = (prefs?.object(forKey: "isHideProudLockEnabled") as? Bool) ?? false
        isHidePageDotsEnabled = (prefs?.object(forKey: "isHidePageDotsEnabled") as? Bool) ?? false
        userTimeFormat = (prefs?.object(forKey: "userTimeFormat") as? String) ?? "hh:mm"
        userDateFormat = (prefs?.object(forKey: "userDateFormat") as? String) ?? "MMMM d, EEEE"
}

struct Mooner: Tweak {
    init() {
        preferencesChanged()
        
        if isTweakEnabled == true {
            if #available(iOS 16, *) {
                iOS16Features().activate()
            } else {
                iOS15Features().activate()
            }
            VersionNeutralFeatures().activate()
        }
    }
}