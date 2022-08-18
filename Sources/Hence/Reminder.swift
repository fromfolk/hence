
import ComposableArchitecture

public struct Reminder: Identifiable, Equatable {
  public let id: UUID
  let name: String
  let image: String
  let recurring: Recurring
  
  var subheading: String {
    switch recurring {
    case .daily(let at):
      return "Daily : \(at.string)"
    case .weekly(let on, let at):
      return "Weekly : \(on.map { $0.name(style: .short) }.joined(separator: ", ")) : \(at.string)"
    case .monthly(let on, let at):
      return "Monthly : \(on.description) : \(at.string)"
    }
  }
  
  public static func == (lhs: Reminder, rhs: Reminder) -> Bool {
    lhs.id == rhs.id
  }
}

