//  Taiga Stream (macOS)
//  github.com/andrewmichaelpowell

import Foundation
import SwiftUI

struct MainView: View {
	@ObservedObject var streamInfo = StreamInfo.shared

	var body: some View {
		List {
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
		}
		.listStyle(.plain)
		.scrollContentBackground(.hidden)
	}
}
