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

extension UITableDDSViewModel {
	
	func makeDiffableDataSource() -> UITableViewDiffableDataSource<Section, Item> {
		guard let tableView else { fatalError("TableView should exist but doesn't") }
		let diffableDataSource = UITableViewDiffableDataSource<Section, Item>(tableView: tableView, cellProvider: cellProvider)
		self.diffableDataSource = diffableDataSource
		tableView.delegate = self
		return diffableDataSource
	}
	
	private func applySnapshot(animatingDifferences: Bool = true) {
		snapshot.appendSections(sections)
		sections.forEach { section in
			snapshot.appendItems(section.items, toSection: section)
		}
		diffableDataSource?.apply(snapshot, animatingDifferences: animatingDifferences)
	}
	
	func update(animatingDifferences: Bool = true) {
		self.applySnapshot(animatingDifferences: animatingDifferences)
	}
}

extension UITableDDSViewModel {
	
	private func cellProvider(_ tableView: UITableView, indexPath: IndexPath, item: Item) -> UITableViewCell? {
		let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CellType
		cell.provide(item as! Provided)
		return cell
	}

	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return snapshot.sectionIdentifiers[section].title.capitalized
	}
	
}
#endif
