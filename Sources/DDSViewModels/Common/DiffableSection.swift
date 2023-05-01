import Foundation

public typealias Section = DiffableSection

public protocol DiffableSection: Hashable {
	associatedtype Section: Hashable
	var id: UUID { get set }
	var title: String { get set }
	static var allSections: [Self] { get set }
}


