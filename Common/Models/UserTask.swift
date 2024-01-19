//
//  UserTask.swift
//  MakeItDone
//
//  Created by Pavel on 16.01.2024.
//

import Foundation

struct UserTask: Identifiable, Codable {
	
	/// Unique task identifier
	let id: UUID
	/// Task creation date
	let creationDate: Date
	/// Task description
	let text: String
	/// Task status. YES, if the task is completed
	private(set) var isDone: Bool
	/// The date the task was completed. nil if not done
	private(set) var doneDate: Date?
	
	/// Get all tasks from store
	/// - Returns: all tasks from store
	static func getFromStore() -> [UserTask] {
		if let jsonData = (UserDefaults(suiteName: "group.com.makeItDone")!.string(forKey: "tasks") ?? "").data(using: .utf8) {
			return (try? JSONDecoder().decode([UserTask].self, from: jsonData)) ?? []
		}
		return []
	}
	
	/// Save task list to store
	/// - Parameter newTasks: new task list
	static func saveToStore(_ newTasks: [UserTask] ) {
		// 1. serialize array to JSON string
		if let jsonData = try? JSONEncoder().encode(newTasks) {
			let jsonString = String(data: jsonData, encoding: .utf8)!
			// 2. save JSON string to UserDefaults
			UserDefaults(suiteName: "group.com.makeItDone")!.set(jsonString, forKey: "tasks")
		}
	}
	
	/// Change status of task
	/// - Parameter isDone: YES if task is completed
	mutating func setStatus(isDone: Bool) {
		// 1. change status
		self.isDone = isDone
		// 2. save or delete done date information
		self.doneDate = isDone ? .now : nil
		// 3. update/save task in store
		addOrUpdate()
	}
	
	/// Add or update/save task in store
	func addOrUpdate() {
		// 1. get all tasks
		var allTasks = UserTask.getFromStore()
		
		// 2. try to find task in store
		if let index = allTasks.firstIndex(where: { $0.id == self.id }) {
			// task exists, updating
			allTasks[index] = self
		} else {
			// it's a new task, add new
			allTasks.append(self)
		}
		
		// 3. save all changes to the store
		UserTask.saveToStore(allTasks)
	}
	
}
