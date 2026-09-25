//  Taiga Stream (macOS)
//  github.com/andrewmichaelpowell

import AVFoundation
import Foundation

class PlayStream {
	static let shared = PlayStream()

	private func startStream(_ streamUrl: URL, streamNumber: Int) async {
		let newStreamItem = AVPlayerItem(url: streamUrl)
		let data = StreamInfo.shared

		data.audioPlayer.replaceCurrentItem(with: newStreamItem)
		data.currentStream = streamNumber
		data.currentStreamUrl = streamUrl
		data.resetKnownNowPlaying()
		data.isFallbackArtworkSet = false
		data.updateNowPlaying(title: data.fallbackTitle(forSlot: streamNumber))
		data.setFallbackArtwork()
		data.isFallbackArtworkSet = true
		data.observeMetadata()
		data.audioPlayer.play()
		data.startPlaybackHeartbeat()
		data.startMetadataPolling(streamUrl: streamUrl)
	}

	private func playAction(streamUrl: URL, streamNumber: Int) async {
		let data = StreamInfo.shared
		if data.isPlaying && data.currentStream == streamNumber {
			data.audioPlayer.pause()
			data.stopPlaybackHeartbeat()
			data.stopMetadataPolling()
			data.clearNowPlaying()
		} else {
			await startStream(streamUrl, streamNumber: streamNumber)
		}
	}

	public func play(streamNumber: Int) async {
		guard let url = URL(string: StreamInfo.shared.stream[streamNumber - 1])
		else { return }
		await playAction(streamUrl: url, streamNumber: streamNumber)
	}
}
