//  Taiga Stream (macOS)
//  github.com/andrewmichaelpowell

import Foundation
import SwiftUI

struct ManualURLSheet: View {
	let slotIndex: Int
	@Binding var isPresented: Bool
	@Binding var manualUrl: String
	@EnvironmentObject var streamInfo: StreamInfo
	@Binding var manualName: String

	var station: RadioStation { streamInfo.stations[slotIndex] }

	private var isValidUrl: Bool {
		guard
			let url = URL(
				string: manualUrl.trimmingCharacters(in: .whitespaces)
			),
			let scheme = url.scheme?.lowercased(),
			scheme == "http" || scheme == "https",
			let host = url.host,
			!host.isEmpty
		else { return false }
		return true
	}

	var body: some View {
		NavigationStack {
			VStack(spacing: 0) {
				VStack(spacing: 8) {
					HStack {
						Image(systemName: "radio")
							.foregroundColor(
								Color(nsColor: .tertiaryLabelColor)
							)
						TextField("", text: $manualName)
							.textFieldStyle(.plain)
							.autocorrectionDisabled()
					}
					.padding()
					.background(
						RoundedRectangle(cornerRadius: 10)
							.fill(Color.slot)
					)
					HStack {
						Image(systemName: "link")
							.foregroundColor(
								Color(nsColor: .tertiaryLabelColor)
							)
						TextField("", text: $manualUrl)
							.textFieldStyle(.plain)
							.autocorrectionDisabled()
							.onSubmit { save() }
					}
					.padding()
					.background(
						RoundedRectangle(cornerRadius: 10)
							.fill(Color.slot)
					)

					Button(action: save) {
						HStack {
							Spacer()
							Text("Save")
								.bold()
								.foregroundColor(
									isValidUrl
										? .primary
										: Color(nsColor: .quaternaryLabelColor)
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
					.disabled(!isValidUrl)

					Button(action: { isPresented = false }) {
						HStack {
							Spacer()
							Text("Cancel")
								.bold()
								.foregroundColor(.primary)
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
				.padding()
				Spacer()
			}
			.navigationTitle("Enter URL")
		}
		.frame(width: 384, height: 580)
	}

	private func save() {
		guard isValidUrl else { return }
		let saved = RadioStation(
			url: manualUrl.trimmingCharacters(in: .whitespaces),
			name: manualName.trimmingCharacters(in: .whitespaces),
			faviconUrl: station.faviconUrl
		)
		streamInfo.saveStation(saved, at: slotIndex)
		isPresented = false
	}
}
