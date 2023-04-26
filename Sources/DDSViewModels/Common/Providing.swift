
public protocol Providing {
	associatedtype Provided: Hashable
	func provide(_ provided: Provided)
}
