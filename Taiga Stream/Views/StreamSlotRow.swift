//  Taiga Stream (macOS)
//  github.com/andrewmichaelpowell

import Foundation
import SwiftUI

struct StreamSlotRow: View {
	let index: Int
	@EnvironmentObject var streamInfo: StreamInfo
	@State private var showingOptions = false
	@State private var showingManualEntry = false
	@State private var showingSearch = false
	@State private var manualUrl = ""
	@State private var manualName = ""

	var station: RadioStation { streamInfo.stations[index] }

	var body: some View {
		Button(action: { showingOptions = true }) {
			HStack(spacing: 12) {
				if !station.name.isEmpty {
					Text(station.name)
						.font(.body)
						.foregroundColor(.primary)
						.lineLimit(1)
				} else if !station.url.isEmpty {
					Text(station.url)
						.font(.body)
						.foregroundColor(.primary)
						.lineLimit(1)
						.truncationMode(.middle)
				}
				Spacer()
			}
			.padding()
			.frame(maxWidth: .infinity, minHeight: 56, alignment: .leading)
			.background(
				RoundedRectangle(cornerRadius: 10)
					.fill(Color.slot)
			)
		}
		.buttonStyle(.plain)
		.sheet(isPresented: $showingOptions) {
			StreamOptionsSheet(
				index: index,
				isPresented: $showingOptions,
				showingSearch: $showingSearch,
				showingManualEntry: $showingManualEntry,
				manualUrl: $manualUrl,
				manualName: $manualName
			)
			.environmentObject(streamInfo)
		}
		.sheet(isPresented: $showingSearch) {
			RadioBrowserSearchSheet(
				slotIndex: index,
				isPresented: $showingSearch
			)
			.environmentObject(streamInfo)
		}
		.sheet(isPresented: $showingManualEntry) {
			ManualURLSheet(
				slotIndex: index,
				isPresented: $showingManualEntry,
				manualUrl: $manualUrl,
				manualName: $manualName
			)
			.environmentObject(streamInfo)
		}
	}
}
