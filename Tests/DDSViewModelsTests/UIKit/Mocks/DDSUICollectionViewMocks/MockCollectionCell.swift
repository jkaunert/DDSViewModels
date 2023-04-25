#if os(iOS) || os(tvOS)
import XCTest
@testable import DDSViewModels

class MockUICollectionViewCell: UICollectionViewCell {
	let textLabel = UILabel()
	let dateLabel = UILabel()
}

extension MockUICollectionViewCell: Providing {
	
	public typealias Provided = MockItem
	
	public func provide(_ item: MockItem) {
		self.textLabel.text = item.text
		self.dateLabel.text = item.formattedDate
	}
}
#endif
