import SwiftUI
import MoonerC

// Subclass my UIHostingController
final class TimeViewUIHostingController<Content>: UIHostingController<Content> where Content: View {
    // Allow TimeViewUIHostingController to be visible while device is locked
    override func _canShowWhileLocked() -> Bool {
        return true
    }
}