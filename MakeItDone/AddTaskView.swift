//
//  AddTaskView.swift
//  MakeItDone
//
//  Created by Pavel on 15.01.2024.
//

import SwiftUI

struct AddTaskView: View {
	/// Task description
	@State private var newTask: String = ""
	
	/// Parent action to create new task
	private let createTaskAction: (_ : UserTask) -> Void
	
	init(_ createTaskAction: @escaping (_ : UserTask) -> Void) {
		self.createTaskAction = createTaskAction
	}
	
	
	/// An action that is called all the time when the Create button is clicked
	func createNewTask() {
		// 1. Gather all information into a task structure
		let newTask = UserTask(id: .init(), creationDate: .now, text: newTask, isDone: false)
		// 2. Calls parent action
		createTaskAction(newTask)
	}
	
	var body: some View {
		VStack(alignment: .leading, spacing: 20) {
			
			Text("Add new task")
				.font(.title)
				.frame(maxWidth: .infinity, alignment: .center)
				.padding(.bottom, 20)
			
			TextField("Describe a task...", text: $newTask, axis: .vertical)
				.textFieldStyle(.roundedBorder)
				.lineLimit(5...10)
				.onSubmit(createNewTask)
			
			Spacer()
			
			Button(action: createNewTask) {
				Text("Create")
					.padding(10)
					.foregroundColor(.white)
					.fontWeight(.bold)
					.frame(maxWidth: .infinity, alignment: .center)
					.background(
						RoundedRectangle(cornerRadius: 4, style: .continuous)
							.fill(.accent)
							.frame(maxWidth: .infinity, alignment: .center)
					)
				
			}
		}
		.padding(20)
		.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
		.presentationDetents([.height(300)])
		.presentationDragIndicator(.hidden)
	}
}

#Preview {
	AddTaskView({ _ in })
}
