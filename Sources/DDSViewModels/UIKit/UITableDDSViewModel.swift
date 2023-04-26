#if os(iOS) || os(tvOS)
import UIKit

open class UITableDDSViewModel<SectionType: Hashable, CellType: UITableViewCell & Providing>: NSObject {
	
	public typealias Item = CellType.Provided
	public typealias Section = SectionType
	public typealias DiffableTableViewDataSource = UITableViewDiffableDataSource<Section, Item>
	private weak var tableView: UITableView?
	@Published public var items: [Item] = .init([])
	var diffableDataSource: DiffableTableViewDataSource?
	private var cellIdentifier: String
	
	init(tableView: UITableView,  cellReuseIdentifier: String) {
		self.tableView = tableView
		self.cellIdentifier = cellReuseIdentifier
		super.init()
	}
}

public extension UITableDDSViewModel {
	
	func add(_ items: [Item], to section: Section, completion: (() -> Void)? = nil) {
		self.items.append(contentsOf: items)
		update(for: section)
		completion?()
	}
	
	func remove(_ items: [Item], from section: Section, completion: (() -> Void)? = nil) {
		self.items.removeAll { items.contains($0) }
		update(for: section)
		completion?()
	}
	
	func makeDiffableDataSource() -> DiffableTableViewDataSource {
		guard let tableView else { fatalError("TableView should exist but doesn't") }
		let diffableDataSource = DiffableTableViewDataSource(tableView: tableView, cellProvider: cellProvider)
		self.diffableDataSource = diffableDataSource
		return diffableDataSource
	}
}

private extension UITableDDSViewModel {
	
	private func cellProvider(_ tableView: UITableView, indexPath: IndexPath, item: Item) -> UITableViewCell? {
		let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CellType
		cell.provide(item)
		return cell
	}
	
	private func update(for section: Section) {
		var snapshot = NSDiffableDataSourceSnapshot<Section, Item>.init()
		snapshot.appendSections([section])
		snapshot.appendItems(items)
		diffableDataSource?.apply(snapshot)
	}
}
#endif
