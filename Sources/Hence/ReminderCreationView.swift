
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
        
        Text(viewStore.name)
        Button(action: { viewStore.send(.showName) }) {
          Image(systemName: "globe")
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
