import XCTest
@testable import DDSViewModels

public struct MockSection: Sectioning {
		
	public var id = UUID()
	public var title: String

	init(title: String) {
		self.title = title
	}
}

extension MockSection: Hashable {
	
	public static var allSections: [MockSection] = [
		MockSection(title: "Main"),
		MockSection(title: "Secondary"),
	]
}
