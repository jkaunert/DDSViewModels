#if os(iOS) || os(tvOS)
import UIKit

open class UICollectionDDSViewModel<SectionType: Hashable, CellType: UICollectionViewCell & Providing>: NSObject {
	
	public typealias Section = SectionType
	public typealias Item = CellType.Provided
	public typealias DiffableDataSource = UICollectionViewDiffableDataSource<Section, Item>
	private weak var collectionView: UICollectionView?
	@Published public var items: [Item] = .init([])
	var diffableDataSource: DiffableDataSource?
	private var cellIdentifier: String
	
	init(collectionView: UICollectionView,  cellReuseIdentifier: String) {
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
	
	func add(_ items: [Item], to section: Section, completion: (() -> Void)? = nil) {
		self.items.append(contentsOf: items)
		update(for: section)
		completion?()
	}
	
	func remove(_ items: [Item], from section: Section, completion: (() -> Void)? = nil) {
		self.items.removeAll { items.contains($0) }
		update(for: section)
		completion?()
	}
}

private extension UICollectionDDSViewModel {
	
	private func cellProvider(_ collectionView: UICollectionView, indexPath: IndexPath, item: Item) -> UICollectionViewCell? {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! CellType
		cell.provide(item)
		return cell
	}
	
	private func update(for section: Section) {
		var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
		snapshot.appendSections([section])
		snapshot.appendItems(items)
		diffableDataSource?.apply(snapshot)
	}
}
#endif
