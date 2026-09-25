//  Taiga Stream (macOS)
//  github.com/andrewmichaelpowell

import AppKit
import Foundation
import SwiftUI

struct FaviconView: View {
	let station: RadioStation
	@State private var favicon: NSImage? = nil
	@State private var faviconNeedsBackground = false
	@State private var faviconNeedsInset = false
	@State private var faviconLoadFailed = false
	@State private var fallbackIcon: NSImage? = nil

	private var isSavedWithoutFavicon: Bool {
		!station.url.isEmpty
			&& (faviconLoadFailed || URL(string: station.faviconUrl) == nil
				|| station.faviconUrl.isEmpty)
	}

	var body: some View {
		Group {
			if let favicon {
				Image(nsImage: favicon)
					.resizable()
					.aspectRatio(contentMode: .fit)
					.scaleEffect(
						faviconNeedsInset
							? StreamInfo.transparentIconInset : 1
					)
					.frame(width: 36, height: 36)
					.background(
						faviconNeedsBackground ? Color.white : Color.clear
					)
			} else if isSavedWithoutFavicon,
				let appIcon = StreamInfo.shared.appIcon
			{
				Image(nsImage: appIcon)
					.resizable()
					.aspectRatio(contentMode: .fit)
			} else if let fallbackIcon {
				Image(nsImage: fallbackIcon)
					.resizable()
					.renderingMode(.template)
					.foregroundColor(
						station.url.isEmpty
							? Color.slot : .primary
					)
					.aspectRatio(contentMode: .fit)
			} else {
				Color(nsColor: .windowBackgroundColor)
			}
		}
		.frame(width: 36, height: 36)
		.clipShape(RoundedRectangle(cornerRadius: 6))
		.onAppear {
			loadFallbackIcon()
			loadFavicon()
		}
		.onChange(of: station.faviconUrl) { loadFavicon() }
	}

	private func loadFallbackIcon() {
		fallbackIcon = NSImage(
			systemSymbolName: "antenna.radiowaves.left.and.right",
			accessibilityDescription: nil
		)
	}

	private func normalizeImage(_ image: NSImage) -> NSImage {
		let normalized = NSImage(size: image.size)
		normalized.lockFocus()
		image.draw(in: NSRect(origin: .zero, size: image.size))
		normalized.unlockFocus()
		return normalized
	}

	private func loadFavicon() {
		faviconLoadFailed = false
		guard !station.faviconUrl.isEmpty,
			let url = URL(string: station.faviconUrl)
		else {
			favicon = nil
			faviconNeedsBackground = false
			faviconNeedsInset = false
			return
		}
		URLSession.shared.dataTask(with: url) { data, _, _ in
			if let data, let image = NSImage(data: data) {
				let normalized = self.normalizeImage(image)
				let treatment = StreamInfo.faviconTreatment(for: normalized)
				DispatchQueue.main.async {
					favicon = normalized
					faviconNeedsBackground = treatment.needsBackground
					faviconNeedsInset = treatment.needsInset
				}
			} else {
				DispatchQueue.main.async { faviconLoadFailed = true }
			}
		}.resume()
	}
}
