#if os(iOS) || os(tvOS)
import UIKit

public class DiffableCollectionViewDataSource<SectionType: Section, CellType: UICollectionViewCell & Providing>: UICollectionViewDiffableDataSource<SectionType, CellType.Provided> {
	
	public override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		let sectionKind = SectionType.allSections[indexPath.section] as? SectionType
		return UICollectionReusableView(frame: .zero)
	}

	public override func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
		return true
	}
	
	public override func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
		guard let sourceIdentifier = itemIdentifier(for: sourceIndexPath) else { return }
		guard sourceIndexPath != destinationIndexPath else { return }
		let destinationIdentifier = itemIdentifier(for: destinationIndexPath)
		
		var snapshot = self.snapshot()
		
		if let destinationIdentifier = destinationIdentifier {
			if let sourceIndex = snapshot.indexOfItem(sourceIdentifier),
			   let destinationIndex = snapshot.indexOfItem(destinationIdentifier) {
				let isAfter = destinationIndex > sourceIndex &&
				snapshot.sectionIdentifier(containingItem: sourceIdentifier) ==
				snapshot.sectionIdentifier(containingItem: destinationIdentifier)
				snapshot.deleteItems([sourceIdentifier])
				if isAfter {
					snapshot.insertItems([sourceIdentifier], afterItem: destinationIdentifier)
				}
				else {
					snapshot.insertItems([sourceIdentifier], beforeItem: destinationIdentifier)
				}
			}
		}
		else {
			let destinationSectionIdentifier = snapshot.sectionIdentifiers[destinationIndexPath.section]
			snapshot.deleteItems([sourceIdentifier])
			snapshot.appendItems([sourceIdentifier], toSection: destinationSectionIdentifier)
		}
		apply(snapshot, animatingDifferences: false)
	}
	
	// MARK: editing support
	public override func collectionView(_ collectionView: UICollectionView, indexPathForIndexTitle title: String, at index: Int) -> IndexPath {
		return IndexPath(item: index, section: 0)
		//
	}

}
#endif
