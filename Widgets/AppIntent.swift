//
//  AppIntent.swift
//  Widgets
//
//  Created by Pavel on 15.01.2024.
//

import WidgetKit
import AppIntents

struct MarkTaskDoneIntent: AppIntent {
	static var title: LocalizedStringResource = "Mark task as done"
	static var description = IntentDescription("Make task done or undone")
	
	// need to confirm AppIntent protocol
	init() {
		self.taskId = nil
	}
	
	init(_ taskId: String) {
		self.taskId = taskId
	}

	/// An identifier of task
	@Parameter(title: "Task Id")
	var taskId: String?
	
	func perform() async throws -> some IntentResult {
		// If the task ID is nil then we have nothing to do
		if taskId == nil { return .result() }
		
		// Get all tasks from the storage
		let allTasks = UserTask.getFromStore()
		
		// Trying to find a task by its ID
		if var task = allTasks.first(where: {$0.id.uuidString == taskId }) {
			// Switching the task completion status
			task.setStatus(isDone: !task.isDone)
			// Giving the user a 1.5 second grace period before the widget view is redrawn.
			try? await Task.sleep(nanoseconds: 1_500_000_000)
		}

		// Returning the .result() will update the widget's timeline and redraw the view.
		return .result()
	}
}
