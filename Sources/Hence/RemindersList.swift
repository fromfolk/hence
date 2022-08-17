
import ComposableArchitecture
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
      }
      .navigationTitle("Reminders")
      .navigationBarTitleDisplayMode(.large)
      .listStyle(.grouped)
      .toolbar {
        ToolbarItem {
          Button(action: { viewStore.send(.addReminder) }) {
            Image(systemName: "plus")
              .font(.title2)
          }
        }
        ToolbarItem(placement: .automatic) {
          EditButton()
            .font(.title2)
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
          initialState: RemindersState(
            reminders: [
              Reminder(
                id: UUID(),
                name: "Brush teeth",
                recurring: .daily(at: .morning)
              ),
              Reminder(
                id: UUID(),
                name: "Work out",
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
                recurring: .daily(at: .evening)
              )
            ]
          ),
          reducer: remindersReducer,
          environment: ()
        )
      )
    }
  }
}
