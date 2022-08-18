
import ComposableArchitecture
import SwiftUI

struct MonthlySelection: View {
  enum Action {
    case selectedMonthDaysChanged(Int)
  }
  
  private let monthDays = [
    [1, 2, 3, 4, 5, 6, 7],
    [8, 9, 10, 11, 12, 13, 14],
    [15, 16, 17, 18, 19, 20, 21],
    [22, 23, 24, 25, 26, 27, 28],
    [29, 30, 31]
  ]
  
  private let store: Store<ReminderCreationState, ReminderCreationAction>
  @ObservedObject var viewStore: ViewStore<ReminderCreationState, Self.Action>
  
  var body: some View {
    VStack {
      Grid {
        ForEach(monthDays, id: \.self) { week in
          GridRow {
            ForEach(week, id: \.self) { day in
              Button(action: { viewStore.send(.selectedMonthDaysChanged(day)) }) {
                Circle()
                  .overlay {
                    Text("\(day)")
                      .foregroundColor(.white)
                  }
              }
              .foregroundColor(viewStore.selectedMonthDays.contains(day) ? Color.pink : Color.secondary)
            }
          }
        }
      }
      .padding()
      Spacer()
    }
    .navigationTitle("Select days")
  }
  
  init(store: Store<ReminderCreationState, ReminderCreationAction>) {
    self.store = store
    self.viewStore = ViewStore(
      store.scope(
        state: { $0 },
        action: { ReminderCreationAction(action: $0) }
      )
    )
  }
}

struct MonthlySelection_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      MonthlySelection(
        store: Store(
          initialState: ReminderCreationState(),
          reducer: reminderCreationReducer,
          environment: .live
        )
      )
    }
  }
}

fileprivate extension ReminderCreationAction {
  init(action: MonthlySelection.Action) {
    switch action {
    case .selectedMonthDaysChanged(let update):
      self = .selectedMonthDaysChanged(update)
    }
  }
}
