import SwiftUI
import MoonerC

private final class BatteryLevelDetector: ObservableObject {
    @Published private(set) var batteryLevel = 0
    init() {
        UIDevice.current.isBatteryMonitoringEnabled = true
        batteryLevel = Int(UIDevice.current.batteryLevel * 100)
        // Notification Observer
        NotificationCenter.default.addObserver(self, selector: #selector(batteryLevelDidChange), name: UIDevice.batteryLevelDidChangeNotification, object: nil)
    }
    @objc private func batteryLevelDidChange() {
        batteryLevel = Int(UIDevice.current.batteryLevel * 100)
    }
}

struct RootTimelineView: View {
    var body: some View {
        VStack {
            TimelineView<(PeriodicTimelineSchedule), TimeView>(.periodic(from: .now, by: 1.0)) { context in
                TimeView(date: context.date)
            }
        }
    }
}

private struct TimeView: View {
    let date: Date

    @State private var islsMainView = isLSMainView
    @StateObject private var batteryLevelDetector = BatteryLevelDetector()

    var body: some View {
        if islsMainView {
            let lsAlignment: HorizontalAlignment = {
                switch lockscreenAlignment {
                    case 0: return .leading
                    case 1: return .center
                    case 2: return .trailing
                    default: return .leading
                }
            }()

            HStack {
                VStack(alignment: lsAlignment) {
                    Group {
                        let longDateString = format(date: date, withFormat: userDateFormat ?? "")
                        let sunTextString: LocalizedStringKey = isDayNightIconEnabled == true ? "\(Image(systemName: "sun.max.fill")) \(longDateString)" : LocalizedStringKey(longDateString)
                        let textSunString: LocalizedStringKey = isDayNightIconEnabled == true ? "\(longDateString) \(Image(systemName: "sun.max.fill"))" : LocalizedStringKey(longDateString)

                        if lockscreenAlignment == 2 {
                            Text(sunTextString)

                        } else {
                            Text(textSunString)
                        }
                    }
                    .font(.system(size: 25, weight: .semibold, design: .rounded))
                    .styleModifier()

                    HStack(alignment: .lastTextBaseline) {
                        let amPMFormat = isShowAMPMEnabled == true ? "a" : ""
                        let amPMString = format(date: date, withFormat: amPMFormat)

                        if lockscreenAlignment != 2 {
                            TimeText()
                        }
                        Text(amPMString)
                            .font(.system(size: 35, weight: .semibold, design: .rounded))
                            .styleModifier()
                        if lockscreenAlignment == 2 {
                            TimeText()
                        }
                    }
                    Text("Battery Percentage: \(batteryLevelDetector.batteryLevel)%")
                        .font(.system(size: 25, weight: .semibold, design: .rounded))
                        .styleModifier()
                    Spacer()
                }
                .padding(.top, 30)
                .padding(.horizontal, 15)
            }
            .environment(\.layoutDirection, .leftToRight)
            .frame(
                maxWidth: .infinity,
                alignment: lockscreenAlignment == 0 ? .leading : lockscreenAlignment == 2 ? .trailing : .center
            )
        }
    }

    @ViewBuilder
    private func TimeText() -> some View {
        let timeString = format(date: date, withFormat: userTimeFormat ?? "")

        Text(timeString)
            .font(.system(size: 60, weight: .bold, design: .rounded))
            .foregroundColor(.white)
    }

    private func format(date: Date, withFormat format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
}

private struct StyleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .opacity(0.9)
            .foregroundColor(Color(red:0.85, green:0.85, blue:0.85))
            .foregroundStyle(.thickMaterial)
    }
}

private extension View {
    func styleModifier() -> some View {
        modifier(StyleModifier())
    }
}
