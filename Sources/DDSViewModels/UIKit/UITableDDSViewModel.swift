#if os(iOS) || os(tvOS)
import UIKit

open class UITableDDSViewModel<SectionType: DDSSection, CellType: UITableViewCell & Providing>: NSObject {
	
	public typealias Section = SectionType.Section
	public typealias ItemType = CellType.Provided
	public typealias DiffableTableViewDataSource = UITableViewDiffableDataSource<SectionType.Section, ItemType>
	@Published public var items: [ItemType] = .init([])
	
	private weak var tableView: UITableView?
	
	var diffableDataSource: DiffableTableViewDataSource?
	
	private var cellIdentifier: String
	
	public init(tableView: UITableView,  cellReuseIdentifier: String) {
		self.tableView = tableView
		self.cellIdentifier = cellReuseIdentifier
		super.init()
	}
}

public extension UITableDDSViewModel {
	
	func add(_ items: [ItemType], to section: Section, completion: (() -> Void)? = nil) {
		self.items.append(contentsOf: items)
		update(for: section)
		completion?()
	}
	
	func remove(_ items: [ItemType], from section: Section, completion: (() -> Void)? = nil) {
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
	
	private func update(for section: Section) {
		var snapshot = NSDiffableDataSourceSnapshot<Section, ItemType>.init()
		snapshot.appendSections(SectionType.allSections)
		snapshot.appendItems(items)
		diffableDataSource?.apply(snapshot)
	}
}
#endif
