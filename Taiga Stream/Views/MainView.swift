//  Taiga Stream (macOS)
//  github.com/andrewmichaelpowell

import Foundation
import SwiftUI

struct MainView: View {
	@AppStorage("SelectedTab") private var selectedTab = MainTab.radio

	enum MainTab: String {
		case radio, podcasts
	}

	var body: some View {
		Group {
			switch selectedTab {
			case .radio: RadioView()
			case .podcasts: PodcastsView()
			}
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.safeAreaInset(edge: .top, spacing: 0) {
			NowPlayingPanel()
		}
		.safeAreaInset(edge: .bottom) {
			PageChooser(selection: $selectedTab)
				.padding(.bottom, 12)
		}
		.toolbarBackgroundVisibility(.hidden, for: .windowToolbar)
		.toolbar(removing: .title)
		.clipped()
	}
}

private struct PageChooser: View {
	@Binding var selection: MainView.MainTab

	private static let itemWidth: CGFloat = 80
	private static let itemHeight: CGFloat = 44
	private static let inset: CGFloat = 4

	var body: some View {
		ZStack(alignment: .leading) {
			Capsule()
				.selectionFill()
				.frame(width: Self.itemWidth, height: Self.itemHeight)
				.offset(x: selection == .radio ? 0 : Self.itemWidth)
			HStack(spacing: 0) {
				item(.radio, symbol: "radio", label: Text("Radio"))
				item(.podcasts, symbol: "mic", label: Text("Podcasts"))
			}
		}
		.padding(Self.inset)
		.chooserBackground()
		.animation(.snappy, value: selection)
	}

	private func item(
		_ tab: MainView.MainTab,
		symbol: String,
		label: Text
	) -> some View {
		let isSelected = selection == tab
		return Button {
			selection = tab
		} label: {
			Image(systemName: symbol)
				.font(.title2)
				.foregroundStyle(isSelected ? Color.white : Color.primary)
				.frame(width: Self.itemWidth, height: Self.itemHeight)
				.contentShape(Capsule())
		}
		.buttonStyle(.plain)
		.accessibilityLabel(label)
		.accessibilityAddTraits(isSelected ? .isSelected : [])
	}
}

extension Capsule {
	@ViewBuilder
	fileprivate func selectionFill() -> some View {
		if #available(macOS 26.0, *) {
			fill(Color.clear)
				.glassEffect(.regular.tint(.taigaGreen), in: Capsule())
		} else {
			fill(Color.taigaGreen)
		}
	}
}

extension View {
	@ViewBuilder
	fileprivate func chooserBackground() -> some View {
		if #available(macOS 26.0, *) {
			glassEffect(.regular.interactive(), in: Capsule())
		} else {
			background(.regularMaterial, in: Capsule())
		}
	}
}
