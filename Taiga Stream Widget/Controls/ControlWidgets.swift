//  Taiga Stream (macOS)
//  github.com/andrewmichaelpowell

import AppIntents
import Foundation
import SwiftUI
import WidgetKit

private let controlGreen = Color(red: 4 / 255, green: 80 / 255, blue: 48 / 255)

private func configureControl(streamNumber: Int)
	-> some ControlWidgetConfiguration
{
	let kind = "xyz.andrewmichaelpowell.taigastream.stream\(streamNumber)"
	return StaticControlConfiguration(kind: kind) {
		let streamState = UserDefaults(
			suiteName: "group.xyz.andrewmichaelpowell.taigastream"
		)
		let streamStatus =
			(streamState?.bool(forKey: "PlayingKey") ?? false)
			&& (streamState?.integer(forKey: "CurrentStreamKey") ?? 0)
				== streamNumber
		return ControlWidgetToggle(
			isOn: streamStatus,
			action: ToggleIntent(streamNumber: streamNumber)
		) {
			Label(
				"Stream \(streamNumber)",
				image: "taiga.radio.\(streamNumber)"
			)
		}
		.tint(controlGreen)
	}
	.displayName("Stream \(streamNumber)")
}

private func configurePodcastControl(podcastNumber: Int)
	-> some ControlWidgetConfiguration
{
	let kind = "xyz.andrewmichaelpowell.taigastream.podcast\(podcastNumber)"
	return StaticControlConfiguration(kind: kind) {
		let streamState = UserDefaults(
			suiteName: "group.xyz.andrewmichaelpowell.taigastream"
		)
		let podcastStatus =
			(streamState?.bool(forKey: "PlayingKey") ?? false)
			&& (streamState?.integer(forKey: "CurrentPodcastKey") ?? 0)
				== podcastNumber
		return ControlWidgetToggle(
			isOn: podcastStatus,
			action: PodcastToggleIntent(podcastNumber: podcastNumber)
		) {
			Label(
				"Podcast \(podcastNumber)",
				image: "taiga.podcast.\(podcastNumber)"
			)
		}
		.tint(controlGreen)
	}
	.displayName("Podcast \(podcastNumber)")
}

