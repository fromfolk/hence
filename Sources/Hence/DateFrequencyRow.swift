
import ComposableArchitecture
import SwiftUI

struct DateFrequencyRow: View {
  enum Action {
    case dateFrequencyChanged(DateFrequency)
  }
  
  let store: Store<ReminderCreationState, ReminderCreationAction>
  @ObservedObject var viewStore: ViewStore<ReminderCreationState, Self.Action>
  
  var body: some View {
    Picker(
      selection: viewStore.binding(
        get: \.dateFrequency,
        send: Action.dateFrequencyChanged
      ), content: {
        ForEach(DateFrequency.allCases, id: \.self) { frequency in
          Text(frequency.rawValue)
            .tag(frequency)
        }
      }, label: { Text("Each") }
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

struct DateFrequencyRow_Previews: PreviewProvider {
  static var previews: some View {
    DateFrequencyRow(
      store: Store(
        initialState: ReminderCreationState(),
        reducer: reminderCreationReducer,
        environment: .live
      )
    )
  }
}

fileprivate extension ReminderCreationAction {
  init(action: DateFrequencyRow.Action) {
    switch action {
    case .dateFrequencyChanged(let update):
      self = .dateFrequencyChanged(update)
    }
  }
}
