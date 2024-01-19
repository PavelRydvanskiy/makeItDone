//
//  TodoWidgetEntry.swift
//  WidgetsExtension
//
//  Created by Pavel on 16.01.2024.
//

import WidgetKit

struct TodoWidgetEntry: TimelineEntry {
	/// The date for WidgetKit to render a widget. (required by TimelineEntry protocol)
	let date: Date
	
	/// The user tasks list for this date
	let tasks: [UserTask]
	
	/// Entry for preview (shows in the widget gallery)
	static var preview: TodoWidgetEntry {
		/// List of demo tasks
		let demoTasks: [UserTask] = [.init(id: .init(), creationDate: .now, text: "Demo task #1", isDone: false, doneDate: nil),
									 .init(id: .init(), creationDate: .now, text: "Demo task #2", isDone: false, doneDate: nil),
									 .init(id: .init(), creationDate: .now, text: "Demo task #3", isDone: true, doneDate: .now)]
		
		return TodoWidgetEntry(date: .now, tasks: demoTasks)
	}
	
	// Entry with the user's current tasks
	static var current: TodoWidgetEntry {
		
		// get all tasks sorted by creation date, excluding completed tasks
		let tasks = UserTask.getFromStore()
			.filter({ !$0.isDone }) // excluding completed tasks
			.sorted(by: { $0.creationDate > $1.creationDate }) // sort tasks by creation date
			
		return TodoWidgetEntry(date: .now, tasks: tasks)
	}
}
