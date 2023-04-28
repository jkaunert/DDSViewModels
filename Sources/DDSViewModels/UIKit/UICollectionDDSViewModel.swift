#if os(iOS) || os(tvOS)
import UIKit

open class UICollectionDDSViewModel<SectionType: DDSSection, CellType: UICollectionViewCell & Providing>: NSObject {
	
	public typealias ItemType = CellType.Provided
	public typealias DiffableDataSource = UICollectionViewDiffableDataSource<SectionType, ItemType>
	
	@Published public var items: [ItemType] = .init([])
	
	private weak var collectionView: UICollectionView?
	
	var diffableDataSource: DiffableDataSource?
	
	private var cellIdentifier: String
	
	public init(collectionView: UICollectionView,  cellReuseIdentifier: String) {
		self.collectionView = collectionView
		self.cellIdentifier = cellReuseIdentifier
		super.init()
	}
}

public extension UICollectionDDSViewModel {
	
	func makeDiffableDataSource() -> DiffableDataSource {
		guard let collectionView else { fatalError("CollectionView should exist but doesn't") }
		let diffableDataSource = DiffableDataSource(collectionView: collectionView, cellProvider: cellProvider)
		self.diffableDataSource = diffableDataSource
		return diffableDataSource
	}
	
	func add(_ items: [ItemType], to section: SectionType, completion: (() -> Void)? = nil) {
		self.items.append(contentsOf: items)
		update(for: section)
		completion?()
	}
	
	func remove(_ items: [ItemType], from section: SectionType, completion: (() -> Void)? = nil) {
		self.items.removeAll { items.contains($0) }
		update(for: section)
		completion?()
	}
}

private extension UICollectionDDSViewModel {
	
	private func cellProvider(_ collectionView: UICollectionView, indexPath: IndexPath, item: ItemType) -> UICollectionViewCell? {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! CellType
		cell.provide(item)
		return cell
	}
	
	private func update(for section: SectionType) {
		var snapshot = NSDiffableDataSourceSnapshot<SectionType, ItemType>()
		snapshot.appendSections([section])
		snapshot.appendItems(items)
		diffableDataSource?.apply(snapshot)
	}
}
#endif
