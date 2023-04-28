import Foundation

public protocol DDSSection: Hashable {
	associatedtype Section: DDSSection
	var id: UUID { get set }
	var title: String { get set }
	static var allSections: [Section] { get set }
}


