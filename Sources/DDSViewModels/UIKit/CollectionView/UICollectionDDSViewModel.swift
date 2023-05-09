#if os(iOS) || os(tvOS)
import UIKit

open class UICollectionDDSViewModel<SectionType: Section, CellType: UICollectionViewCell & Providing>: NSObject, UICollectionViewDelegate {
	
	public typealias Section = SectionType
	public typealias Item = Section.Item
	public typealias Provided = CellType.Provided
	
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
	
	open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {}
}

public extension UICollectionDDSViewModel {
	
	func makeDiffableDataSource() -> UICollectionViewDiffableDataSource<Section, Item> {
		guard let collectionView = self.collectionView else { fatalError("CollectionView should exist but doesn't") }
		let diffableDataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: cellProvider)
		diffableDataSource.supplementaryViewProvider =  supplementaryViewProvider(collectionView:kind:indexPath:)
		collectionView.register(
			CollectionViewSectionHeader.self,
			forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
			withReuseIdentifier: CollectionViewSectionHeader.reuseIdentifier
		)
		collectionView.register(CellType.self, forCellWithReuseIdentifier: cellIdentifier)
		self.diffableDataSource = diffableDataSource
		self.collectionView = collectionView
		self.collectionView?.delegate = self
		return diffableDataSource
	}
	
	private func applySnapshot(animatingDifferences: Bool = true, completion: (() -> Void)? = nil) {
		snapshot.deleteAllItems()
		snapshot.appendSections(sections)
		sections.forEach { section in
			snapshot.deleteItems(section.items)
			snapshot.appendItems(section.items, toSection: section)
		}
		
		diffableDataSource?.apply(snapshot, animatingDifferences: animatingDifferences)
		completion?()
	}
	
	func update(animatingDifferences: Bool = true, completion: (() -> Void)? = nil) {
		applySnapshot(animatingDifferences: animatingDifferences)
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

private extension UICollectionDDSViewModel {
	
	private func cellProvider(_ collectionView: UICollectionView, indexPath: IndexPath, item: Item) -> UICollectionViewCell? {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! CellType
		cell.provide(item as! Provided)
		return cell
	}
	
	private func supplementaryViewProvider(collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? {
		var reusableView: UICollectionReusableView?
		switch kind {
			case UICollectionView.elementKindSectionHeader:
				let section = self.diffableDataSource?.snapshot()
					.sectionIdentifiers[indexPath.section]
				let view = collectionView.dequeueReusableSupplementaryView(
					ofKind: kind,
					withReuseIdentifier: CollectionViewSectionHeader.reuseIdentifier,
					for: indexPath) as? CollectionViewSectionHeader
				view?.titleLabel.text = section?.title
				reusableView = view
				
			default:
				reusableView = nil
		}
		return reusableView
	}
}
#endif
