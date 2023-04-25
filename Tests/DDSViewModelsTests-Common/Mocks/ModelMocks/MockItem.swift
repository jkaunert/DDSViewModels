import Foundation
import XCTest

public struct MockItem: Hashable {
	
	let text: String
	
	private let creationDate: Date
	
	public init(text: String) {
		self.text = text
		self.creationDate = Date()
	}
	
	public var formattedDate: String {
		let formatter = DateFormatter()
		formatter.dateStyle = .medium
		formatter.timeStyle = .medium
		return formatter.string(from: creationDate)
	}
}
