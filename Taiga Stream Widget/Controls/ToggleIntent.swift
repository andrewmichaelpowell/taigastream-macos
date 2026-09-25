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
