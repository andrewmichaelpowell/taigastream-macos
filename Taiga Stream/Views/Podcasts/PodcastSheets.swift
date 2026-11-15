//  Taiga Stream (macOS)
//  github.com/andrewmichaelpowell

import Foundation
import SwiftUI

struct SheetButton: View {
	let title: LocalizedStringResource
	var role: ButtonRole? = nil
	var isEnabled = true
	var isLoading = false
	let action: () -> Void

	var body: some View {
		Button(action: action) {
			HStack {
				Spacer()
				if isLoading {
					ProgressView()
						.controlSize(.small)
						.frame(width: 16, height: 16)
						.padding(.trailing, 8)
				}
				Text(title)
					.bold()
					.foregroundColor(
						!isEnabled
							? Color(nsColor: .tertiaryLabelColor)
							: role == .destructive ? .red : Color.primary
					)
				Spacer()
			}
			.padding()
			.sheetButtonGlass()
		}
		.buttonStyle(.plain)
		.disabled(!isEnabled)
	}
}

struct SheetTextField: View {
	let systemImage: String
	@Binding var text: String
	var isURL = false
	var onSubmit: () -> Void = {}

	var body: some View {
		HStack {
			Image(systemName: systemImage)
				.foregroundColor(Color(nsColor: .tertiaryLabelColor))
			TextField("", text: $text)
				.textFieldStyle(.plain)
				.autocorrectionDisabled()
				.onSubmit(onSubmit)
		}
		.padding()
		.background(RoundedRectangle(cornerRadius: 10).fill(.thinMaterial))
	}
}

struct PodcastOptionsSheet: View {
	let index: Int
	@Binding var isPresented: Bool
	@Binding var showingSearch: Bool
	@Binding var showingManualEntry: Bool
	@Binding var manualUrl: String
	@Binding var manualName: String
	@EnvironmentObject var library: PodcastLibrary

	var podcast: Podcast { library.podcast(at: index) }

	var body: some View {
		VStack(spacing: 0) {
			VStack(spacing: 0) {
				VStack(spacing: 8) {
					SheetButton(title: "Search") {
						isPresented = false
						DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
							showingSearch = true
						}
					}
					SheetButton(title: "Enter URL") {
						manualUrl = podcast.feedUrl
						manualName = podcast.name
						isPresented = false
						DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
							showingManualEntry = true
						}
					}
					if !podcast.feedUrl.isEmpty {
						SheetButton(title: "Clear", role: .destructive) {
							library.clearPodcast(at: index)
							isPresented = false
						}
					}
					SheetButton(title: "Cancel") {
						isPresented = false
					}
				}
				.padding()
				Spacer()
			}
			.safeAreaInset(edge: .top, spacing: 0) {
				SheetTitle(Text("Podcast \(index + 1)"))
			}
		}
		.frame(width: 320)
	}
}

struct PodcastURLSheet: View {
	let slotIndex: Int
	@Binding var isPresented: Bool
	@Binding var manualUrl: String
	@Binding var manualName: String
	@EnvironmentObject var library: PodcastLibrary

	private var trimmedUrl: String {
		manualUrl.trimmingCharacters(in: .whitespaces)
	}

	private var isValidUrl: Bool {
		guard let url = URL(string: trimmedUrl),
			let scheme = url.scheme?.lowercased(),
			scheme == "http" || scheme == "https",
			let host = url.host,
			!host.isEmpty
		else { return false }
		return true
	}

	var body: some View {
		VStack(spacing: 0) {
			VStack(spacing: 0) {
				VStack(spacing: 8) {
					SheetTextField(systemImage: "mic", text: $manualName)
					SheetTextField(
						systemImage: "link",
						text: $manualUrl,
						isURL: true,
						onSubmit: save
					)
					SheetButton(
						title: "Save",
						isEnabled: isValidUrl,
						action: save
					)
					SheetButton(title: "Cancel") { isPresented = false }
				}
				.padding()
				Spacer()
			}
			.safeAreaInset(edge: .top, spacing: 0) {
				SheetTitle(Text("Enter URL"))
			}
		}
		.frame(width: 384, height: 580)
	}

