import Foundation

public typealias Section = DiffableSection

public protocol DiffableSection: Hashable {
	associatedtype Item: Hashable
	var id: UUID { get set }
	var title: String { get set }
	var items: [Item] { get set }
	static var allSections: [Self] { get set }
	static func returnSections() -> [Self]
}

