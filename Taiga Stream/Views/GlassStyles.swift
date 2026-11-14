//  Taiga Stream (macOS)
//  github.com/andrewmichaelpowell

import AppKit
import Foundation
import SwiftUI

extension Color {
	static let taigaGreen = Color(red: 4 / 255, green: 80 / 255, blue: 48 / 255)

	static let taigaGreenIcon = Color(
		nsColor: NSColor(name: nil) { appearance in
			appearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua
				? NSColor(
					red: 111 / 255,
					green: 199 / 255,
					blue: 160 / 255,
					alpha: 1
				)
				: NSColor(
					red: 4 / 255,
					green: 80 / 255,
					blue: 48 / 255,
					alpha: 1
				)
		}
	)
}

extension View {
	@ViewBuilder
	func circleGlass(isOn: Bool = false) -> some View {
		if #available(macOS 26.0, *) {
			glassEffect(
				isOn
					? .regular.tint(.taigaGreen).interactive()
					: .regular.interactive(),
				in: Circle()
			)
		} else {
			background(Circle().fill(isOn ? Color.taigaGreen : Color.slot))
		}
	}

	func frostedRowBackground() -> some View {
		background(.thinMaterial, in: RoundedRectangle(cornerRadius: 10))
	}

	func rowDragPreview() -> some View {
		contentShape(
			.dragPreview,
			RoundedRectangle(cornerRadius: 16).inset(by: -6)
		)
	}
}
