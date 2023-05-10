#if os(iOS) || os(tvOS)
import XCTest
@testable import DDSViewModels

final class StubUICollectionViewModel: UICollectionDDSViewModel<DummySection, FakeUICollectionViewCell> {
	
	var didSelectItemAtCalledCount = 0
	
	init(collectionView: UICollectionView) {
		super.init(collectionView: collectionView, cellReuseIdentifier: "FakeUICollectionViewCell")
	}
	
	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		didSelectItemAtCalledCount += 1
		guard let item = diffableDataSource?.itemIdentifier(for: indexPath) else { return }
		
		print(item)
	}
}
#endif
