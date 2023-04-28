#if os(iOS) || os(tvOS)
import UIKit

open class UITableDDSViewModel<SectionType: DDSSection, CellType: UITableViewCell & Providing>: NSObject {
	
	public typealias ItemType = CellType.Provided
//	public typealias Section = SectionType
	public typealias DiffableTableViewDataSource = UITableViewDiffableDataSource<SectionType, ItemType>
	@Published public var items: [ItemType] = .init([])
	
	var diffableDataSource: DiffableTableViewDataSource?
	
	private weak var tableView: UITableView?
	
	private var cellIdentifier: String
	
	public init(tableView: UITableView,  cellReuseIdentifier: String) {
		self.tableView = tableView
		self.cellIdentifier = cellReuseIdentifier
		super.init()
	}
}

public extension UITableDDSViewModel {
	
	func add(_ items: [ItemType], to section: SectionType, completion: (() -> Void)? = nil) {
		self.items.append(contentsOf: items)
		update(for: section)
		completion?()
	}
	
	func remove(_ items: [ItemType], from section: SectionType, completion: (() -> Void)? = nil) {
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
	
	private func cellProvider(_ tableView: UITableView, indexPath: IndexPath, item: ItemType) -> UITableViewCell? {
		let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CellType
		cell.provide(item)
		return cell
	}
	
	private func update(for section: SectionType) {
		var snapshot = NSDiffableDataSourceSnapshot<SectionType, ItemType>.init()
		snapshot.appendSections([section])
		snapshot.appendItems(items)
		diffableDataSource?.apply(snapshot)
	}
}
#endif
