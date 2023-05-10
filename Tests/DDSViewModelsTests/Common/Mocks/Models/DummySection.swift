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
	
	public func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}
	
	public static func == (lhs: DummySection, rhs: DummySection) -> Bool {
		lhs.id == rhs.id
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
