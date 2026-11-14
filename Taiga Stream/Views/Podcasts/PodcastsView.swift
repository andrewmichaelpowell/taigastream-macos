//  Taiga Stream (macOS)
//  github.com/andrewmichaelpowell

import Foundation
import SwiftUI

struct PodcastsView: View {
	@ObservedObject var library = PodcastLibrary.shared

	var body: some View {
		List {
			ListEdgeSpacer()
			ForEach(Array(library.podcasts.enumerated()), id: \.element.id) {
				index,
				podcast in
				HStack(spacing: 12) {
					PodcastArtworkView(podcast: podcast)

					PodcastSlotRow(index: index)
						.environmentObject(library)

					EpisodeButton(podcast: podcast)

					PodcastPlayButton(podcastNumber: index + 1)
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
				library.movePodcast(from: source, to: destination)
			}

			HStack {
				Spacer()
				PodcastSlotRow(index: library.podcasts.count, isAddButton: true)
					.environmentObject(library)
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
		.task { await library.refreshAllFeeds() }
	}
}

struct PodcastArtworkView: View {
	let podcast: Podcast

	var body: some View {
		FaviconView(
			station: RadioStation(
				url: podcast.feedUrl,
				name: podcast.name,
				faviconUrl: podcast.artworkUrl
			),
			fallbackSystemImage: "mic"
		)
	}
}

enum PodcastFormat {
	static func duration(_ seconds: Double) -> String {
		let rounded = max(seconds.rounded(), 60)
		return Duration.seconds(rounded).formatted(
			.units(allowed: [.hours, .minutes], width: .abbreviated)
		)
	}

	static func remaining(position: Double, duration: Double?) -> String? {
		guard let duration, duration > 0, position > 0 else { return nil }
		let left = duration - position
		guard left > 0 else { return nil }
		return String(localized: "\(Self.duration(left)) left")
	}

	static func date(_ date: Date?) -> String? {
		date?.formatted(date: .abbreviated, time: .omitted)
	}
}
