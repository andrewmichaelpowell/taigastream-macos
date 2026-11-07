//  Taiga Stream (macOS)
//  github.com/andrewmichaelpowell

import Foundation
import SwiftUI

struct PlayButton: View {
	let streamNumber: Int
	@ObservedObject var streamInfo = StreamInfo.shared

	private var url: String {
		streamInfo.station(at: streamNumber - 1).url
	}

	private var isPlaying: Bool {
		streamInfo.isPlaying && streamInfo.currentStream == streamNumber
			&& !url.isEmpty
	}

	private var isConfigured: Bool {
		url.isEmpty
	}

	var body: some View {
		Button(action: {
			Task { await PlayStream.shared.play(streamNumber: streamNumber) }
		}) {
			ZStack {
				Circle()
					.fill(
						isPlaying
							? Color(
								red: 4 / 255,
								green: 80 / 255,
								blue: 48 / 255
							) : Color.slot
					)
				if isPlaying {
					Text(Image(systemName: "stop.fill"))
						.font(.title3)
						.foregroundColor(.white)
				} else {
					Text("\(streamNumber)")
						.font(.title3)
						.foregroundColor(
							isConfigured
								? Color(nsColor: .quaternaryLabelColor)
								: .primary
						)
				}
			}
			.frame(width: 50, height: 50)
		}
		.buttonStyle(.plain)
	}
}
