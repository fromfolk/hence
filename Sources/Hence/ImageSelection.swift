
import ComposableArchitecture
import SwiftUI

struct ImageSelection: View {
  enum Action {
    case selectedImageChanged(String)
  }
  
  private let images = [
    [
      "circle",
      "square",
      "triangle"
    ],
    [
      "heart",
      "cross",
      "brain.head.profile"
    ],
    [
      "pc", "laptopcomputer", "iphone"
    ]
  ]
  
  let store: Store<ReminderCreationState, ReminderCreationAction>
  
  @ObservedObject var viewStore: ViewStore<ReminderCreationState, Self.Action>
  
  var body: some View {
    VStack {
      Grid {
        ForEach(images, id: \.self) { imageGroup in
          GridRow {
            ForEach(imageGroup, id: \.self) { image in
              Button(action: { viewStore.send(.selectedImageChanged(image)) }) {
                Circle()
                  .overlay {
                    Image(systemName: image)
                      .resizable()
                      .aspectRatio(contentMode: .fit)
                      .frame(width: 40)
                      .foregroundColor(.white)
                  }
              }
              .foregroundColor(viewStore.image == image ? Color.pink : Color.secondary)
            }
          }
        }
      }
      .padding()
      Spacer()
    }
    .navigationTitle("Select image")
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

struct ImageSelection_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      ImageSelection(
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
  init(action: ImageSelection.Action) {
    switch action {
    case .selectedImageChanged(let update):
      self = .selectedImageChanged(update)
    }
  }
}
