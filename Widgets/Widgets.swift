//
//  Widgets.swift
//  Widgets
//
//  Created by Pavel on 15.01.2024.
//

import WidgetKit
import SwiftUI

@main
struct Widgets: Widget {
    let kind: String = "Widgets"

    var body: some WidgetConfiguration {
		StaticConfiguration(kind: kind,  provider: Provider()) { entry in
			TodoEntryView(entry: entry)
				.containerBackground(.clear, for: .widget)
        }
		.supportedFamilies([.systemLarge]) // list of supported widgets sizes
    }
}

#Preview(as: .systemLarge) {
    Widgets()
} timeline: {
	TodoWidgetEntry.preview
}
