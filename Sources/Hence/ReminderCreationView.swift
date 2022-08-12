
import ComposableArchitecture
import SwiftUI

public struct ReminderCreationView: View {
  private let store: Store<ReminderCreationState, ReminderCreationAction>
  
  public var body: some View {
    WithViewStore(store) { viewStore in
      Form {
        Section {
          TextField(
            "Name",
            text: viewStore.binding(
              get: \.name,
              send: ReminderCreationAction.editName
            )
          )
        }
        
        Section {
          DateFrequencyRow(store: store)
          
          switch(viewStore.dateFrequency) {
          case .daily:
            EmptyView()
            
          case .weekly:
            NavigationLink(destination: WeeklySelection(store: store)) {
              HStack {
                Text("On")
                Spacer()
                Text(
                  viewStore
                    .selectedWeekDays
                    .map { $0.name(style: .short) }
                    .joined(separator: ", ")
                )
                .foregroundColor(.secondary)
              }
            }
            
          case .monthly:
            NavigationLink(destination: MonthlySelection(store: store)) {
              HStack {
                Text("On")
                Spacer()
                Text(
                  viewStore
                    .selectedMonthDays
                    .map(String.init)
                    .joined(separator: ", ")
                )
                .foregroundColor(.secondary)
              }
            }
          }
          
          TimeFrequencyRow(store: store)
        }
      }
      .toolbar {
        ToolbarItem {
          Button(action: {}) {
            Text("Save")
          }
          .disabled(viewStore.isSaveDisabled)
        }
      }
    }
    .navigationTitle("New Reminder")
    .navigationBarTitleDisplayMode(.large)
  }
  
  public init(store: Store<ReminderCreationState, ReminderCreationAction>) {
    self.store = store
  }
}

struct ReminderCreationView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      ReminderCreationView(
        store: Store(
          initialState: ReminderCreationState(),
          reducer: reminderCreationReducer,
          environment: ReminderCreationEnvironment()
        )
      )
    }
  }
}
