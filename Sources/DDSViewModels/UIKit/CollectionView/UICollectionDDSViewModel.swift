#if os(iOS) || os(tvOS)
import UIKit

open class UICollectionDDSViewModel<SectionType: Section, CellType: UICollectionViewCell & Providing>: NSObject {
	public typealias Section = SectionType
	public typealias Item = Section.Item
	
//	@Published public var items: [Item] = .init([])
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

private extension UICollectionDDSViewModel {
	
	private func cellProvider(_ collectionView: UICollectionView, indexPath: IndexPath, item: Item) -> UICollectionViewCell? {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! CellType
		cell.provide(item as! CellType.Provided)
		return cell
	}
	
}
#endif