	private func save() {
		guard isValidUrl else { return }
		let existing = library.podcast(at: slotIndex)
		library.savePodcast(
			Podcast(
				feedUrl: trimmedUrl,
				name: manualName.trimmingCharacters(in: .whitespaces),
				artworkUrl: existing.feedUrl == trimmedUrl
					? existing.artworkUrl : ""
			),
			at: slotIndex
		)
		isPresented = false
	}
}

struct PodcastSearchSheet: View {
	let slotIndex: Int
	@Binding var isPresented: Bool
	@EnvironmentObject var library: PodcastLibrary

	@State private var searchTerm = ""
	@State private var results: [PodcastSearchResult] = []
	@State private var isLoading = false
	@State private var hasSearched = false

	private var canSearch: Bool {
		!isLoading && !searchTerm.trimmingCharacters(in: .whitespaces).isEmpty
	}

	var body: some View {
		VStack(spacing: 0) {
			VStack(spacing: 0) {
				VStack(spacing: 8) {
					SheetTextField(
						systemImage: "magnifyingglass",
						text: $searchTerm,
						onSubmit: { if canSearch { performSearch() } }
					)
					SheetButton(
						title: "Search",
						isEnabled: canSearch,
						isLoading: isLoading,
						action: performSearch
					)
					SheetButton(title: "Cancel") { isPresented = false }
				}
				.padding()
				if hasSearched && results.isEmpty && !isLoading {
					Spacer()
					Text("No results")
						.foregroundColor(Color(nsColor: .tertiaryLabelColor))
					Spacer()
				} else {
					List(results) { result in
						PodcastSearchResultRow(result: result)
							.contentShape(Rectangle())
							.onTapGesture { select(result) }
					}
					.listStyle(.plain)
					.scrollContentBackground(.hidden)
				}
			}
			.safeAreaInset(edge: .top, spacing: 0) {
				SheetTitle(Text("Search"))
			}
		}
		.frame(width: 384, height: 580)
	}

	private func performSearch() {
		let term = searchTerm.trimmingCharacters(in: .whitespaces)
		guard !term.isEmpty else { return }
		hasSearched = true
		isLoading = true
		results = []
		Task {
			let found = await PodcastSearchClient.search(term)
			results = found
			isLoading = false
		}
	}

	private func select(_ result: PodcastSearchResult) {
		library.savePodcast(
			Podcast(
				feedUrl: result.feedUrl,
				name: result.name,
				artworkUrl: result.artworkUrl
			),
			at: slotIndex
		)
		isPresented = false
	}
}

struct PodcastSearchResultRow: View {
	let result: PodcastSearchResult

	var body: some View {
		HStack(spacing: 12) {
			PodcastArtworkView(
				podcast: Podcast(
					feedUrl: result.feedUrl,
					name: result.name,
					artworkUrl: result.artworkUrl
				)
			)
			VStack(alignment: .leading, spacing: 2) {
				Text(result.name)
					.font(.body)
					.lineLimit(1)
				if !result.author.isEmpty {
					Text(result.author)
						.font(.caption)
						.foregroundColor(.secondary)
						.lineLimit(1)
				}
				if !result.genre.isEmpty {
					Text(result.genre)
						.font(.caption)
						.foregroundColor(.secondary)
						.lineLimit(1)
				}
			}
			Spacer()
			Image(systemName: "chevron.right")
				.font(.caption)
				.foregroundColor(Color(nsColor: .tertiaryLabelColor))
		}
		.padding(.vertical, 4)
	}
}

struct EpisodePickerSheet: View {
	let podcastID: UUID
	@Binding var isPresented: Bool
	@ObservedObject private var library = PodcastLibrary.shared
	@ObservedObject private var player = PodcastPlayer.shared
	@ObservedObject private var streamInfo = StreamInfo.shared

