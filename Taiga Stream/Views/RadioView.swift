//  Taiga Stream (macOS)
//  github.com/andrewmichaelpowell

import Foundation
import SwiftUI

struct RadioView: View {
	@ObservedObject var streamInfo = StreamInfo.shared

	var body: some View {
		List {
			ListEdgeSpacer()
			ForEach(Array(streamInfo.stations.enumerated()), id: \.element.id) {
				index,
				station in
				HStack(spacing: 12) {
					FaviconView(station: station)

					StreamSlotRow(index: index)
						.environmentObject(streamInfo)

					PlayButton(streamNumber: index + 1)
				}
				.frame(minHeight: 56)
				.rowDragPreview()
				.listRowInsets(
					EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16)
				)
				.listRowSeparator(.hidden)
				.listRowBackground(Color.clear)
				.moveDisabled(false)
				.deleteDisabled(true)
			}
			.onMove { source, destination in
				streamInfo.moveStation(from: source, to: destination)
			}
			HStack {
				Spacer()
				StreamSlotRow(
					index: streamInfo.stations.count,
					isAddButton: true
				)
				.environmentObject(streamInfo)
				Spacer()
			}
			.frame(minHeight: 56)
			.listRowInsets(
				EdgeInsets(top: 16, leading: 16, bottom: 4, trailing: 16)
			)
			.listRowSeparator(.hidden)
			.listRowBackground(Color.clear)
			.moveDisabled(true)
			.deleteDisabled(true)
			ListEdgeSpacer()
		}
		.listStyle(.plain)
		.scrollContentBackground(.hidden)
		.environment(\.defaultMinListRowHeight, 0)
	}
}

struct ListEdgeSpacer: View {
	var body: some View {
		Color.clear
			.frame(height: 5)
			.listRowInsets(EdgeInsets())
			.listRowSeparator(.hidden)
			.listRowBackground(Color.clear)
			.moveDisabled(true)
			.deleteDisabled(true)
			.accessibilityHidden(true)
	}
}
