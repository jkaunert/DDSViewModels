import Foundation

protocol Sectioning: Hashable {
	associatedtype Section: Hashable
	
	var id: UUID { get set }
	var title: String { get set }
	
	static var allSections: [Section] { get set }
	
}


