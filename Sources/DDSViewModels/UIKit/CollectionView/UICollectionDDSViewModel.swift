#if os(iOS) || os(tvOS)
import UIKit

open class UICollectionDDSViewModel<SectionType: Section, CellType: UICollectionViewCell & Providing>: NSObject {
	public typealias Section = SectionType
	public typealias Item = CellType.Provided
	
	@Published public var items: [Item] = .init([])
	@Published public var sections: [Section] = .init(Section.allSections)
	private weak var collectionView: UICollectionView?
	
	public private(set) var diffableDataSource: UICollectionViewDiffableDataSource<Section, Item>?
	public var snapshot = NSDiffableDataSourceSnapshot<Section, Item>.init()
	
	private var cellIdentifier: String
	
	public init(collectionView: UICollectionView,  cellReuseIdentifier: String) {
		self.collectionView = collectionView
		self.cellIdentifier = cellReuseIdentifier
		super.init()
	}
}

public extension UICollectionDDSViewModel {
	
	func makeDiffableDataSource() -> UICollectionViewDiffableDataSource<Section, Item> {
		guard let collectionView else { fatalError("CollectionView should exist but doesn't") }
		let diffableDataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: cellProvider)
		diffableDataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
			var reusableView: UICollectionReusableView?
			switch kind {
					case UICollectionView.elementKindSectionHeader:
					let section = self.diffableDataSource?.snapshot()
						.sectionIdentifiers[indexPath.section]
					let view = collectionView.dequeueReusableSupplementaryView(
						ofKind: kind,
						withReuseIdentifier: SectionHeaderReusableView.reuseIdentifier,
						for: indexPath) as? SectionHeaderReusableView
					view?.titleLabel.text = section?.title
					reusableView = view
					
				default:
					reusableView = nil
			}
			return reusableView
		}
		self.diffableDataSource = diffableDataSource
		return diffableDataSource
	}
	
	private func update(with sectionUpdates: [(section: Section, items: [Item])]) {
		
		DispatchQueue.main.async {
			self.snapshot.deleteAllItems()
			self.snapshot.appendSections(Section.allSections)
			
			sectionUpdates.forEach { section, items in
				self.snapshot.appendItems(items, toSection: section)
				self.diffableDataSource?.apply(self.snapshot, animatingDifferences: true)
			}
			
		}
	}
	
	func add(_ sections: [(section: Section, items: [Item])], completion: (() -> Void)? = nil) {
		
		DispatchQueue.main.async {
			self.snapshot.deleteAllItems()
			self.snapshot.appendSections(Section.allSections)
			
			sections.forEach { section, items in
				guard !items.isEmpty else { return }
				self.snapshot.appendItems(items, toSection: section)
				self.diffableDataSource?.apply(self.snapshot, animatingDifferences: true)
			}
			completion?()
		}
	}
//	func add(_ items: [Item], to section: Section, completion: (() -> Void)? = nil) {
//		guard !items.isEmpty else { return }
//		snapshot.deleteAllItems()
//		snapshot.appendSections(sections)
//		snapshot.appendItems(items, toSection: section)
////		sections.forEach { section in
////			snapshot.appendItems(items, toSection: section)
////		}
//		diffableDataSource?.apply(snapshot, animatingDifferences: true)
////		var section = section
////		var sectionItems: Array<Item> = section.items as! [CellType.Provided]
//////		var sectionItems = section.items as! [CellType.Provided]
////		sectionItems.append(contentsOf: items)
////		section.items = items as! [SectionType.Item]
////		print(section.items)
////		update()
//		completion?()
//	}
	
	func remove(_ items: [Item], from section: Section, completion: (() -> Void)? = nil) {
		
		self.items.removeAll { items.contains($0) }
		update(for: section)
		completion?()
	}
	
	func update(animatingDifferences: Bool = true) {
		var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
		snapshot.appendSections(sections)
		sections.forEach { section in
			snapshot.appendItems(section.items as! [CellType.Provided], toSection: section)
			print(section)
		}
		diffableDataSource?.apply(snapshot, animatingDifferences: animatingDifferences)
	}
	
	private func update(for section: Section) {
		
		var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
		snapshot.appendSections(sections)
		snapshot.appendItems(section.items as! [CellType.Provided], toSection: section)
		diffableDataSource?.apply(snapshot)
	}
}

private extension UICollectionDDSViewModel {
	
	private func cellProvider(_ collectionView: UICollectionView, indexPath: IndexPath, item: Item) -> UICollectionViewCell? {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! CellType
		cell.provide(item)
		return cell
	}
	
}
#endif
