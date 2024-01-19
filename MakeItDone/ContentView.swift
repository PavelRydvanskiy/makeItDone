//
//  ContentView.swift
//  MakeItDone
//
//  Created by Pavel on 15.01.2024.
//

import SwiftUI
import WidgetKit

struct ContentView: View {
	@Environment(\.scenePhase) var scenePhase
	@State private var tasks: [UserTask] = []
	@State private var showingAddTask: Bool = false
	
	
	/// Reread tasks from store
	private func rereadUserTasks() {
		tasks = UserTask.getFromStore().sorted(by: { $0.creationDate > $1.creationDate })
	}
	
	
	/// Create a binding to a toggle
	/// - Parameter task: task
	/// - Returns: Binding
	private func toggleBinding(_ task: UserTask) -> Binding<Bool> {
		Binding {
			// toggle state
			task.isDone
		} set: { newValue in
			// action on change of toggle state
			var newTask = task
			newTask.setStatus(isDone: newValue)
			rereadUserTasks()
		}
		
	}
	
	/// Action which calls when user filled all data to new task and press add task button
	/// - Parameter newTask: newTask
	private func createTaskAction(_ newTask: UserTask) {
		// 1. save new task to the store
		newTask.addOrUpdate()
		// 2. reread all tasks from store
		rereadUserTasks()
		// 3. close add new task dialog window
		showingAddTask.toggle()
	}
	
	/// Delete action
	/// - Parameter offsets: ids to be deleted
	private func deleteAction(at offsets: IndexSet) {
		// 1. make a copy of a current task list
		var newTasks = tasks
		// 2. delete all ids
		newTasks.remove(atOffsets: offsets)
		// 3. save modified tasks list to a store
		UserTask.saveToStore(newTasks)
		// 4. reread and show all tasks from store
		rereadUserTasks()
	}
	
	var body: some View {
		ZStack(alignment: .bottom) {
			//MARK: Tasks list
			VStack(alignment: .leading, spacing: 10) {
				
				NavigationStack {
					List {
						ForEach(tasks, id: \.id) { task in
							Toggle(isOn: toggleBinding(task)) {
								Text(task.text)
							}
							.toggleStyle(CheckToggleStyle())
							.listRowSeparator(.hidden)
						}
						.onDelete(perform: deleteAction)
					}
					.listStyle(.inset)
					.navigationTitle("Todo list")
				}
				
			}
			.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
			.padding(.bottom, 50) // leave a space for "Add Task" button

			//MARK: Add new task button
			Button(action: { showingAddTask.toggle() }) {
				Text("Add task")
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
			.padding(.horizontal, 20)
		}
		.sheet(isPresented: $showingAddTask) { AddTaskView(createTaskAction) }
		.onChange(of: scenePhase) {
			// intercept changes in application state to synchronise the data displayed to the user
			switch scenePhase {
			case .active:
				// always reread all tasks from store when app goes from background to foreground to sync changes made in widget
				rereadUserTasks()
			case .background:
				// update widget timeline to sync changes while app goes to background
				WidgetCenter.shared.reloadAllTimelines()
			default:
				break
			}

		}
		
	}
}

#Preview {
	ContentView()
}
