#if os(iOS) || os(tvOS)
import UIKit

open class UITableDDSViewModel<SectionType: Section, CellType: UITableViewCell & Providing>: NSObject, UITableViewDelegate {
	
	public typealias Section = SectionType
	public typealias Item = Section.Item
	public typealias Provided = CellType.Provided
	
	@Published public var sections: [Section] = .init(Section.allSections)
	
	private weak var tableView: UITableView?
	
	public private(set) var diffableDataSource: UITableViewDiffableDataSource<Section, Item>?
	
	public var snapshot = NSDiffableDataSourceSnapshot<Section, Item>.init()
	
	private var cellIdentifier: String
	
	public init(tableView: UITableView,  cellReuseIdentifier: String) {
		self.tableView = tableView
		self.cellIdentifier = cellReuseIdentifier
		super.init()
	}
	
	public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}
	
	public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		sectionHeaderViewProvider(tableView: tableView, section: section)
	}
	
}

public extension UITableDDSViewModel {
	
	func makeDiffableDataSource() -> UITableViewDiffableDataSource<Section, Item> {
		guard let tableView = self.tableView else { fatalError("TableView should exist but doesn't") }
		let diffableDataSource = UITableViewDiffableDataSource<Section, Item>(tableView: tableView, cellProvider: cellProvider)
		tableView.register(TableViewSectionHeader.self, forHeaderFooterViewReuseIdentifier: TableViewSectionHeader.reuseIdentifier)
		tableView.register(CellType.self, forCellReuseIdentifier: cellIdentifier)
		self.diffableDataSource = diffableDataSource
		self.tableView = tableView
		self.tableView?.delegate = self
		return diffableDataSource
	}
	
	private func applySnapshot(animatingDifferences: Bool = true, completion: (() -> Void)? = nil) {
		snapshot.deleteAllItems()
		snapshot.appendSections(sections)
		sections.forEach { section in
			snapshot.appendItems(section.items, toSection: section)
		}
		diffableDataSource?.apply(snapshot, animatingDifferences: animatingDifferences)
		completion?()
	}
	
	func update(animatingDifferences: Bool = true, completion: (() -> Void)? = nil) {
		self.applySnapshot(animatingDifferences: animatingDifferences)
		completion?()
	}
	
	func add(_ items: [Item], toSection: inout Section, animate: Bool = true, completion: (() -> Void)? = nil) {
		
		toSection.items.append(contentsOf: items)
		update(animatingDifferences: animate)
		completion?()
	}
	
	func remove(_ items: [Item], fromSection: inout Section, animate: Bool = true, completion: (() -> Void)? = nil) {
		
		fromSection.items.removeAll { items.contains($0) }
		update(animatingDifferences: animate)
		completion?()
	}
	
	func move(_ items: [Item], fromSection: inout Section, toSection: inout Section, animate: Bool = true, completion: (() -> Void)? = nil) {
		
		remove(items, fromSection: &fromSection, animate: animate)
		add(items, toSection: &toSection, animate: animate)
		completion?()
	}
	
	
}

private extension UITableDDSViewModel {
	
	private func cellProvider(_ tableView: UITableView, indexPath: IndexPath, item: Item) -> UITableViewCell? {
		let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CellType
		cell.provide(item as! Provided)
		return cell
	}
	
	private func sectionHeaderViewProvider(tableView: UITableView, section: Int) -> UITableViewHeaderFooterView? {
		let section = self.diffableDataSource?.snapshot()
			.sectionIdentifiers[section]
		let reusableView = tableView.dequeueReusableHeaderFooterView(withIdentifier: TableViewSectionHeader.reuseIdentifier) as! TableViewSectionHeader
		reusableView.titleLabel.text = section?.title
		return reusableView
	}
}
#endif
