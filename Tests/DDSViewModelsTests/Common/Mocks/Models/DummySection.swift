import XCTest
@testable import DDSViewModels

public struct DummySection: DDSSection {
	public var id = UUID()
	public var title: String

	init(title: String) {
		self.title = title
	}
}

extension DummySection: Hashable {
	
	public static var allSections: [DummySection] = [
		DummySection(title: "Main"),
		DummySection(title: "Secondary"),
	]
}