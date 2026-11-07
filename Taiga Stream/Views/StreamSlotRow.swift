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

	var isAddButton = false

	var station: RadioStation { streamInfo.station(at: index) }

	var body: some View {
		rowButton
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

	@ViewBuilder
	private var rowButton: some View {
		if isAddButton {
			Button(action: { showingOptions = true }) {
				ZStack {
					Circle()
						.fill(Color.slot)
					Text(Image(systemName: "plus"))
						.font(.title3)
						.foregroundColor(.primary)
				}
				.frame(width: 50, height: 50)
			}
			.buttonStyle(.plain)
			.accessibilityLabel(Text("Add Station"))
		} else {
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
		}
	}
}