struct Control1: ControlWidget {
	var body: some ControlWidgetConfiguration {
		configureControl(streamNumber: 1)
	}
}
struct Control2: ControlWidget {
	var body: some ControlWidgetConfiguration {
		configureControl(streamNumber: 2)
	}
}
struct Control3: ControlWidget {
	var body: some ControlWidgetConfiguration {
		configureControl(streamNumber: 3)
	}
}
struct Control4: ControlWidget {
	var body: some ControlWidgetConfiguration {
		configureControl(streamNumber: 4)
	}
}
struct Control5: ControlWidget {
	var body: some ControlWidgetConfiguration {
		configureControl(streamNumber: 5)
	}
}
struct Control6: ControlWidget {
	var body: some ControlWidgetConfiguration {
		configureControl(streamNumber: 6)
	}
}
struct Control7: ControlWidget {
	var body: some ControlWidgetConfiguration {
		configureControl(streamNumber: 7)
	}
}
struct Control8: ControlWidget {
	var body: some ControlWidgetConfiguration {
		configureControl(streamNumber: 8)
	}
}
struct Control9: ControlWidget {
	var body: some ControlWidgetConfiguration {
		configureControl(streamNumber: 9)
	}
}
struct Control10: ControlWidget {
	var body: some ControlWidgetConfiguration {
		configureControl(streamNumber: 10)
	}
}
struct Control11: ControlWidget {
	var body: some ControlWidgetConfiguration {
		configureControl(streamNumber: 11)
	}
}
struct Control12: ControlWidget {
	var body: some ControlWidgetConfiguration {
		configureControl(streamNumber: 12)
	}
}
struct Control13: ControlWidget {
	var body: some ControlWidgetConfiguration {
		configureControl(streamNumber: 13)
	}
}
struct Control14: ControlWidget {
	var body: some ControlWidgetConfiguration {
		configureControl(streamNumber: 14)
	}
}
struct Control15: ControlWidget {
	var body: some ControlWidgetConfiguration {
		configureControl(streamNumber: 15)
	}
}
struct Control16: ControlWidget {
	var body: some ControlWidgetConfiguration {
		configureControl(streamNumber: 16)
	}
}
struct Control17: ControlWidget {
	var body: some ControlWidgetConfiguration {
		configureControl(streamNumber: 17)
	}
}
struct Control18: ControlWidget {
	var body: some ControlWidgetConfiguration {
		configureControl(streamNumber: 18)
	}
}
struct Control19: ControlWidget {
	var body: some ControlWidgetConfiguration {
		configureControl(streamNumber: 19)
	}
}
struct Control20: ControlWidget {
	var body: some ControlWidgetConfiguration {
		configureControl(streamNumber: 20)
	}
}
struct Control21: ControlWidget {
	var body: some ControlWidgetConfiguration {
		configureControl(streamNumber: 21)
	}
}
struct Control22: ControlWidget {
	var body: some ControlWidgetConfiguration {
		configureControl(streamNumber: 22)
	}
}
struct Control23: ControlWidget {
	var body: some ControlWidgetConfiguration {
		configureControl(streamNumber: 23)
	}
}
struct Control24: ControlWidget {
	var body: some ControlWidgetConfiguration {
		configureControl(streamNumber: 24)
	}
}
struct Control25: ControlWidget {
	var body: some ControlWidgetConfiguration {
		configureControl(streamNumber: 25)
	}
}
struct Control26: ControlWidget {
	var body: some ControlWidgetConfiguration {
		configureControl(streamNumber: 26)
	}
}
struct Control27: ControlWidget {
	var body: some ControlWidgetConfiguration {
		configureControl(streamNumber: 27)
	}
}
struct Control28: ControlWidget {
	var body: some ControlWidgetConfiguration {
		configureControl(streamNumber: 28)
	}
}
struct Control29: ControlWidget {
	var body: some ControlWidgetConfiguration {
		configureControl(streamNumber: 29)
	}
}
struct Control30: ControlWidget {
	var body: some ControlWidgetConfiguration {
		configureControl(streamNumber: 30)
	}
}
struct Control31: ControlWidget {
	var body: some ControlWidgetConfiguration {
		configureControl(streamNumber: 31)
	}
}
struct Control32: ControlWidget {
	var body: some ControlWidgetConfiguration {
		configureControl(streamNumber: 32)
	}
}
struct PodcastControl1: ControlWidget {
	var body: some ControlWidgetConfiguration {
		configurePodcastControl(podcastNumber: 1)
	}
}
struct PodcastControl2: ControlWidget {
	var body: some ControlWidgetConfiguration {
		configurePodcastControl(podcastNumber: 2)
	}
}
struct PodcastControl3: ControlWidget {
	var body: some ControlWidgetConfiguration {
		configurePodcastControl(podcastNumber: 3)
	}
}
struct PodcastControl4: ControlWidget {
	var body: some ControlWidgetConfiguration {
		configurePodcastControl(podcastNumber: 4)
	}
}
struct PodcastControl5: ControlWidget {
	var body: some ControlWidgetConfiguration {
		configurePodcastControl(podcastNumber: 5)
	}
}
struct PodcastControl6: ControlWidget {
	var body: some ControlWidgetConfiguration {
		configurePodcastControl(podcastNumber: 6)
	}
}
struct PodcastControl7: ControlWidget {
	var body: some ControlWidgetConfiguration {
		configurePodcastControl(podcastNumber: 7)
	}
}
struct PodcastControl8: ControlWidget {
	var body: some ControlWidgetConfiguration {
		configurePodcastControl(podcastNumber: 8)
	}
}
struct PodcastControl9: ControlWidget {
	var body: some ControlWidgetConfiguration {
		configurePodcastControl(podcastNumber: 9)
	}
}
struct PodcastControl10: ControlWidget {
	var body: some ControlWidgetConfiguration {
		configurePodcastControl(podcastNumber: 10)
	}
}
struct PodcastControl11: ControlWidget {
	var body: some ControlWidgetConfiguration {
		configurePodcastControl(podcastNumber: 11)
	}
}
struct PodcastControl12: ControlWidget {
	var body: some ControlWidgetConfiguration {
		configurePodcastControl(podcastNumber: 12)
	}
}
struct PodcastControl13: ControlWidget {
	var body: some ControlWidgetConfiguration {
		configurePodcastControl(podcastNumber: 13)
	}
}
struct PodcastControl14: ControlWidget {
	var body: some ControlWidgetConfiguration {
		configurePodcastControl(podcastNumber: 14)
	}
}
struct PodcastControl15: ControlWidget {
	var body: some ControlWidgetConfiguration {
		configurePodcastControl(podcastNumber: 15)
	}
}
struct PodcastControl16: ControlWidget {
	var body: some ControlWidgetConfiguration {
		configurePodcastControl(podcastNumber: 16)
	}
}
struct PodcastControl17: ControlWidget {
	var body: some ControlWidgetConfiguration {
		configurePodcastControl(podcastNumber: 17)
	}
}
struct PodcastControl18: ControlWidget {
	var body: some ControlWidgetConfiguration {
		configurePodcastControl(podcastNumber: 18)
	}
}
struct PodcastControl19: ControlWidget {
	var body: some ControlWidgetConfiguration {
		configurePodcastControl(podcastNumber: 19)
	}
}
struct PodcastControl20: ControlWidget {
	var body: some ControlWidgetConfiguration {
		configurePodcastControl(podcastNumber: 20)
	}
}
struct PodcastControl21: ControlWidget {
	var body: some ControlWidgetConfiguration {
		configurePodcastControl(podcastNumber: 21)
	}
}
struct PodcastControl22: ControlWidget {
	var body: some ControlWidgetConfiguration {
		configurePodcastControl(podcastNumber: 22)
	}
}
struct PodcastControl23: ControlWidget {
	var body: some ControlWidgetConfiguration {
		configurePodcastControl(podcastNumber: 23)
	}
}
struct PodcastControl24: ControlWidget {
	var body: some ControlWidgetConfiguration {
		configurePodcastControl(podcastNumber: 24)
	}
}
struct PodcastControl25: ControlWidget {
	var body: some ControlWidgetConfiguration {
		configurePodcastControl(podcastNumber: 25)
	}
}
struct PodcastControl26: ControlWidget {
	var body: some ControlWidgetConfiguration {
		configurePodcastControl(podcastNumber: 26)
	}
}
struct PodcastControl27: ControlWidget {
	var body: some ControlWidgetConfiguration {
		configurePodcastControl(podcastNumber: 27)
	}
}
struct PodcastControl28: ControlWidget {
	var body: some ControlWidgetConfiguration {
		configurePodcastControl(podcastNumber: 28)
	}
}
struct PodcastControl29: ControlWidget {
	var body: some ControlWidgetConfiguration {
		configurePodcastControl(podcastNumber: 29)
	}
}
struct PodcastControl30: ControlWidget {
	var body: some ControlWidgetConfiguration {
		configurePodcastControl(podcastNumber: 30)
	}
}
struct PodcastControl31: ControlWidget {
	var body: some ControlWidgetConfiguration {
		configurePodcastControl(podcastNumber: 31)
	}
}
struct PodcastControl32: ControlWidget {
	var body: some ControlWidgetConfiguration {
		configurePodcastControl(podcastNumber: 32)
	}
}
