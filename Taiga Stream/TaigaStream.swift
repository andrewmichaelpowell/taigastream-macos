//  Taiga Stream (macOS)
//  github.com/andrewmichaelpowell

import SwiftUI

@main

struct TaigaStream: App {
	var body: some Scene {
		Window("Taiga Stream", id: "main") {
			MainView()
				.frame(minWidth: 384, minHeight: 612)
				.focusEffectDisabled()
		}
		.defaultSize(width: 384, height: 612)
		.windowResizability(.contentMinSize)
	}
}
