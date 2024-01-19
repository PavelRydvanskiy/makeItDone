//
//  TodoEntryView.swift
//  WidgetsExtension
//
//  Created by Pavel on 16.01.2024.
//

import SwiftUI

struct TodoEntryView: View {
	var entry: Provider.Entry

	var body: some View {
		VStack(alignment: .leading, spacing: 10) {
			
			// Header
			HStack (alignment: .firstTextBaseline) {
				Text("Make It Done")
					.font(.largeTitle)
					.padding(.bottom, 10)
				
				Spacer()
				
				// Show total uncompleted tasks
				Text(entry.tasks.count, format: .number)
					.font(.title)
			}

			// Task list (shows only the first 7 tasks to fit into the widget size)
			ForEach(entry.tasks.prefix(7), id: \.id) { task in
				// The Toggle will be marked as On immediately after user interaction,
				// without waiting for the result of the AppIntent.
				Toggle(isOn: task.isDone, intent: MarkTaskDoneIntent(task.id.uuidString)) {
					Text(task.text)
						.lineLimit(1)
				}
				.toggleStyle(CheckToggleStyle()) // Custom style to customise toggle view
				.frame(maxHeight: 30, alignment: .leading)
				
			}
			
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
		
	}
}

#Preview {
	TodoEntryView(entry: .preview)
}
