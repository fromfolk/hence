
import ComposableArchitecture
import SwiftUI

struct ReminderRow: View {
  let reminder: Reminder
  var body: some View {
    HStack {
      Image(systemName: reminder.image)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 30, height: 30)
      VStack(alignment: .leading) {
          Text(reminder.name)
          Text(reminder.subheading)
            .foregroundColor(.secondary)
            .font(.subheadline)
      }
    }
  }
}

struct ReminderRow_Previews: PreviewProvider {
  static var previews: some View {
    List {
      ForEach(remindersPreviewData) {
        ReminderRow(
          reminder: $0
        )
      }
      .listRowSeparator(.hidden)
    }
  }
}
