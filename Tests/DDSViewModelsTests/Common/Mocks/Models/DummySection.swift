import XCTest
@testable import DDSViewModels

public struct DummySection: DiffableSection {
	public var items: [DummyItem]
	
	public typealias Item = DummyItem
	
	public typealias Section = Self
	
	public var id = UUID()
	public var title: String

	init(title: String, items: [DummyItem] = []) {
		self.title = title
		self.items = items
	}
}

extension DummySection: Hashable {
	
	public static var allSections: [DummySection] = [
		DummySection(title: "dummySection1"),
		DummySection(title: "dummySection2"),
	]
	
	public static func returnSections() -> [DummySection] {
		return self.allSections
	}
}
