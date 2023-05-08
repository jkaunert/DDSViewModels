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
}

public extension UITableDDSViewModel {
	
	func makeDiffableDataSource() -> UITableViewDiffableDataSource<Section, Item> {
		guard let tableView else { fatalError("TableView should exist but doesn't") }
		let diffableDataSource = UITableViewDiffableDataSource<Section, Item>(tableView: tableView, cellProvider: cellProvider)
		self.diffableDataSource = diffableDataSource
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
	
	private func sectionHeaderViewProvider(tableView: UITableView, kind: String, indexPath: IndexPath) -> UITableViewHeaderFooterView? {
		var reusableView: UITableViewHeaderFooterView?
		switch kind {
				
			default:
				reusableView = nil
		}
		return reusableView
	}

	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return snapshot.sectionIdentifiers[section].title.capitalized
	}
	
}
#endif
