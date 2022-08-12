
import ComposableArchitecture
import SwiftUI

public struct ReminderCreationView: View {
  private let store: Store<HenceState, HenceAction>
  
  public var body: some View {
    WithViewStore(store) { viewStore in
      Form {
        Text(viewStore.text)
        Button(action: { viewStore.send(.showMessage) }) {
          Image(systemName: "globe")
        }
      }
    }
    .navigationTitle("New Reminder")
    .navigationBarTitleDisplayMode(.large)
  }
  
  public init(store: Store<HenceState, HenceAction>) {
    self.store = store
  }
}

struct ReminderCreationView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      ReminderCreationView(
        store: Store(
          initialState: HenceState(),
          reducer: henceReducer,
          environment: HenceEnvironment()
        )
      )
    }
  }
}
