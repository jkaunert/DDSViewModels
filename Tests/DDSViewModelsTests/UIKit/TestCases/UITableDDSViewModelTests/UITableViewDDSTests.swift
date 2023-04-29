#if os(iOS) || os(tvOS)
import XCTest
@testable import DDSViewModels

final class UITableViewDDSTests: XCTestCase {
	
	private typealias Snapshot = NSDiffableDataSourceSnapshot<DummySection, FakeUITableViewCell.Provided>
	
	private var tableView: MockUITableView!
	private var sutCell: FakeUITableViewCell!
	private var sut: DiffableTableViewDataSource<DummySection, FakeUITableViewCell>!
	private var snapshot: Snapshot!
	
	private var sections: [DummySection] = [
		DummySection(title: "DummyTitle1"),
		DummySection(title: "DummyTitle2"),
		DummySection(title: "DummyTitle3"),
		DummySection(title: "DummyTitle4"),
		DummySection(title: "DummyTitle5"),
		DummySection(title: "DummyTitle6"),
		DummySection(title: "DummyTitle7"),

	]
	
	private let items = [
		DummyItem(text: "Dummy Item 1"),
		DummyItem(text: "Dummy Item 2"),
		DummyItem(text: "Dummy Item 3"),
		DummyItem(text: "Dummy Item 4"),
		DummyItem(text: "Dummy Item 5"),
		DummyItem(text: "Dummy Item 6"),
		DummyItem(text: "Dummy Item 7"),
		DummyItem(text: "Dummy Item 8"),
	]
	
	override func setUpWithError() throws {
		try super.setUpWithError()
		tableView = MockUITableView()
		sutCell = FakeUITableViewCell()
		sut = DiffableTableViewDataSource<DummySection, FakeUITableViewCell>(tableView: tableView) { _, _, _ in
			self.sutCell
		}
		snapshot = Snapshot()
	}
	
	override func tearDownWithError() throws {
		snapshot = nil
		sut = nil
		tableView = nil
		sutCell = nil
		try super.tearDownWithError()
	}
	
	func test_whenInit_dataSourceShouldBeCorrectlySetup() {

		XCTAssertTrue(tableView.dataSource === sut)
	}
	
	func test_snapshotApply_shouldCallPerformBatchUpdatesAsExpected() {
		
		let e1 = expectation(description: "test_snapshotApply_shouldCallPerformBatchUpdatesAsExpected() e1")
		sut.apply(snapshot, completion: e1.fulfill)
		wait(for: [e1], timeout: 1)
		XCTAssertEqual(tableView.performBatchUpdatesCalledCount, 1)
		snapshot.appendSections([sections[0]])
		snapshot.appendItems([items[0]])
		
		let e2 = expectation(description: "test_snapshotApply_shouldCallPerformBatchUpdatesAsExpected() e2")
		sut.apply(snapshot, completion: e2.fulfill)
		wait(for: [e2], timeout: 1)
		XCTAssertEqual(tableView.performBatchUpdatesCalledCount, 2)
		
		let e3 = expectation(description: "test_snapshotApply_shouldCallPerformBatchUpdatesAsExpected() e3")
		sut.apply(snapshot, completion: e3.fulfill)
		wait(for: [e3], timeout: 1)
		XCTAssertEqual(tableView.performBatchUpdatesCalledCount, 3)
		snapshot.appendItems([items[1]])
	
		let e4 = expectation(description: "test_snapshotApply_shouldCallPerformBatchUpdatesAsExpected() e4")
		sut.apply(snapshot, completion: e4.fulfill)
		wait(for: [e4], timeout: 1)
		XCTAssertEqual(tableView.performBatchUpdatesCalledCount, 4)
	}
	
