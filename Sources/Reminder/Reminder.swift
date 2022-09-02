
import ComposableArchitecture
import Foundation
import Hence

public struct Reminder: Identifiable, Equatable {
  public let id: UUID
  public let name: String
  public let image: String
  public let recurring: Recurring
  public let lastCompleted: Date
  
  public var subheading: String {
    switch recurring {
    case .daily(let at):
      return "Daily : \(at.string)"
    case .weekly(let on, let at):
      return "Weekly : \(on.map { $0.name(style: .short) }.joined(separator: ", ")) : \(at.string)"
    case .monthly(let on, let at):
      return "Monthly : \(on.description) : \(at.string)"
    }
  }
  
  public init(id: UUID, name: String, image: String, recurring: Recurring, lastCompleted: Date = .distantPast) {
    self.id = id
    self.name = name
    self.image = image
    self.recurring = recurring
    self.lastCompleted = lastCompleted
  }
  
  public static func == (lhs: Reminder, rhs: Reminder) -> Bool {
    lhs.id == rhs.id
  }
}

