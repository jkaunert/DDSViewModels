#if os(iOS) || os(tvOS)
@testable import DDSViewModels
import XCTest

final class UICollectionViewDDSTests: XCTestCase {

	private var collectionView: MockUICollectionView!
	private var sutCell: MockUICollectionViewCell!
	private var sut: UICollectionViewDiffableDataSource<Int, Int>!
	private var snapshot: NSDiffableDataSourceSnapshot<Int, Int>!
	
	override func setUpWithError() throws {
		try super.setUpWithError()
		collectionView = MockUICollectionView()
		sutCell = MockUICollectionViewCell()
		sut = UICollectionViewDiffableDataSource<Int, Int>(collectionView: collectionView) { _, _, _ in
			self.sutCell
		}
		snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
	}

	
	override func tearDownWithError() throws {
		collectionView = nil
		sutCell = nil
		sut = nil
		snapshot = nil
		try super.tearDownWithError()
	}

	func test_whenInit_dataSourceShouldBeCorrectlySetup() {
		
		XCTAssertNotNil(collectionView.dataSource, "precondition")
		
		XCTAssertTrue(collectionView.dataSource === sut)
	}
	
	func test_snapshotApply_shouldCallPerformBatchUpdatesAsExpected() {
		
		let e1 = expectation(description: "testApply() e1")
		sut.apply(snapshot, completion: e1.fulfill)
		wait(for: [e1], timeout: 1)
		
		XCTAssertEqual(collectionView.isPerformBatchUpdatesCalledCount, 1)
		
		snapshot.appendSections([0])
		snapshot.appendItems([0])
		
		let e2 = expectation(description: "testApply() e2")
		sut.apply(snapshot, completion: e2.fulfill)
		wait(for: [e2], timeout: 1)
		
		XCTAssertEqual(collectionView.isPerformBatchUpdatesCalledCount, 2)
		
		let e3 = expectation(description: "testApply() e3")
		sut.apply(snapshot, completion: e3.fulfill)
		wait(for: [e3], timeout: 1)
		
		XCTAssertEqual(collectionView.isPerformBatchUpdatesCalledCount, 3)
		
		snapshot.appendItems([1])
		
		let e4 = expectation(description: "testApply() e4")
		sut.apply(snapshot, completion: e4.fulfill)
		wait(for: [e4], timeout: 1)
		
		XCTAssertEqual(collectionView.isPerformBatchUpdatesCalledCount, 4)
	}
	
	func test_snapshotApply_shouldHaveSectionAndItemIdentifiers() {
		
			let snapshot1 = sut.snapshot()
			XCTAssertEqual(snapshot1.sectionIdentifiers, [])
			XCTAssertEqual(snapshot1.itemIdentifiers, [])
			
			var snapshot2 = sut.snapshot()
			snapshot2.appendSections([0, 1, 2])
			
			let snapshot3 = sut.snapshot()
			XCTAssertEqual(snapshot3.sectionIdentifiers, [])
			XCTAssertEqual(snapshot3.itemIdentifiers, [])
			
			snapshot.appendSections([0, 1, 2])
			snapshot.appendItems([0, 1, 2])
			sut.apply(snapshot)
			
			let snapshot4 = sut.snapshot()
			XCTAssertEqual(snapshot4.sectionIdentifiers, [0, 1, 2])
			XCTAssertEqual(snapshot4.itemIdentifiers, [0, 1, 2])
			
			var snapshot5 = sut.snapshot()
			snapshot5.appendSections([3, 4, 5])
			
			var snapshot6 = sut.snapshot()
			XCTAssertEqual(snapshot6.sectionIdentifiers, [0, 1, 2])
			XCTAssertEqual(snapshot6.itemIdentifiers, [0, 1, 2])
			
			snapshot6.appendSections([3, 4, 5])
			snapshot6.appendItems([3, 4, 5])
			sut.apply(snapshot6)
			
			let snapshot7 = sut.snapshot()
			XCTAssertEqual(snapshot7.sectionIdentifiers, [0, 1, 2, 3, 4, 5])
			XCTAssertEqual(snapshot7.itemIdentifiers, [0, 1, 2, 3, 4, 5])
		
	}
	
	func test_dataSource_whenSnapshotApply_shouldHaveCorrectItemIdentifiers() {
		
		snapshot.appendSections([0, 1, 2])
		snapshot.appendItems([0, 1, 2], toSection: 0)
		sut.apply(snapshot)
		
		XCTAssertEqual(sut.itemIdentifier(for: IndexPath(item: 1, section: 0)), 1)
		XCTAssertEqual(sut.itemIdentifier(for: IndexPath(item: 100, section: 100)), nil)
	}
	
	func test_dataSource_whenSnapshotApply_shouldHaveCorrectIndexPaths() {
		
		snapshot.appendSections([0, 1, 2])
		snapshot.appendItems([0, 1, 2], toSection: 0)
		sut.apply(snapshot)
		
		XCTAssertEqual(sut.indexPath(for: 2), IndexPath(item: 2, section: 0))
		XCTAssertEqual(sut.indexPath(for: 100), nil)
	}
	
	func test_dataSource_whenSnapshotApply_shouldHaveCorrectNumberOfSections() {
		
		XCTAssertEqual(sut.numberOfSections(in: collectionView), 0)
		
		var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
		snapshot.appendSections([0, 1, 2])
		snapshot.appendItems([0, 1, 2], toSection: 0)
		sut.apply(snapshot)
		
		XCTAssertEqual(sut.numberOfSections(in: collectionView), 3)
	}
	
	func test_dataSource_whenSnapshotApply_shouldHaveCorrectNumberOfItemsInSection() {
		
		snapshot.appendSections([0, 1, 2])
		snapshot.appendItems([0, 1, 2], toSection: 0)
		sut.apply(snapshot)
		
		XCTAssertEqual(sut.collectionView(collectionView, numberOfItemsInSection: 0), 3)
	}
	
	func test_dataSource_cellForItemAt() {
		
		snapshot.appendSections([0, 1, 2])
		snapshot.appendItems([0, 1, 2], toSection: 0)
		sut.apply(snapshot)
		
		XCTAssertEqual(
			sut.collectionView(collectionView, cellForItemAt: IndexPath(item: 1, section: 0)),
			sutCell
		)
	}
	
	func test_dataSource_canMoveItemAt_shouldReturnFalse() {
		snapshot.appendSections([0, 1, 2])
		snapshot.appendItems([0, 1, 2], toSection: 0)
		sut.apply(snapshot)
		
		XCTAssertEqual(
			sut.collectionView(collectionView, canMoveItemAt: IndexPath(item: 1, section: 0)),
			false
		)
	}
}
#endif
