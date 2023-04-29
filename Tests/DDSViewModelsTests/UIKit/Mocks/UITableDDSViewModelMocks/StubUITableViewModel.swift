#if os(iOS) || os(tvOS)
import XCTest
@testable import DDSViewModels

final class StubUITableViewModel: UITableDDSViewModel<DummySection, FakeUITableViewCell>, UITableViewDelegate {
	init(tableView: UITableView) {
		super.init(tableView: tableView, cellReuseIdentifier: "FakeUITableViewCell")
	}
}

extension StubUITableViewModel {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		print("cell tapped")
	}
}

#endif
