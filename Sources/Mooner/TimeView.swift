import SwiftUI
import UIKit
import MoonerC

class BatteryLevelDetector: ObservableObject {
    @Published var batteryLevel: Int = 0
    @Published var isScreenLocked = false
    init() {
        UIDevice.current.isBatteryMonitoringEnabled = true
        self.batteryLevel = Int(UIDevice.current.batteryLevel * 100)
        // Notification Observer
        NotificationCenter.default.addObserver(self, selector: #selector(batteryLevelDidChange(notification:)), name: UIDevice.batteryLevelDidChangeNotification, object: nil)
    }
    @objc func batteryLevelDidChange(notification: Notification) {
        self.batteryLevel = Int(UIDevice.current.batteryLevel * 100)
    }
}

func formatDate(pointInTime: Date) -> (LongDate: String, Time: String, AMPM: String) {
    // LongDate
    let longDateFormatter = DateFormatter()
    longDateFormatter.dateFormat = userDateFormat
    let LongDate: String = longDateFormatter.string(from: pointInTime)
    // Time
    let timeFormatter = DateFormatter()
    timeFormatter.dateFormat = userTimeFormat
    let Time: String = timeFormatter.string(from: pointInTime)
    // AM/PM
    var ampmFormat = "a"
    if isShowAMPMEnabled == false {
        ampmFormat = ""
    }
    let ampmFormatter = DateFormatter()
    ampmFormatter.dateFormat = ampmFormat
    let AMPM: String = ampmFormatter.string(from: pointInTime)

    return (LongDate, Time, AMPM)
}

struct RootTimelineView: View {
    var body: some View {
        VStack {
            TimelineView<EveryMinuteTimelineSchedule, TimeView>(.everyMinute) { context in
                TimeView(date: context.date)
            }
        }
    }
}

struct TimeView: View {
    let date: Date
    @ObservedObject var batteryLevelDetector = BatteryLevelDetector()
    let secondaryColor = Color(red:0.85, green:0.85, blue:0.85)
    let secondaryOpacity = 0.9
    let secondaryBlur: Material = .thickMaterial
    @State var islsMainView = isLSMainView

    var body: some View {
        if islsMainView == true {
            let (LongDate, Time, AMPM) = formatDate(pointInTime: date)
            let lsAlignment: HorizontalAlignment = {
                if lockscreenAlignment == 0 {
                    return .leading
                } else if lockscreenAlignment == 1 {
                    return .center
                } else {
                    return .trailing
                }
            }()

            HStack {
                if lockscreenAlignment == 2 {
                    Spacer()
                }
                VStack(alignment: lsAlignment) {
                    if isDayNightIconEnabled == false {
                        Text("\(LongDate)")
                            .font(.system(size: 25, weight: .semibold, design: .rounded))
                            .opacity(secondaryOpacity)
                            .foregroundColor(secondaryColor)
                            .foregroundStyle(secondaryBlur)
                    } else if lockscreenAlignment != 2 {
                        Text("\(LongDate) \(Image(systemName: "sun.max.fill"))")
                            .font(.system(size: 25, weight: .semibold, design: .rounded))
                            .opacity(secondaryOpacity)
                            .foregroundColor(secondaryColor)
                            .foregroundStyle(secondaryBlur)
                    } else {
                        Text("\(Image(systemName: "sun.max.fill")) \(LongDate)")
                        .font(.system(size: 25, weight: .semibold, design: .rounded))
                        .opacity(secondaryOpacity)
                        .foregroundColor(secondaryColor)
                        .foregroundStyle(secondaryBlur)
                    }
                    HStack(alignment: .lastTextBaseline) {
                        if lockscreenAlignment != 2 {
                            Text("\(Time)")
                                .font(.system(size: 60, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                        }
                        Text("\(AMPM)")
                            .font(.system(size: 35, weight: .semibold, design: .rounded))
                            .opacity(secondaryOpacity)
                            .foregroundColor(secondaryColor)
                            .foregroundStyle(secondaryBlur)
                        if lockscreenAlignment == 2 {
                            Text("\(Time)")
                                .font(.system(size: 60, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                        }
                        
                    }
                    Text("Battery Percentage: \(batteryLevelDetector.batteryLevel)%")
                        .font(.system(size: 25, weight: .semibold, design: .rounded))
                        .opacity(secondaryOpacity)
                        .foregroundColor(secondaryColor)
                        .foregroundStyle(secondaryBlur)
                    Spacer()
                }
                .padding(.top, 30)
                .padding(.horizontal, 15)
                if lockscreenAlignment == 0 {
                    Spacer()
                }
            }
            .environment(\.layoutDirection, .leftToRight)
        }
    }
}