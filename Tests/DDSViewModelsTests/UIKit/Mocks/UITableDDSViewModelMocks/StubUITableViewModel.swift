#if os(iOS) || os(tvOS)
import XCTest
@testable import DDSViewModels

final class StubUITableViewModel: UITableDDSViewModel<DummySection, FakeUITableViewCell> {
	init(tableView: UITableView) {
		super.init(tableView: tableView, cellReuseIdentifier: "FakeUITableViewCell")
	}
}

extension StubUITableViewModel: UITableViewDelegate {}
#endif
