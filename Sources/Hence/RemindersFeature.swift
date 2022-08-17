
import ComposableArchitecture
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
  case addReminder
  case setSheet(isPresented: Bool)
  case reminderCreation(ReminderCreationAction)
  case editModeChanged(EditMode)
  case deleteReminders(IndexSet)
  
  case reminder(id: Reminder.ID, action: ReminderAction)
}

public struct RemindersEnvironment {
  public init() {}
}

public let remindersReducer = Reducer<RemindersState, RemindersAction, RemindersEnvironment> { state, action, environment in
  switch action {
  case .addReminder:
    state.reminderCreation = ReminderCreationState(reminders: state.reminders)
    return .none
    
  case .setSheet(isPresented: true):
    state.reminderCreation = ReminderCreationState(reminders: state.reminders)
    return .none
    
  case .setSheet(isPresented: false):
    state.reminderCreation = nil
    return .none
    
  case .reminderCreation:
    return .none
    
  case .reminder:
    return .none
    
  case let .editModeChanged(editMode):
    state.editMode = editMode
    return .none
    
  case let .deleteReminders(indexSet):
    state.reminders.remove(atOffsets: indexSet)
    if state.reminders.isEmpty {
      state.editMode = .inactive
    }
    return .none
  }
}
.combined(
  with: reminderReducer.forEach(
    state: \RemindersState.reminders,
    action: /RemindersAction.reminder(id:action:),
    environment: { _ in () }
  )
)
