#if os(iOS) || os(tvOS)
import XCTest
@testable import DDSViewModels

final class StubUITableViewModel: UITableDDSViewModel<DummySection, FakeUITableViewCell> {
	
	var didSelectRowAtCalledCount = 0
	
	init(tableView: UITableView) {
		super.init(tableView: tableView, cellReuseIdentifier: "FakeUITableViewCell")
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		didSelectRowAtCalledCount += 1
		guard let item = diffableDataSource?.itemIdentifier(for: indexPath) else { return }
		
		print(item)
	}
}
#endif
