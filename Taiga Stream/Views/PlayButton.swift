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
			Group {
				if isPlaying {
					Text(Image(systemName: "stop.fill"))
						.foregroundColor(.white)
				} else {
					Text("\(streamNumber)")
						.foregroundColor(
							isConfigured
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
	}
}
