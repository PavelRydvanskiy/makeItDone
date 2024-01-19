//
//  Provider.swift
//  WidgetsExtension
//
//  Created by Pavel on 16.01.2024.
//

import WidgetKit

struct Provider: TimelineProvider {
	
	func getSnapshot(in context: Context, completion: @escaping (TodoWidgetEntry) -> Void) {
		if context.isPreview {
			// if isPreview, then it was called from the widget gallery
			return completion(TodoWidgetEntry.preview)
		}
		
		completion(TodoWidgetEntry.current)
	}
	
	func getTimeline(in context: Context, completion: @escaping (Timeline<TodoWidgetEntry>) -> Void) {

		if context.isPreview {
			// if isPreview, then it was called from the widget gallery
			return completion( Timeline(entries: [TodoWidgetEntry.preview], policy: .never))
		}

		completion( Timeline(entries: [TodoWidgetEntry.current], policy: .never))
	}
	
	func placeholder(in context: Context) -> TodoWidgetEntry {
		TodoWidgetEntry.preview
	}
}
