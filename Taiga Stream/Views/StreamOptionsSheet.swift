//  Taiga Stream (macOS)
//  github.com/andrewmichaelpowell

import Foundation
import SwiftUI

struct StreamOptionsSheet: View {
	let index: Int
	@Binding var isPresented: Bool
	@Binding var showingSearch: Bool
	@Binding var showingManualEntry: Bool
	@Binding var manualUrl: String
	@Binding var manualName: String
	@EnvironmentObject var streamInfo: StreamInfo

	var station: RadioStation { streamInfo.stations[index] }

	var body: some View {
		NavigationStack {
			VStack(spacing: 8) {
				optionButton("Search") {
					isPresented = false
					DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
						showingSearch = true
					}
				}
				optionButton("Enter URL") {
					manualUrl = station.url
					manualName = station.name
					isPresented = false
					DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
						showingManualEntry = true
					}
				}
				if !station.url.isEmpty {
					optionButton("Clear", role: .destructive) {
						streamInfo.saveStation(.empty, at: index)
						isPresented = false
					}
				}
				optionButton("Cancel") {
					isPresented = false
				}
			}
			.padding()
			.navigationTitle("Stream \(index + 1)")
		}
		.frame(width: 320)
	}

	@ViewBuilder
	private func optionButton(
		_ title: LocalizedStringResource,
		role: ButtonRole? = nil,
		action: @escaping () -> Void
	) -> some View {
		Button(action: action) {
			HStack {
				Spacer()
				Text(title)
					.bold()
					.foregroundColor(
						role == .destructive ? .red : .primary
					)
				Spacer()
			}
			.padding()
			.background(
				RoundedRectangle(cornerRadius: 10)
					.fill(Color.slot)
			)
		}
		.buttonStyle(.plain)
	}
}
