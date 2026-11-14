//  Taiga Stream (macOS)
//  github.com/andrewmichaelpowell

import AppIntents
import Foundation

struct ToggleIntent: SetValueIntent, AudioPlaybackIntent {
	static let title: LocalizedStringResource = "Play Stream"
	@Parameter(title: "Stream Number") var streamNumber: Int
	@Parameter(title: "Stream Status") var value: Bool

	init(streamNumber: Int) { self.streamNumber = streamNumber }
	init() { self.streamNumber = 1 }

	@MainActor func perform() async throws -> some IntentResult {
		await PlayStream.shared.play(streamNumber: streamNumber)
		return .result()
	}
}

struct PodcastToggleIntent: SetValueIntent, AudioPlaybackIntent {
	static let title: LocalizedStringResource = "Play Podcast"
	@Parameter(title: "Podcast Number") var podcastNumber: Int
	@Parameter(title: "Podcast Status") var value: Bool

	init(podcastNumber: Int) { self.podcastNumber = podcastNumber }
	init() { self.podcastNumber = 1 }

	@MainActor func perform() async throws -> some IntentResult {
		await PodcastPlayer.shared.play(podcastNumber: podcastNumber)
		return .result()
	}
}
