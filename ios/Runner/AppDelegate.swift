import Flutter
import UIKit
import UserNotifications

private let attendanceCategoryId = "ATTENDANCE_ACTIONS"
private let attendanceChannelName = "com.example.employee_track/attendance_notification"

@main
@objc class AppDelegate: FlutterAppDelegate, UNUserNotificationCenterDelegate {
  private var attendanceMethodChannel: FlutterMethodChannel?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    UNUserNotificationCenter.current().delegate = self
    registerAttendanceNotificationCategory()
    setupAttendanceNotificationChannel()
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func registerAttendanceNotificationCategory() {
    let checkOut = UNNotificationAction(identifier: "checkOut", title: "Check Out", options: [.foreground])
    let startBreak = UNNotificationAction(identifier: "startBreak", title: "Start Break", options: [.foreground])
    let endBreak = UNNotificationAction(identifier: "endBreak", title: "End Break", options: [.foreground])
    let category = UNNotificationCategory(
      identifier: attendanceCategoryId,
      actions: [checkOut, startBreak, endBreak],
      intentIdentifiers: [],
      options: []
    )
    UNUserNotificationCenter.current().setNotificationCategories([category])
  }

  private func setupAttendanceNotificationChannel() {
    guard let controller = window?.rootViewController as? FlutterViewController else { return }
    let channel = FlutterMethodChannel(
      name: attendanceChannelName,
      binaryMessenger: controller.binaryMessenger,
    )
    attendanceMethodChannel = channel
    channel.setMethodCallHandler { [weak self] call, result in
      switch call.method {
      case "showAttendanceNotification":
        self?.showAttendanceNotification(call: call, result: result)
      case "clearAttendanceNotification":
        self?.clearAttendanceNotification(result: result)
      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }

  private func showAttendanceNotification(call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard let args = call.arguments as? [String: Any],
          let checkInAtIso = args["checkInAtIso"] as? String,
          let breakSeconds = args["breakSeconds"] as? Int,
          let workedSeconds = args["workedSeconds"] as? Int,
          let isOnBreak = args["isOnBreak"] as? Bool,
          let expectedWorkSeconds = args["expectedWorkSeconds"] as? Int else {
      result(FlutterError(code: "INVALID_ARGS", message: "Missing arguments", details: nil))
      return
    }
    let startedAt = formatTimeFromIso(checkInAtIso)
    let breakStr = formatDuration(breakSeconds)
    let workedStr = formatDuration(workedSeconds)
    let progressMax = max(1, expectedWorkSeconds)
    let remaining = max(0, progressMax - workedSeconds - breakSeconds)
    let remainingStr = formatDuration(remaining)
    let progressLine = "Work \(workedStr) • Break \(breakStr) • Left \(remainingStr)"
    let body: String
    if isOnBreak {
      body = "Started \(startedAt)\n\(progressLine) (On break)"
    } else {
      body = "Started \(startedAt)\n\(progressLine)"
    }
    let content = UNMutableNotificationContent()
    content.title = "Clocked in"
    content.body = body
    content.sound = nil
    content.interruptionLevel = .passive
    content.categoryIdentifier = attendanceCategoryId
    let request = UNNotificationRequest(
      identifier: "employee_track_attendance",
      content: content,
      trigger: nil
    )
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge]) { _, _ in }
    UNUserNotificationCenter.current().add(request) { err in
      DispatchQueue.main.async {
        if let err = err { result(FlutterError(code: "NOTIFY", message: err.localizedDescription, details: nil))
        } else { result(nil) }
      }
    }
  }

  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void
  ) {
    let actionId = response.actionIdentifier
    if response.notification.request.identifier == "employee_track_attendance",
       ["checkOut", "startBreak", "endBreak"].contains(actionId) {
      attendanceMethodChannel?.invokeMethod("notificationAction", arguments: actionId) { _ in }
    }
    completionHandler()
  }

  private func clearAttendanceNotification(result: @escaping FlutterResult) {
    UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: ["employee_track_attendance"])
    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["employee_track_attendance"])
    result(nil)
  }

  private func formatTimeFromIso(_ iso: String) -> String {
    let isoFormatter = ISO8601DateFormatter()
    isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    if let date = isoFormatter.date(from: iso) ?? isoFormatter.date(from: String(iso.prefix(19)) + "Z") {
      let out = DateFormatter()
      out.dateFormat = "h:mm a"
      return out.string(from: date)
    }
    let fallback = DateFormatter()
    fallback.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    fallback.timeZone = TimeZone.current
    if let date = fallback.date(from: String(iso.prefix(19))) {
      let out = DateFormatter()
      out.dateFormat = "h:mm a"
      return out.string(from: date)
    }
    return iso
  }

  private func formatDuration(_ totalSeconds: Int) -> String {
    let h = totalSeconds / 3600
    let m = (totalSeconds % 3600) / 60
    return h > 0 ? "\(h)h \(m)m" : "\(m)m"
  }
}
