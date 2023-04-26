#if os(iOS) || os(tvOS)
import XCTest
import UIKit
@testable import DDSViewModels

final class MockUICollectionView: UICollectionView {
	
	var performBatchUpdatesCalledCount = 0
	
	init() {
		super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
		
		let window = UIWindow()
		window.addSubview(self)
	}
	
	@available(*, unavailable)
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func performBatchUpdates(_ updates: (() -> Void)?, completion: ((Bool) -> Void)? = nil) {
		performBatchUpdatesCalledCount += 1
		updates?()
		completion?(true)
	}
	
	override func insertSections(_ sections: IndexSet) {}
	override func insertItems(at indexPaths: [IndexPath]) {}
}
#endif
