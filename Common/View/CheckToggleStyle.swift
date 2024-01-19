//
//  CheckToggleStyle.swift
//  MakeItDone
//
//  Created by Pavel on 16.01.2024.
//

import SwiftUI

struct CheckToggleStyle: ToggleStyle {
	func makeBody(configuration: Configuration) -> some View {
		Button {
			configuration.isOn.toggle()
		} label: {
			Label {
				configuration.label
					.strikethrough(configuration.isOn, color: .accentColor)
			} icon: {
				Image(systemName: configuration.isOn ? "checkmark.circle.fill" : "circle")
					.foregroundStyle(.accent)
					.accessibility(label: Text(configuration.isOn ? "Checked" : "Unchecked"))
					.imageScale(.large)
			}
		}
		.buttonStyle(.plain)
	}
}
