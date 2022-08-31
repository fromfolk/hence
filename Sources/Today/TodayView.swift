
import ComposableArchitecture
import Reminder
import SwiftUI

public struct TodayView: View {
  let store: Store<TodayState, TodayAction>
  
  public var body: some View {
    WithViewStore(store) { viewStore in
      List {
        if !viewStore.dueReminders.isEmpty {
          Section(header: Text("Due")) {
            ForEach(viewStore.dueReminders) { reminder in
              Button(action: { viewStore.send(.dueTapped(reminder)) }) {
                HStack {
                  Image(systemName: "square")
                  Text(reminder.name)
                }
              }
              .foregroundColor(.primary)
            }
          }
        }
        if !viewStore.doneReminders.isEmpty {
          Section(header: Text("Done")) {
            ForEach(viewStore.doneReminders) { reminder in
              Text(reminder.name)
                .foregroundColor(.secondary)
            }
          }
        }
        if !viewStore.laterReminders.isEmpty {
          Section(header: Text("Later")) {
            ForEach(viewStore.laterReminders) { reminder in
              Text(reminder.name)
            }
          }
        }
      }
      .navigationTitle("Today")
      .onAppear { viewStore.send(.onAppear) }
    }
  }
  
  public init(store: Store<TodayState, TodayAction>) {
    self.store = store
  }
}

struct TodayView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      TodayView(
        store: Store(
          initialState: TodayState(reminders: remindersPreviewData),
          reducer: todayReducer,
          environment: .live
        )
      )
    }
  }
}

let remindersPreviewData: IdentifiedArrayOf<Reminder> = [
  Reminder(
    id: UUID(),
    name: "Brush teeth",
    image: "heart",
    recurring: .daily(at: .morning)
  ),
  Reminder(
    id: UUID(),
    name: "Work out",
    image: "cross",
    recurring: .weekly(
      on: [
        .monday,
        .wednesday,
        .friday
      ],
      at: .afternoon
    )
  ),
  Reminder(
    id: UUID(),
    name: "Meditate",
    image: "brain.head.profile",
    recurring: .daily(at: .evening)
  )
]