	func test_snapshotApply_shouldHaveSectionAndItemIdentifiers() {

		let snapshot1 = sut.snapshot()
		XCTAssertEqual(snapshot1.sectionIdentifiers, [])
		XCTAssertEqual(snapshot1.itemIdentifiers, [])
		
		var snapshot2 = sut.snapshot()
		snapshot2.appendSections([sections[0], sections[1], sections[2]])
		
		let snapshot3 = sut.snapshot()
		XCTAssertEqual(snapshot3.sectionIdentifiers, [])
		XCTAssertEqual(snapshot3.itemIdentifiers, [])
		
		snapshot.appendSections([sections[0], sections[1], sections[2]])
		snapshot.appendItems([items[0], items[1], items[2]])
		sut.apply(snapshot)
		
		let snapshot4 = sut.snapshot()
		XCTAssertEqual(snapshot4.sectionIdentifiers, [sections[0], sections[1], sections[2]])
		XCTAssertEqual(snapshot4.itemIdentifiers, [items[0], items[1], items[2]])
		
		var snapshot5 = sut.snapshot()
		snapshot5.appendSections([sections[3], sections[4], sections[5]])
		
		var snapshot6 = sut.snapshot()
		XCTAssertEqual(snapshot6.sectionIdentifiers, [sections[0], sections[1], sections[2]])
		XCTAssertEqual(snapshot6.itemIdentifiers, [items[0], items[1], items[2]])
		
		snapshot6.appendSections([sections[3], sections[4], sections[5]])
		snapshot6.appendItems([items[3], items[4], items[5]])
		sut.apply(snapshot6)
		
		let snapshot7 = sut.snapshot()
		XCTAssertEqual(snapshot7.sectionIdentifiers, [sections[0], sections[1], sections[2], sections[3], sections[4], sections[5]])
		XCTAssertEqual(snapshot7.itemIdentifiers, [items[0], items[1], items[2], items[3], items[4], items[5]])
	}
	
	func test_dataSource_whenSnapshotApply_shouldHaveCorrectItemIdentifiers() {

		snapshot.appendSections([sections[0], sections[1], sections[2],])
		snapshot.appendItems([items[0], items[1], items[2],], toSection: sections[0])
		sut.apply(snapshot)
		
		XCTAssertEqual(sut.itemIdentifier(for: IndexPath(item: 1, section: 0)), items[1])
		XCTAssertEqual(sut.itemIdentifier(for: IndexPath(item: 100, section: 100)), nil)
	}
	
	func test_dataSource_whenSnapshotApply_shouldHaveCorrectIndexPaths() throws {

		snapshot.appendSections([sections[0], sections[1], sections[2],])
		snapshot.appendItems([items[0], items[1], items[2],], toSection: sections[0])
		sut.apply(snapshot)
		
		XCTAssertEqual(sut.indexPath(for: items[2]), IndexPath(item: 2, section: 0))
	}
	
	func test_dataSource_whenSnapshotApply_shouldHaveCorrectNumberOfSections() {

		XCTAssertEqual(sut.numberOfSections(in: tableView), 0, "precondition")
		snapshot.appendSections([sections[0], sections[1], sections[2],])
		snapshot.appendItems([items[0], items[1], items[2],], toSection: sections[0])
		sut.apply(snapshot)
		XCTAssertEqual(sut.numberOfSections(in: tableView), 3)
	}
	
	func test_dataSource_whenSnapshotApply_shouldHaveCorrectNumberOfRowsInSection() {

		snapshot.appendSections([sections[0], sections[1], sections[2],])
		snapshot.appendItems([items[0], items[1], items[2],], toSection: sections[0])
		sut.apply(snapshot)
		XCTAssertEqual(sut.tableView(tableView, numberOfRowsInSection: 0), 3)
	}
	
	func test_dataSource_cellForRowAt() {

		snapshot.appendSections([sections[0], sections[1], sections[2],])
		snapshot.appendItems([items[0], items[1], items[2],], toSection: sections[0])
		sut.apply(snapshot)
		XCTAssertEqual(
			sut.tableView(tableView, cellForRowAt: IndexPath(item: 1, section: 0)),
			self.sutCell
		)
	}
	
	func test_dataSource_canEditRowAt_shouldReturnTrue() {

		snapshot.appendSections([sections[0], sections[1], sections[2],])
		snapshot.appendItems([items[0], items[1], items[2],], toSection: sections[0])
		sut.apply(snapshot)
		
		XCTAssertEqual(
			sut.tableView(tableView, canEditRowAt: IndexPath(item: 1, section: 0)),
			true
		)
	}
	
	func test_dataSource_canMoveItemAt_shouldReturnFalse() {

		snapshot.appendSections([sections[0], sections[1], sections[2],])
		snapshot.appendItems([items[0], items[1], items[2],], toSection: sections[0])
		sut.apply(snapshot)
		XCTAssertEqual(
			sut.tableView(tableView, canMoveRowAt: IndexPath(item: 1, section: 0)),
			true
		)
	}
}
#endif
