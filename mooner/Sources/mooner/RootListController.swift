import Preferences
import UIKit
import Foundation
import moonerC

class RootListController: PSListController {
    override var specifiers: NSMutableArray? {
        get {
            if let specifiers = value(forKey: "_specifiers") as? NSMutableArray {
                return specifiers
            } else {
                let specifiers = loadSpecifiers(fromPlistName: "Root", target: self)
                setValue(specifiers, forKey: "_specifiers")
                return specifiers
            }
        }
        set {
            super.specifiers = newValue
        }
    }
    @objc func respring() {
        let pid = UnsafeMutablePointer<pid_t>.allocate(capacity: 1)
        let args: [String] = ["sbreload"]
        posix_spawn(pid, "/var/jb/usr/bin/sbreload", nil, nil, args.map { strdup($0) }, nil)
    }
    @objc func resetSettings() {
        UserDefaults(suiteName: "com.now.moonerprefs")?.removePersistentDomain(forName: "com.now.moonerprefs")
        reload()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Apply", style: .plain, target: self, action: #selector(respring))
    }
}