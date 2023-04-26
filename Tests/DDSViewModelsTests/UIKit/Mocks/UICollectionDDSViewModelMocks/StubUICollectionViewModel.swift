#if os(iOS) || os(tvOS)
import XCTest
@testable import DDSViewModels

final class StubUICollectionViewModel: UICollectionDDSViewModel<DummySection, FakeUICollectionViewCell> {
	
	var didSelectItemAtCalledCount = 0
	
	init(collectionView: UICollectionView) {
		super.init(collectionView: collectionView, cellReuseIdentifier: "FakeUICollectionViewCell")
	}
}

extension StubUICollectionViewModel: UICollectionViewDelegate {}
#endif
