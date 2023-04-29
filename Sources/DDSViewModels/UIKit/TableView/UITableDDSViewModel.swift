#if os(iOS) || os(tvOS)
import UIKit

open class UITableDDSViewModel<SectionType: Section, CellType: UITableViewCell & Providing>: NSObject {
	
	public typealias Section = SectionType
	public typealias Item = CellType.Provided

	@Published public var items: [Item] = .init([])
	
	private weak var tableView: UITableView?
	
	public private(set) var diffableDataSource: DiffableTableViewDataSource<Section, CellType>?
	
	private var cellIdentifier: String
	
	public init(tableView: UITableView,  cellReuseIdentifier: String) {
		self.tableView = tableView
		self.cellIdentifier = cellReuseIdentifier
		super.init()
	}
}

public extension UITableDDSViewModel {
	
	func add(_ items: [Item], to section: Section, completion: (() -> Void)? = nil) {
		self.items.append(contentsOf: items)
		update(section: section, with: items)
		completion?()
	}
	
	func remove(_ items: [Item], from section: Section, completion: (() -> Void)? = nil) {
		self.items.removeAll { items.contains($0) }
		update(section: section, with: items)
		completion?()
	}
	
	func makeDiffableDataSource() -> DiffableTableViewDataSource<Section, CellType> {
		guard let tableView else { fatalError("TableView should exist but doesn't") }
		let diffableDataSource = DiffableTableViewDataSource<Section, CellType>(tableView: tableView, cellProvider: cellProvider)
		self.diffableDataSource = diffableDataSource
		return diffableDataSource
	}
	
	private func update(section: Section, with items: [Item]) {
		var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
		snapshot.appendSections(Section.allSections)
		snapshot.appendItems(items, toSection: section)
		diffableDataSource?.apply(snapshot)
	}
}

extension UITableDDSViewModel {
	
	private func cellProvider(_ tableView: UITableView, indexPath: IndexPath, item: Item) -> UITableViewCell? {
		let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CellType
		cell.provide(item)
		return cell
	}

	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		let sectionKind = Section.allSections[section]
		return sectionKind.title
	}
	
	func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		let sectionKind = Section.allSections[section]
		return sectionKind.id.uuidString
	}
	

}
#endif
