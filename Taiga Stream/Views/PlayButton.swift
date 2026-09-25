//  Taiga Stream (macOS)
//  github.com/andrewmichaelpowell

import Foundation
import SwiftUI

struct PlayButton: View {
	let streamNumber: Int
	@ObservedObject var streamInfo = StreamInfo.shared

	private var isPlaying: Bool {
		streamInfo.isPlaying && streamInfo.currentStream == streamNumber
			&& streamInfo.stream[streamNumber - 1] != ""
	}

	private var isConfigured: Bool {
		streamInfo.stream[streamNumber - 1] == ""
	}

	var body: some View {
		Button(action: {
			Task { await PlayStream.shared.play(streamNumber: streamNumber) }
		}) {
			ZStack {
				Circle()
					.fill(isPlaying ? Color(.mint) : Color.slot)
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
