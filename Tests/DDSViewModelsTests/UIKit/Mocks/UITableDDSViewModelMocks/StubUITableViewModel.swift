#if os(iOS) || os(tvOS)
import XCTest
@testable import DDSViewModels

final class StubUITableViewModel: UITableDDSViewModel<DummySection, FakeUITableViewCell> {
	init(tableView: UITableView) {
		super.init(tableView: tableView, cellReuseIdentifier: "FakeUITableViewCell")
	}
}

extension DiffableTableViewDataSource<DummySection, FakeUITableViewCell> {
	public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		print("selected row: \(indexPath.row)")
	}
}

#endif
