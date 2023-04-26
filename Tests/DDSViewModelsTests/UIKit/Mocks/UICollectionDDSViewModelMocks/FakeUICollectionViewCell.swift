#if os(iOS) || os(tvOS)
import XCTest
@testable import DDSViewModels

class FakeUICollectionViewCell: UICollectionViewCell {
	let textLabel = UILabel()
	let dateLabel = UILabel()
}

extension FakeUICollectionViewCell: Providing {
	
	public typealias Provided = DummyItem
	
	public func provide(_ item: DummyItem) {
		self.textLabel.text = item.text
		self.dateLabel.text = item.formattedDate
	}
}
#endif
