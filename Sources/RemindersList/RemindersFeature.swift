
import ComposableArchitecture
import Reminder
import SwiftUI

public struct RemindersState: Equatable {
  public var reminders: IdentifiedArrayOf<Reminder>
  public var isSheetPresented: Bool { self.reminderCreation != nil }
  public var editMode: EditMode = .inactive
  public var noReminders: Bool {
    reminders.isEmpty
  }
  
  private var internalCreationState: ReminderCreationState? = nil
  
  public var reminderCreation: ReminderCreationState? {
    get {
      internalCreationState
    }
    set {
      self.internalCreationState = newValue
      
      guard let value = newValue else { return }
      self.reminders = value.reminders
    }
  }
  
  public init(reminders: IdentifiedArrayOf<Reminder> = []) {
    self.reminders = reminders
  }
}

public enum RemindersAction {
  case editModeChanged(EditMode)
  case addReminder
  case deleteReminders(IndexSet)
  case setSheet(isPresented: Bool)
  
  case reminderCreation(ReminderCreationAction)
}

public let remindersReducer = Reducer<RemindersState, RemindersAction, ()> { state, action, _ in
  switch action {
  case let .editModeChanged(editMode):
    state.editMode = editMode
    return .none
    
  case .addReminder:
    state.reminderCreation = ReminderCreationState(reminders: state.reminders)
    return .none
    
  case let .deleteReminders(indexSet):
    state.reminders.remove(atOffsets: indexSet)
    if state.reminders.isEmpty {
      state.editMode = .inactive
    }
    return .none
    
  case .setSheet(isPresented: true):
    state.reminderCreation = ReminderCreationState(reminders: state.reminders)
    return .none
    
  case .setSheet(isPresented: false):
    state.reminderCreation = nil
    return .none
    
  case .reminderCreation:
    return .none
  }
}
