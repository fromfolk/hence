
import ComposableArchitecture
import SwiftDate
import SwiftUI

struct WeeklySelection: View {
  enum Action {
    case selectedWeekDaysChanged(WeekDay)
  }
  
  let store: Store<ReminderCreationState, ReminderCreationAction>
  @ObservedObject var viewStore: ViewStore<ReminderCreationState, Self.Action>
  
  var body: some View {
    List {
      ForEach(viewStore.weekDays, id: \.rawValue) { weekDay in
        Button(action: { viewStore.send(.selectedWeekDaysChanged(weekDay)) }) {
          HStack {
            Text(weekDay.name(style: .default))
              .foregroundColor(.primary)
            Spacer()
            if viewStore.selectedWeekDays.contains(weekDay) {
              Image(systemName: "checkmark")
            }
          }
        }
      }
    }
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

struct WeeklySelection_Previews: PreviewProvider {
  static var previews: some View {
    WeeklySelection(
      store: Store(
        initialState: ReminderCreationState(),
        reducer: reminderCreationReducer,
        environment: ReminderCreationEnvironment()
      )
    )
  }
}

fileprivate extension ReminderCreationAction {
  init(action: WeeklySelection.Action) {
    switch action {
    case .selectedWeekDaysChanged(let update):
      self = .selectedWeekDaysChanged(update)
    }
  }
}
