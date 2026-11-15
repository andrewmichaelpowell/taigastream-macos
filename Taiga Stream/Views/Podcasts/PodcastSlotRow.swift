//  Taiga Stream (macOS)
//  github.com/andrewmichaelpowell

import Foundation
import SwiftUI

struct PodcastSlotRow: View {
	let index: Int
	@EnvironmentObject var library: PodcastLibrary
	@ObservedObject private var player = PodcastPlayer.shared
	@State private var showingOptions = false
	@State private var showingManualEntry = false
	@State private var showingSearch = false
	@State private var manualUrl = ""
	@State private var manualName = ""

	var isAddButton = false

	var podcast: Podcast { library.podcast(at: index) }

	var body: some View {
		rowButton
			.sheet(isPresented: $showingOptions) {
				PodcastOptionsSheet(
					index: index,
					isPresented: $showingOptions,
					showingSearch: $showingSearch,
					showingManualEntry: $showingManualEntry,
					manualUrl: $manualUrl,
					manualName: $manualName
				)
				.environmentObject(library)
			}
			.sheet(isPresented: $showingSearch) {
				PodcastSearchSheet(
					slotIndex: index,
					isPresented: $showingSearch
				)
				.environmentObject(library)
			}
			.sheet(isPresented: $showingManualEntry) {
				PodcastURLSheet(
					slotIndex: index,
					isPresented: $showingManualEntry,
					manualUrl: $manualUrl,
					manualName: $manualName
				)
				.environmentObject(library)
			}
	}

	private var title: String {
		let name = podcast.name.trimmingCharacters(in: .whitespaces)
		return name.isEmpty ? podcast.feedUrl : name
	}

	private var episode: PodcastEpisode? {
		library.currentEpisode(for: podcast)
	}

	private var subtitle: String? {
		guard let episode else {
			if library.loadingFeeds.contains(podcast.id) {
				return String(localized: "Loading episodes…")
			}
			if library.failedFeeds.contains(podcast.id) {
				return String(localized: "Couldn't load episodes")
			}
			return nil
		}
		let isActive =
			player.activePodcastID == podcast.id
			&& player.activeEpisode?.id == episode.id
		let position =
			isActive
			? player.position
			: library.savedPosition(podcastID: podcast.id, episode: episode)
		let duration =
			isActive ? (player.duration ?? episode.duration) : episode.duration
		let detail =
			PodcastFormat.remaining(position: position, duration: duration)
			?? PodcastFormat.date(episode.publishedAt)
		let episodeTitle = episode.title.isEmpty ? nil : episode.title
		return [episodeTitle, detail].compactMap { $0 }.joined(separator: " · ")
	}

	@ViewBuilder
	private var rowButton: some View {
		if isAddButton {
			Button(action: { showingOptions = true }) {
				Text(Image(systemName: "plus"))
					.font(.title3)
					.foregroundColor(.primary)
					.frame(width: 50, height: 50)
					.contentShape(Circle())
					.circleGlass()
			}
			.buttonStyle(.plain)
			.accessibilityLabel(Text("Add Podcast"))
		} else {
			Button(action: { showingOptions = true }) {
				HStack(spacing: 12) {
					VStack(alignment: .leading, spacing: 2) {
						Text(title)
							.font(.body)
							.foregroundColor(.primary)
							.lineLimit(1)
							.truncationMode(
								podcast.name.isEmpty ? .middle : .tail
							)
						if let subtitle, !subtitle.isEmpty {
							Text(subtitle)
								.font(.caption)
								.foregroundColor(.secondary)
								.lineLimit(1)
						}
					}
					Spacer(minLength: 0)
				}
				.padding(.horizontal)
				.padding(.vertical, 8)
				.frame(maxWidth: .infinity, minHeight: 56, alignment: .leading)
				.contentShape(Rectangle())
				.frostedRowBackground()
			}
			.buttonStyle(.plain)
		}
	}
}

struct EpisodeButton: View {
	let podcast: Podcast
	@State private var showingEpisodes = false

	var body: some View {
		Button(action: { showingEpisodes = true }) {
			Text(Image(systemName: "list.bullet"))
				.font(.title3)
				.foregroundColor(.primary)
				.frame(width: 50, height: 50)
				.contentShape(Circle())
				.circleGlass()
		}
		.buttonStyle(.plain)
		.accessibilityLabel(Text("Episodes"))
		.sheet(isPresented: $showingEpisodes) {
			EpisodePickerSheet(
				podcastID: podcast.id,
				isPresented: $showingEpisodes
			)
		}
	}
}

struct PodcastPlayButton: View {
	let podcastNumber: Int
	@ObservedObject var streamInfo = StreamInfo.shared
	@ObservedObject var player = PodcastPlayer.shared
	@ObservedObject var library = PodcastLibrary.shared
	@State private var isStarting = false

	private var podcast: Podcast { library.podcast(at: podcastNumber - 1) }

	private var isPlaying: Bool {
		streamInfo.isPlaying && player.activePodcastID == podcast.id
			&& !podcast.feedUrl.isEmpty
	}

	private var showsSpinner: Bool {
		isStarting
			|| (player.activePodcastID == podcast.id && player.isBuffering)
	}

	var body: some View {
		Button(action: {
			if isPlaying {
				isStarting = false
				player.pause()
				return
			}
			guard !isStarting else { return }
			isStarting = true
			Task {
				await player.play(podcastNumber: podcastNumber)
				isStarting = false
			}
		}) {
			Group {
				if isPlaying {
					Text(Image(systemName: "pause.fill"))
						.foregroundColor(.white)
				} else if showsSpinner {
					ProgressView()
						.controlSize(.small)
				} else {
					Text("\(podcastNumber)")
						.foregroundColor(
							podcast.feedUrl.isEmpty
								? Color(nsColor: .quaternaryLabelColor)
								: .primary
						)
				}
			}
			.font(.title3)
			.frame(width: 50, height: 50)
			.contentShape(Circle())
			.circleGlass(isOn: isPlaying)
		}
		.buttonStyle(.plain)
		.accessibilityLabel(
			isPlaying ? Text("Pause") : Text("Play Podcast \(podcastNumber)")
		)
	}
}
