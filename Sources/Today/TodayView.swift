
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
              HStack {
                Image(systemName: "square")
                Text(reminder.name)
              }
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
          initialState: TodayState(
            dueReminders: remindersPreviewData,
            laterReminders: [
              Reminder(
                id: UUID(),
                name: "Something later",
                image: "brain",
                recurring: .weekly(on: [.thursday], at: .morning)
              )
            ]
          ),
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
