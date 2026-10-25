//  Taiga Stream (macOS)
//  github.com/andrewmichaelpowell

import Foundation
import SwiftUI

struct RadioBrowserSearchSheet: View {
	let slotIndex: Int
	@Binding var isPresented: Bool
	@EnvironmentObject var streamInfo: StreamInfo

	@State private var searchName = ""
	@State private var results: [RadioBrowserStation] = []
	@State private var isLoading = false
	@State private var hasSearched = false
	@State private var currentOffset = 0
	private let pageSize = 50

	var body: some View {
		NavigationStack {
			VStack(spacing: 0) {
				VStack(spacing: 8) {
					HStack {
						Image(systemName: "magnifyingglass")
							.foregroundColor(
								Color(nsColor: .tertiaryLabelColor)
							)
						TextField("", text: $searchName)
							.textFieldStyle(.plain)
							.autocorrectionDisabled()
							.onSubmit {
								if !searchName.isEmpty { performSearch() }
							}
					}
					.padding()
					.background(
						RoundedRectangle(cornerRadius: 10)
							.fill(Color.slot)
					)

					Button(action: performSearch) {
						HStack {
							Spacer()
							if isLoading {
								ProgressView()
									.controlSize(.small)
									.frame(width: 16, height: 16)
									.padding(.trailing, 8)
							}
							Text("Search")
								.bold()
								.foregroundColor(
									isLoading || searchName.isEmpty
										? Color(nsColor: .tertiaryLabelColor)
										: .primary
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
					.disabled(isLoading || searchName.isEmpty)

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
				if hasSearched && results.isEmpty && !isLoading {
					Spacer()
					Text("No results")
						.foregroundColor(Color(nsColor: .tertiaryLabelColor))
					Spacer()
				} else {
					List {
						ForEach(results) { station in
							RadioBrowserResultRow(station: station)
								.contentShape(Rectangle())
								.onTapGesture {
									selectStation(station)
								}
						}
						if results.count == pageSize
							* (currentOffset / pageSize + 1)
							&& !isLoading
						{
							Button(action: loadMore) {
								Text("More results")
									.frame(
										maxWidth: .infinity,
										alignment: .leading
									)
									.padding(.leading, 48)
									.padding(.top, 9)
									.padding(.bottom, 11)
							}
							.buttonStyle(.plain)
						}
						if isLoading && !results.isEmpty {
							HStack {
								Spacer()
								ProgressView()
									.controlSize(.small)
									.frame(width: 16, height: 16)
								Spacer()
							}
						}
					}
					.listStyle(.plain)
				}
			}
			.navigationTitle("Search")
		}
		.frame(width: 384, height: 580)
	}

	private var allFieldsEmpty: Bool { searchName.isEmpty }
	private func performSearch() {
		currentOffset = 0
		results = []
		hasSearched = true
		isLoading = true
		let params = RadioBrowserClient.SearchParams(
			name: searchName,
			limit: pageSize,
			offset: 0
		)
		RadioBrowserClient.shared.search(params: params) { stations in
			DispatchQueue.main.async {
				results = stations
				isLoading = false
			}
		}
	}

	private func loadMore() {
		isLoading = true
		currentOffset += pageSize
		let params = RadioBrowserClient.SearchParams(
			name: searchName,
			limit: pageSize,
			offset: currentOffset
		)
		RadioBrowserClient.shared.search(params: params) { stations in
			DispatchQueue.main.async {
				results.append(contentsOf: stations)
				isLoading = false
			}
		}
	}

	private func selectStation(_ station: RadioBrowserStation) {
		let saved = RadioStation(
			url: station.url,
			name: station.name,
			faviconUrl: station.faviconUrl
		)
		streamInfo.saveStation(saved, at: slotIndex)
		RadioBrowserClient.shared.recordClick(stationId: station.id)
		isPresented = false
	}
}
