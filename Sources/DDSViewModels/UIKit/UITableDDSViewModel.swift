#if os(iOS) || os(tvOS)
import UIKit

open class UITableDDSViewModel<SectionType: DDSSection, CellType: UITableViewCell & Providing>: NSObject, UITableViewDelegate {
	
	public typealias Section = SectionType.Section
	public typealias ItemType = CellType.Provided
	public typealias DiffableTableViewDataSource = UITableViewDiffableDataSource<Section, ItemType>
	@Published public var items: [ItemType] = .init([])
	
	private weak var tableView: UITableView?
	
	public private(set) var diffableDataSource: DiffableTableViewDataSource?
	
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
	
	private func update(for section: Section) {
		var snapshot = NSDiffableDataSourceSnapshot<Section, ItemType>.init()
		snapshot.appendSections([section])
		snapshot.appendItems(items)
		diffableDataSource?.apply(snapshot)
	}
}

extension UITableDDSViewModel {
	
	private func cellProvider(_ tableView: UITableView, indexPath: IndexPath, item: ItemType) -> UITableViewCell? {
		let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CellType
		cell.provide(item)
		return cell
	}

	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		let sectionKind = SectionType.allSections[section]
		return sectionKind.title
	}
	
	func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		let sectionKind = SectionType.allSections[section]
		return sectionKind.id.uuidString
	}
	
	// MARK: reordering support
	func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
		return true
	}
	
	func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
		guard let sourceIdentifier = diffableDataSource?.itemIdentifier(for: sourceIndexPath) else { return }
		guard sourceIndexPath != destinationIndexPath else { return }
		let destinationIdentifier = diffableDataSource?.itemIdentifier(for: destinationIndexPath)
		
		var snapshot = self.diffableDataSource?.snapshot()
		
		if let destinationIdentifier = destinationIdentifier {
			if let sourceIndex = snapshot?.indexOfItem(sourceIdentifier),
			   let destinationIndex = snapshot?.indexOfItem(destinationIdentifier) {
				let isAfter = destinationIndex > sourceIndex &&
				snapshot?.sectionIdentifier(containingItem: sourceIdentifier) ==
				snapshot?.sectionIdentifier(containingItem: destinationIdentifier)
				snapshot?.deleteItems([sourceIdentifier])
				if isAfter {
					snapshot?.insertItems([sourceIdentifier], afterItem: destinationIdentifier)
				} else {
					snapshot?.insertItems([sourceIdentifier], beforeItem: destinationIdentifier)
				}
			}
		} else {
			let destinationSectionIdentifier = snapshot?.sectionIdentifiers[destinationIndexPath.section]
			snapshot?.deleteItems([sourceIdentifier])
			snapshot?.appendItems([sourceIdentifier], toSection: destinationSectionIdentifier)
		}
		diffableDataSource?.apply(snapshot!, animatingDifferences: false)
	}
	
	// MARK: editing support
	
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			if let identifierToDelete = diffableDataSource?.itemIdentifier(for: indexPath) {
				var snapshot = self.diffableDataSource?.snapshot()
				snapshot?.deleteItems([identifierToDelete])
				diffableDataSource?.apply(snapshot!)
			}
		}
	}
}
#endif
