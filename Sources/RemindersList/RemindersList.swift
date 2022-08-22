
import ComposableArchitecture
import Reminder
import SwiftUI

public struct RemindersList: View {
  let store: Store<RemindersState, RemindersAction>
  
  public var body: some View {
    WithViewStore(store) { viewStore in
      List {
        ForEach(viewStore.reminders) { reminder in
          ReminderRow(reminder: reminder)
        }
        .onDelete { indexSet in
          viewStore.send(.deleteReminders(indexSet))
        }
        .listRowSeparator(.hidden)
      }
      .navigationTitle("Reminders")
      .navigationBarTitleDisplayMode(.large)
      .toolbar {
        ToolbarItem {
          Button(action: { viewStore.send(.addReminder) }) {
            Image(systemName: "plus")
          }
        }
        ToolbarItem(placement: .automatic) {
          EditButton()
            .disabled(viewStore.noReminders)
        }
      }
      .environment(
        \.editMode,
         viewStore.binding(
          get: \.editMode,
          send: RemindersAction.editModeChanged
         )
      )
      .sheet(
        isPresented: viewStore.binding(
          get: \.isSheetPresented,
          send: RemindersAction.setSheet(isPresented:)
        )
      ) {
        NavigationView {
          IfLetStore(
            self.store.scope(
              state: \.reminderCreation,
              action: RemindersAction.reminderCreation
            )
          ) {
            ReminderCreationView(store: $0)
          }
        }
      }
    }
  }
  
  public init(store: Store<RemindersState, RemindersAction>) {
    self.store = store
  }
}

struct RemindersList_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      RemindersList(
        store: Store(
          initialState: RemindersState(reminders: remindersPreviewData),
          reducer: remindersReducer,
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
