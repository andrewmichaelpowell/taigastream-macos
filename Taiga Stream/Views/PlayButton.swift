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
			.contentShape(Circle())
			.glassBackground(
				Circle(),
				fill: Color.slot,
				tint: isPlaying ? Color(red: 84 / 255, green: 117 / 255, blue: 50 / 255) : nil
			)
		}
		.buttonStyle(.plain)
	}
}
