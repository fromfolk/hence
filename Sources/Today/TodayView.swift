
import ComposableArchitecture
import SwiftUI

public struct TodayView: View {
  let store: Store<TodayState, TodayAction>
  
  public var body: some View {
    WithViewStore(store) { viewStore in
      VStack {
        ForEach(viewStore.reminders) {
          Text($0.name)
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
          initialState: TodayState(),
          reducer: todayReducer,
          environment: ()
        )
      )
    }
  }
}
