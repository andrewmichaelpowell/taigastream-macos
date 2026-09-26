//  Taiga Stream (macOS)
//  github.com/andrewmichaelpowell

import Foundation
import SwiftUI

struct MainView: View {
	@ObservedObject var streamInfo = StreamInfo.shared

	var body: some View {
		List {
			edgeSpacer
			ForEach(Array(streamInfo.stations.enumerated()), id: \.element.id) {
				index,
				station in
				HStack(spacing: 12) {
					FaviconView(station: station)

					StreamSlotRow(index: index)
						.environmentObject(streamInfo)

					PlayButton(streamNumber: index + 1)

					Image(systemName: "line.3.horizontal")
						.font(.system(size: 25))
						.foregroundColor(Color(nsColor: .tertiaryLabelColor))
						.frame(width: 32, height: 50)
						.contentShape(Rectangle())
				}
				.frame(minHeight: 56)
				.listRowInsets(
					EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 0)
				)
				.listRowSeparator(.hidden)
				.moveDisabled(false)
				.deleteDisabled(true)
			}
			.onMove { source, destination in
				streamInfo.moveStation(from: source, to: destination)
			}
			edgeSpacer
		}
		.listStyle(.plain)
		.scrollContentBackground(.hidden)
		.environment(\.defaultMinListRowHeight, 0)
		.modifier(HardTopScrollEdge())
		.toolbar {
			TitleBarToolbar()
		}
	}

	private var edgeSpacer: some View {
		Color.clear
			.frame(height: 5)
			.listRowInsets(EdgeInsets())
			.listRowSeparator(.hidden)
			.moveDisabled(true)
			.deleteDisabled(true)
			.accessibilityHidden(true)
	}
}

private struct TitleBarToolbar: ToolbarContent {
	@ToolbarContentBuilder
	var body: some ToolbarContent {
		if #available(macOS 26.0, *) {
			ToolbarItem(placement: .navigation) {
				Image(systemName: "chevron.left")
					.hidden()
			}
			.sharedBackgroundVisibility(.hidden)
		} else {
			ToolbarItem(placement: .navigation) {
				Image(systemName: "chevron.left")
					.hidden()
			}
		}
	}
}

private struct HardTopScrollEdge: ViewModifier {
	func body(content: Content) -> some View {
		if #available(macOS 26.0, *) {
			content.scrollEdgeEffectStyle(.hard, for: .top)
		} else {
			content
		}
	}
}
