
import ComposableArchitecture
import Foundation
import Hence
import SwiftDate

public enum DateFrequency: String, CaseIterable {
  case daily = "Day"
  case weekly = "Week"
  case monthly = "Month"
}

public enum TimeFrequency: String, CaseIterable {
  case morning = "Morning"
  case afternoon = "Afternoon"
  case evening = "Evening"
}

public struct ReminderCreationState: Equatable {
  public var reminders: IdentifiedArrayOf<Reminder>
  
  var name = String()
  var image = "circle"
  var dateFrequency = DateFrequency.daily
  var selectedWeekDays: [WeekDay] = Array()
  var selectedMonthDays: [Int] = Array()
  var timeFrequency = TimeFrequency.morning
  var showingBanner = false
  
  var isSaveDisabled: Bool {
    name.isEmpty || (dateFrequency == .weekly && selectedWeekDays.isEmpty) || (dateFrequency == .monthly && selectedMonthDays.isEmpty)
  }
  
  var concatenatedSelectedWeekDays: String {
    selectedWeekDays
      .map { $0.name(style: .short) }
      .joined(separator: ", ")
  }
  
  var concatenatedSelectedMonthDays: String {
    selectedMonthDays
      .map(String.init)
      .joined(separator: ", ")
  }
  
  public init(reminders: IdentifiedArrayOf<Reminder> = []) {
    self.reminders = reminders
  }
}

public enum ReminderCreationAction {
  case editName(String)
  case dateFrequencyChanged(DateFrequency)
  case selectedImageChanged(String)
  case selectedWeekDaysChanged(WeekDay)
  case selectedMonthDaysChanged(Int)
  case timeFrequencyChanged(TimeFrequency)
  case save
  case removeBanner
}

public struct ReminderCreationEnvironment {
  let uuid: () -> UUID
  let mainQueue: AnySchedulerOf<DispatchQueue>
  
  public init(uuid: @escaping () -> UUID, mainQueue: AnySchedulerOf<DispatchQueue>) {
    self.uuid = uuid
    self.mainQueue = mainQueue
  }
  
  public static var live = ReminderCreationEnvironment(uuid: UUID.init, mainQueue: .main)
}

public let reminderCreationReducer = Reducer<ReminderCreationState, ReminderCreationAction, ReminderCreationEnvironment> { state, action, environment in
  switch(action) {
  case .editName(let update):
    state.name = update
    return .none
    
  case .dateFrequencyChanged(let update):
    state.dateFrequency = update
    return .none
    
  case .selectedImageChanged(let update):
    state.image = update
    return .none
    
  case .selectedWeekDaysChanged(let update):
    if state.selectedWeekDays.contains(update) {
      state.selectedWeekDays.removeAll { $0 == update }
    } else {
      state.selectedWeekDays.append(update)
    }
    state.selectedWeekDays.sort(by: { $0.rawValue < $1.rawValue } )
    return .none
    
  case .selectedMonthDaysChanged(let update):
    if state.selectedMonthDays.contains(update) {
      state.selectedMonthDays.removeAll { $0 == update }
    } else {
      state.selectedMonthDays.append(update)
    }
    state.selectedMonthDays.sort()
    return .none
    
  case .timeFrequencyChanged(let update):
    state.timeFrequency = update
    return .none
    
  case .save:
    let reminder: Reminder
    
    switch state.dateFrequency {
    case .daily:
      reminder = Reminder(
        id: environment.uuid(),
        name: state.name,
        image: state.image,
        recurring: .daily(at: .init(state.timeFrequency))
      )
      
    case .weekly:
      reminder = Reminder(
        id: environment.uuid(),
        name: state.name,
        image: state.image,
        recurring: .weekly(on: state.selectedWeekDays, at: .init(state.timeFrequency))
      )
      
    case .monthly:
      reminder = Reminder(
        id: environment.uuid(),
        name: state.name,
        image: state.image,
        recurring: .monthly(on: state.selectedMonthDays, at: .init(state.timeFrequency))
      )
    }
    
    state.reminders.append(reminder)
    
    state.name = String()
    state.image = "circle"
    state.dateFrequency = DateFrequency.daily
    state.selectedWeekDays = Array()
    state.selectedMonthDays = Array()
    state.timeFrequency = TimeFrequency.morning
    state.showingBanner = true
    
    return .run { send in
      try await environment.mainQueue.sleep(for: .seconds(1))
      await send(.removeBanner)
    }
    
  case .removeBanner:
    state.showingBanner = false
    return .none
  }
}

fileprivate extension TimeOfDay {
  init(_ timeFrequency: TimeFrequency) {
    switch timeFrequency {
    case .morning:
      self = .morning
    case .afternoon:
      self = .afternoon
    case .evening:
      self = .evening
    }
  }
}
