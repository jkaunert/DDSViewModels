#if os(iOS) || os(tvOS)
import XCTest
@testable import DDSViewModels

final class FakeUITableViewCell: UITableViewCell {
	let dateLabel = UILabel()
}

extension FakeUITableViewCell: Providing {
	
	public typealias Provided = DummyItem
	
	public func provide(_ item: DummyItem) {
		self.textLabel?.text = item.text
		self.dateLabel.text = item.formattedDate
	}
}
#endif
