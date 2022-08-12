
import ComposableArchitecture
import SwiftUI

struct TimeFrequencyRow: View {
  enum Action {
    case timeFrequencyChanged(TimeFrequency)
  }
  
  let store: Store<ReminderCreationState, ReminderCreationAction>
  @ObservedObject var viewStore: ViewStore<(ReminderCreationState), Self.Action>
  
  var body: some View {
    Picker(
      selection: viewStore.binding(
        get: \.timeFrequency,
        send: Action.timeFrequencyChanged
      ), content: {
        ForEach(TimeFrequency.allCases, id: \.self) { frequency in
          Text(frequency.rawValue)
            .tag(frequency)
        }
      }, label: { Text("At") }
    )
  }
  
  init(store: Store<ReminderCreationState, ReminderCreationAction>) {
    self.store = store
    self.viewStore = ViewStore(
      store.scope(
        state: { $0 },
        action: { ReminderCreationAction(action: $0)}
      )
    )
  }
}

struct TimeFrequencyRow_Previews: PreviewProvider {
  static var previews: some View {
    TimeFrequencyRow(
      store: Store(
        initialState: ReminderCreationState(),
        reducer: reminderCreationReducer,
        environment: ReminderCreationEnvironment()
      )
    )
  }
}

fileprivate extension ReminderCreationAction {
  init(action: TimeFrequencyRow.Action) {
    switch action {
    case .timeFrequencyChanged(let update):
      self = .timeFrequencyChanged(update)
    }
  }
}
