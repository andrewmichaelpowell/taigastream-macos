//  Taiga Stream (macOS)
//  github.com/andrewmichaelpowell

import AVKit
import SwiftUI

struct NowPlayingPanel: View {
	@ObservedObject private var streamInfo = StreamInfo.shared
	@ObservedObject private var player = PodcastPlayer.shared
	@ObservedObject private var library = PodcastLibrary.shared

	private static let artworkSide: CGFloat = 44
	private static let buttonSize: CGFloat = 22
	private static let buttonFrame: CGFloat = 36
	private static let routeSide: CGFloat = 26

	var body: some View {
		if player.isActive {
			podcastPanel
		} else if streamInfo.stations.indices.contains(
			streamInfo.currentStream - 1
		) {
			radioPanel
		} else {
			idlePanel
		}
	}

	private var idlePanel: some View {
		panel(title: "Taiga Stream", subtitle: "", showsAppIcon: true) {
			playButton("play.fill", label: Text("Play")) {}
				.disabled(true)
		}
	}

	private var podcastPanel: some View {
		let podcast = player.activePodcastID.flatMap { library.podcast(id: $0) }
		let episodeTitle = player.activeEpisode?.title ?? ""
		let podcastName = podcast?.name ?? ""
		return panel(
			title: episodeTitle.isEmpty ? podcastName : episodeTitle,
			subtitle: podcastName.isEmpty ? "Taiga Stream" : podcastName
		) {
			playButton(
				streamInfo.isPlaying ? "pause.fill" : "play.fill",
				label: streamInfo.isPlaying ? Text("Pause") : Text("Play")
			) {
				Task { await player.togglePlayPause() }
			}
		}
	}

	private var radioPanel: some View {
		let number = streamInfo.currentStream
		let title =
			streamInfo.radioTitle.isEmpty
			? streamInfo.fallbackTitle(forSlot: number) : streamInfo.radioTitle
		let artist =
			streamInfo.radioArtist.isEmpty
			? "Taiga Stream" : streamInfo.radioArtist
		return panel(title: title, subtitle: artist) {
			playButton(
				streamInfo.isPlaying ? "stop.fill" : "play.fill",
				label: streamInfo.isPlaying ? Text("Stop") : Text("Play")
			) {
				Task { await PlayStream.shared.play(streamNumber: number) }
			}
		}
	}

	private func panel<Button: View>(
		title: String,
		subtitle: String,
		showsAppIcon: Bool = false,
		@ViewBuilder button: () -> Button
	) -> some View {
		HStack(spacing: 12) {
			artwork(showsAppIcon: showsAppIcon)
			VStack(alignment: .leading, spacing: 2) {
				Text(title)
					.font(.headline)
					.lineLimit(1)
				Text(subtitle.isEmpty ? " " : subtitle)
					.font(.subheadline)
					.foregroundStyle(.secondary)
					.lineLimit(1)
			}
			.frame(maxWidth: .infinity, alignment: .leading)
			button()
			RoutePicker()
				.frame(width: Self.routeSide, height: Self.routeSide)
		}
		.padding(14)
		.frame(maxWidth: 600)
		.panelBackground()
		.padding(.horizontal, 16)
		.padding(.top, 8)
		.padding(.bottom, 8)
	}

	private func artwork(showsAppIcon: Bool) -> some View {
		let image =
			showsAppIcon
			? streamInfo.appIcon
			: streamInfo.nowPlayingArtwork ?? streamInfo.appIcon
		return Image(nsImage: image ?? NSImage())
			.resizable()
			.aspectRatio(contentMode: .fill)
			.frame(width: Self.artworkSide, height: Self.artworkSide)
			.clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
			.accessibilityHidden(true)
	}

	private func playButton(
		_ symbol: String,
		label: Text,
		action: @escaping () -> Void
	) -> some View {
		PlayButtonView(
			symbol: symbol,
			size: Self.buttonSize,
			frame: Self.buttonFrame,
			label: label,
			action: action
		)
	}
}

private struct PlayButtonView: View {
	let symbol: String
	let size: CGFloat
	let frame: CGFloat
	let label: Text
	let action: () -> Void

	@Environment(\.isEnabled) private var isEnabled

	var body: some View {
		Button(action: action) {
			Image(systemName: symbol)
				.font(.system(size: size, weight: .regular))
				.foregroundStyle(Color.primary.opacity(isEnabled ? 1 : 0.3))
				.frame(width: frame, height: frame)
				.contentShape(Rectangle())
		}
		.buttonStyle(.plain)
		.accessibilityLabel(label)
	}
}

private struct RoutePicker: NSViewRepresentable {
	func makeNSView(context: Context) -> AVRoutePickerView {
		let view = AVRoutePickerView()
		view.isRoutePickerButtonBordered = false
		return view
	}

	func updateNSView(_ nsView: AVRoutePickerView, context: Context) {}
}

extension View {
	@ViewBuilder
	fileprivate func panelBackground() -> some View {
		let shape = RoundedRectangle(cornerRadius: 10)
		if #available(macOS 26.0, *) {
			glassEffect(.regular, in: shape)
		} else {
			background(.regularMaterial, in: shape)
		}
	}
}