	private var podcast: Podcast? { library.podcast(id: podcastID) }
	private var episodes: [PodcastEpisode] {
		library.feeds[podcastID]?.episodes ?? []
	}

	var body: some View {
		VStack(spacing: 0) {
			VStack(spacing: 0) {
				SheetButton(title: "Cancel") { isPresented = false }
					.padding()
				content
			}
			.safeAreaInset(edge: .top, spacing: 0) {
				SheetTitle(Text(podcast?.name ?? String(localized: "Episodes")))
			}
		}
		.frame(width: 384, height: 580)
		.task {
			if let podcast, library.feeds[podcastID] == nil {
				await library.refreshFeed(for: podcast)
			}
		}
	}

	@ViewBuilder
	private var content: some View {
		if episodes.isEmpty {
			Spacer()
			if library.loadingFeeds.contains(podcastID)
				|| (library.feeds[podcastID] == nil
					&& !library.failedFeeds.contains(podcastID))
			{
				ProgressView()
			} else {
				Text(
					library.failedFeeds.contains(podcastID)
						? "Couldn't load episodes" : "No episodes"
				)
				.foregroundColor(Color(nsColor: .tertiaryLabelColor))
			}
			Spacer()
		} else if let podcast {
			let selectedID = library.currentEpisode(for: podcast)?.id
			ScrollViewReader { proxy in
				List(episodes) { episode in
					EpisodeRow(
						episode: episode,
						podcast: podcast,
						isSelected: episode.id == selectedID,
						isPlaying: player.activePodcastID == podcastID
							&& player.activeEpisode?.id == episode.id
							&& streamInfo.isPlaying
					)
					.contentShape(Rectangle())
					.onTapGesture { select(episode, of: podcast) }
					.id(episode.id)
				}
				.listStyle(.plain)
				.scrollContentBackground(.hidden)
				.onAppear {
					if let selectedID {
						proxy.scrollTo(selectedID, anchor: .center)
					}
				}
			}
		}
	}

	private func select(_ episode: PodcastEpisode, of podcast: Podcast) {
		library.selectEpisode(episode, for: podcast)
		if player.activePodcastID == podcastID {
			Task { await player.play(episode, of: podcast) }
		}
		isPresented = false
	}
}

private struct EpisodeRow: View {
	let episode: PodcastEpisode
	let podcast: Podcast
	let isSelected: Bool
	let isPlaying: Bool
	@ObservedObject private var library = PodcastLibrary.shared
	@ObservedObject private var player = PodcastPlayer.shared

	private var position: Double {
		if player.activePodcastID == podcast.id,
			player.activeEpisode?.id == episode.id
		{
			return player.position
		}
		return library.savedPosition(podcastID: podcast.id, episode: episode)
	}

	private var details: String {
		var parts: [String] = []
		if let date = PodcastFormat.date(episode.publishedAt) {
			parts.append(date)
		}
		if let remaining = PodcastFormat.remaining(
			position: position,
			duration: episode.duration
		) {
			parts.append(remaining)
		} else if let duration = episode.duration {
			parts.append(PodcastFormat.duration(duration))
		}
		return parts.joined(separator: " · ")
	}

	var body: some View {
		HStack(spacing: 12) {
			Image(
				systemName: isPlaying
					? "speaker.wave.2.fill"
					: isSelected ? "checkmark" : "circle"
			)
			.font(.body)
			.foregroundColor(isSelected || isPlaying ? Color.primary : .clear)
			.frame(width: 24)
			VStack(alignment: .leading, spacing: 4) {
				Text(episode.title.isEmpty ? episode.audioUrl : episode.title)
					.font(.body)
					.foregroundColor(Color.primary)
					.lineLimit(2)
				if !details.isEmpty {
					Text(details)
						.font(.caption)
						.foregroundColor(.secondary)
						.lineLimit(1)
				}
				if let duration = episode.duration, duration > 0, position > 0 {
					ProgressView(value: min(position / duration, 1))
						.tint(Color.secondary)
				}
			}
			Spacer(minLength: 0)
		}
		.padding(.vertical, 4)
	}
}
