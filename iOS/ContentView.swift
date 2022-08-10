
import ComposableArchitecture
import Hence
import SwiftUI

struct ContentView: View {
  let store: Store<HenceState, HenceAction>
  
  var body: some View {
    WithViewStore(store) { viewStore in
      VStack {
        Button(action: { viewStore.send(.showMessage) } ) {
          Image(systemName: "globe")
            .imageScale(.large)
        }
        Text(viewStore.text)
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView(
        store: Store(
          initialState: HenceState(),
          reducer: appReducer,
          environment: HenceEnvironment()
        )
    )
  }
}
