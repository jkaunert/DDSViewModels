#if os(iOS) || os(tvOS)
import XCTest
import Combine
@testable import DDSViewModels

final class FakeUITableViewController: UIViewController, UITableViewDelegate {
	
	lazy var tableView = MockUITableView()
	
	private var cancellables = [AnyCancellable]()
	
	lazy var viewModel = StubUITableViewModel(tableView: tableView)
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.addSubview(tableView)
		configureTableView()
	}
	
	private func configureTableView() {
		tableView.dataSource = viewModel.makeDiffableDataSource()
		
		tableView.register(FakeUITableViewCell.self, forCellReuseIdentifier: "FakeUITableViewCell")
		
		tableView.delegate = viewModel.diffableDataSource as? any UITableViewDelegate

	}
	
	
//	private func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//		return viewModel.snapshot.sectionIdentifiers[section].title.capitalized
//	}
}
#endif

