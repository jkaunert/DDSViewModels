#if os(iOS) || os(tvOS)
import UIKit

open class UICollectionDDSViewModel<SectionType: Section, CellType: UICollectionViewCell & Providing>: NSObject {
	public typealias Section = SectionType
	public typealias Item = CellType.Provided
	
	@Published public var items: [Item] = .init([])
	
	private weak var collectionView: UICollectionView?
	
	public private(set) var diffableDataSource: UICollectionViewDiffableDataSource<Section, Item>?
	
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
		self.diffableDataSource = diffableDataSource
		return diffableDataSource
	}
	
	func add(_ items: [Item], to section: Section, completion: (() -> Void)? = nil) {
		
		self.items.append(contentsOf: items)
		update(for: section)
		completion?()
	}
	
	func remove(_ items: [Item], from section: Section, completion: (() -> Void)? = nil) {
		self.items.removeAll { items.contains($0) }
		update(section: section, items: items)
		completion?()
	}
	
	private func update(section: Section, items: [Item]) {
		var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
		let sections: [Section] = Section.returnSections()
		print(sections)
		snapshot.appendSections(sections)
		snapshot.appendItems(items, toSection: section)
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
