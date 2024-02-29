import SwiftUI
import UIKit
import MoonerC

class BatteryLevelDetector: ObservableObject {
    @Published var batteryLevel: Int = 0
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
    func formatDate(pointInTime: Date) -> (LongDate: String, Time: String, AMPM: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, EEEE;hh:mm+a"
        let dateString: String = dateFormatter.string(from: pointInTime)     
        let LongDate = String(dateString[..<(dateString.firstIndex(of: ";")!)])
        let Time = String(dateString[(dateString.firstIndex(of: ";")!)..<(dateString.firstIndex(of: "+")!)].dropFirst())
        let AMPM = String(dateString[(dateString.firstIndex(of: "+")!)...].dropFirst())
        return (LongDate, Time, AMPM)
    }
    let secondaryColor = Color(red:0.85, green:0.85, blue:0.85)
    let secondaryOpacity = 0.9
    let secondaryBlur: Material = .thickMaterial

    var body: some View {
        let (LongDate, Time, AMPM) = formatDate(pointInTime: date)
        HStack {
            VStack {
                Text("\(LongDate) \(Image(systemName: "sun.max.fill"))")
                    .font(.system(size: 25, weight: .semibold, design: .rounded))
                    .opacity(secondaryOpacity)
                    .foregroundColor(secondaryColor)
                    .foregroundStyle(secondaryBlur)
                    .frame(maxWidth: .infinity, alignment: .leading)
                HStack(alignment: .lastTextBaseline) {
                    Text("\(Time)")
                        .font(.system(size: 60, weight: .bold, design: .rounded))
                        .frame(alignment: .leading)
                        .foregroundColor(.white)
                    Text("\(AMPM)")
                        .font(.system(size: 35, weight: .semibold, design: .rounded))
                        .opacity(secondaryOpacity)
                        .foregroundColor(secondaryColor)
                        .foregroundStyle(secondaryBlur)
                        .frame(alignment: .leading)
                        .offset(x:0, y:1)
                    Spacer()
                    
                }
                Text("Battery Percentage: \(batteryLevelDetector.batteryLevel)%")
                    .font(.system(size: 25, weight: .semibold, design: .rounded))
                    .opacity(secondaryOpacity)
                    .foregroundColor(secondaryColor)
                    .foregroundStyle(secondaryBlur)
                    .frame(maxWidth: .infinity, alignment: .bottomLeading)
                Spacer()
            }
            .padding(.top, 30)
            .padding(.leading, 15)
            .frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
        }
        .environment(\.layoutDirection, .leftToRight)
    }
}