
import ComposableArchitecture
import Foundation
import Reminder
import UserNotifications

public struct NotificationConfig {
  public let id: UUID
  public let title: String
  public let body: String
  public let date: Date
  
  public init(id: UUID, title: String, body: String, date: Date) {
    self.id = id
    self.title = title
    self.body = body
    self.date = date
  }
}

public struct NotificationsClient {
  public struct Settings: Equatable {
    public var authorizationStatus: UNAuthorizationStatus
    
    public init(rawValue: UNNotificationSettings) {
      self.authorizationStatus = rawValue.authorizationStatus
    }
  }
  
  public var notificationSettings: () -> Effect<Settings, Never>
  public var requestAuthorization: (UNAuthorizationOptions) -> Effect<Bool, Error>
  public var addNotification: (NotificationConfig) -> Effect<Never, Error>
  public var removeNotifications: (UUID...) -> Effect<Never, Never>
}

public extension NotificationsClient {
  static let live = Self(
    notificationSettings: {
      .future { callback in
        UNUserNotificationCenter.current()
          .getNotificationSettings { settings in
            callback(.success(.init(rawValue: settings)))
          }
      }
    },
    requestAuthorization: { options in
      .future { callback in
        UNUserNotificationCenter.current()
          .requestAuthorization(options: options) { granted, error in
            if let error = error {
              callback(.failure(error))
            } else {
              callback(.success(granted))
            }
          }
      }
    },
    addNotification: { config in
      .future { callback in
        let content = UNMutableNotificationContent()
        content.title = config.title
        content.body = config.body
         
        let request = UNNotificationRequest(
          identifier: config.id.uuidString,
          content: content,
          trigger: UNCalendarNotificationTrigger(
            dateMatching: config.date.dateComponents,
            repeats: false
          )
        )
        
        UNUserNotificationCenter.current()
          .add(request) { error in
            if let error {
              callback(.failure(error))
            }
          }
      }
    },
    removeNotifications: { notifications in
      .fireAndForget {
        UNUserNotificationCenter.current()
          .removePendingNotificationRequests(withIdentifiers: notifications.map(\.uuidString))
      }
    }
  )
}
