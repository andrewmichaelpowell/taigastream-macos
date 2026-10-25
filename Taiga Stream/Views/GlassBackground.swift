//  Taiga Stream (macOS)
//  github.com/andrewmichaelpowell

import SwiftUI

extension View {
	@ViewBuilder
	func glassBackground<S: Shape>(
		_ shape: S,
		fill: Color,
		tint: Color? = nil
	) -> some View {
		if #available(macOS 26.0, *) {
			contentShape(shape)
				.glassEffect(.regular.tint(tint).interactive(), in: shape)
		} else {
			background(shape.fill(tint ?? fill))
		}
	}
}

extension View {
	@ViewBuilder
	func sheetButtonBackground() -> some View {
		if #available(macOS 26.0, *) {
			contentShape(RoundedRectangle(cornerRadius: 10))
		} else {
			background(RoundedRectangle(cornerRadius: 10).fill(Color.slot))
		}
	}

	@ViewBuilder
	func sheetButtonStyle() -> some View {
		if #available(macOS 26.0, *) {
			buttonStyle(.glass)
				.buttonBorderShape(.roundedRectangle(radius: 10))
		} else {
			buttonStyle(.plain)
		}
	}
}
