
import ComposableArchitecture
import SwiftUI

struct ReminderRow: View {
  let store: Store<Reminder, ReminderAction>
  
  var body: some View {
    WithViewStore(store) { viewStore in
      VStack(alignment: .leading) {
        Text(viewStore.name)
        Text(viewStore.subheading)
          .foregroundColor(.secondary)
          .font(.subheadline)
      }
    }
  }
}

struct ReminderRow_Previews: PreviewProvider {
  static var previews: some View {
    ReminderRow(
      store: Store(
        initialState: Reminder(id: UUID(), name: "Hello", recurring: .daily(at: .morning)),
        reducer: reminderReducer,
        environment: ()
      )
    )
  }
}
