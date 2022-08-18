
import ComposableArchitecture
import SwiftUI

public struct ReminderCreationView: View {
  private let store: Store<ReminderCreationState, ReminderCreationAction>
  
  public var body: some View {
    WithViewStore(store) { viewStore in
      ZStack {
        Form {
          Section {
            TextField(
              "Name",
              text: viewStore.binding(
                get: \.name,
                send: ReminderCreationAction.editName
              )
            )
            NavigationLink(destination: ImageSelection(store: store)) {
              HStack {
                Text("Image")
                Spacer()
                Image(systemName: viewStore.image)
              }
            }
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
                  Text(viewStore.concatenatedSelectedWeekDays)
                    .foregroundColor(.secondary)
                }
              }
              
            case .monthly:
              NavigationLink(destination: MonthlySelection(store: store)) {
                HStack {
                  Text("On")
                  Spacer()
                  Text(viewStore.concatenatedSelectedMonthDays)
                    .foregroundColor(.secondary)
                }
              }
            }
            
            TimeFrequencyRow(store: store)
          }
        }
        .toolbar {
          ToolbarItem {
            Button(action: { viewStore.send(.save) }) {
              Text("Save")
            }
            .disabled(viewStore.isSaveDisabled)
          }
        }
        
        if viewStore.showingBanner {
          Text("Reminder Saved")
            .font(.title3)
            .foregroundColor(.white)
            .padding()
            .background(Color.pink)
            .cornerRadius(10)
            .shadow(radius: 5)
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
          environment: .live
        )
      )
    }
  }
}
