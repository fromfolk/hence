
import ComposableArchitecture
import SwiftUI

struct ReminderRow: View {
  let reminder: Reminder
  var body: some View {
    VStack(alignment: .leading) {
      Text(reminder.name)
      Text(reminder.subheading)
        .foregroundColor(.secondary)
        .font(.subheadline)
    }
  }
}

struct ReminderRow_Previews: PreviewProvider {
  static var previews: some View {
    ReminderRow(
      reminder: Reminder(id: UUID(), name: "Hello", recurring: .daily(at: .morning))
    )
  }
}
