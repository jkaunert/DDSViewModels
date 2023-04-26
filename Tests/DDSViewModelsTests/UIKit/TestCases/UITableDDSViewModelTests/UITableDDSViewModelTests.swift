#if os(iOS) || os(tvOS)
import XCTest
@testable import DDSViewModels

final class UITableDDSViewModelTests: XCTestCase {
	
	private typealias DiffableDataSource = UITableViewDiffableDataSource<DummySection, DummyItem>
	private typealias Snapshot = NSDiffableDataSourceSnapshot<DummySection, DummyItem>
	private let dummySection = DummySection(title: "dummySection")
	private let dummyItems: [DummyItem] = [
		DummyItem(text: "dummy1"),
		DummyItem(text: "dummy2"),
		DummyItem(text: "dummy3"),
		DummyItem(text: "dummy4"),
		DummyItem(text: "dummy5"),
		DummyItem(text: "dummy6"),
	]
	
	private var sut: UITableDDSViewModel<DummySection, FakeUITableViewCell>!
	private var tableVC: FakeUITableViewController!
	private var dataSource: DiffableDataSource!
	private var snapshot: Snapshot!
	
	override func setUpWithError() throws {
		try super.setUpWithError()

		tableVC = FakeUITableViewController()
		tableVC.loadViewIfNeeded()
		sut = tableVC.viewModel
		dataSource = sut.diffableDataSource
		snapshot = Snapshot()
	}
	
	override func tearDownWithError() throws {
		
		snapshot = nil
		dataSource = nil
		tableVC = nil
	}
	
	func test_viewController_tableView_shouldBeSetUp() throws {
			
			XCTAssertNotNil(try XCTUnwrap(tableVC.tableView))
		}
	
	func test_init() {
				
		XCTAssertNotNil(sut)
	}
	
	func test_init_dataSource_shouldBeCorrectKind() throws {
		
		XCTAssertTrue(try XCTUnwrap(dataSource) .isKind(of: DiffableDataSource.self))
	}
	
	func test_apply_whenAppendingItemsToMainSection_shouldDiffCorrectly() {
	
		let e1 = expectation(description: "test_apply_whenAppendingItemsToMainSection_shouldDiffCorrectly() e1")
		dataSource.apply(snapshot, completion: e1.fulfill)
		wait(for: [e1], timeout: 1)
		snapshot.appendSections([dummySection])
		snapshot.appendItems([dummyItems[0]])
		XCTAssertEqual(snapshot.numberOfItems, 1)

		let e2 = expectation(description: "test_apply_whenAppendingItemsToMainSection_shouldDiffCorrectly() e2")
		dataSource.apply(snapshot, completion: e2.fulfill)
		wait(for: [e2], timeout: 1)
		XCTAssertEqual(snapshot.numberOfItems, 1)

		let e3 = expectation(description: "test_apply_whenAppendingItemsToMainSection_shouldDiffCorrectly() e3")
		dataSource.apply(snapshot, completion: e3.fulfill)
		wait(for: [e3], timeout: 1)
		snapshot.appendItems([dummyItems[1]])
		XCTAssertEqual(snapshot.numberOfItems, 2)

		let e4 = expectation(description: "test_apply_whenAppendingItemsToMainSection_shouldDiffCorrectly() e4")
		dataSource.apply(snapshot, completion: e4.fulfill)
		wait(for: [e4], timeout: 1)
		XCTAssertEqual(snapshot.numberOfItems, 2)
	}

	func test_apply_whenRemovingItemsFromMainSection_shouldDiffCorrectly() {
	
		let e1 = expectation(description: "test_apply_whenRemovingItemsFromMainSection_shouldDiffCorrectly() e1")
		dataSource.apply(snapshot, completion: e1.fulfill)
		wait(for: [e1], timeout: 1)
		snapshot.appendSections([dummySection])
		snapshot.appendItems([dummyItems[0], dummyItems[1]])
		XCTAssertEqual(snapshot.numberOfItems, 2)

		let e2 = expectation(description: "test_apply_whenRemovingItemsFromMainSection_shouldDiffCorrectly() e2")
		dataSource.apply(snapshot, completion: e2.fulfill)
		wait(for: [e2], timeout: 1)
		snapshot.deleteItems([dummyItems[0]])
		XCTAssertEqual(snapshot.numberOfItems, 1)

		let e3 = expectation(description: "test_apply_whenRemovingItemsFromMainSection_shouldDiffCorrectly() e3")
		dataSource.apply(snapshot, completion: e3.fulfill)
		wait(for: [e3], timeout: 1)
		snapshot.appendItems([
			dummyItems[1],
			dummyItems[2],
			dummyItems[3],
		])
		snapshot.deleteItems([dummyItems[2]])
		XCTAssertEqual(snapshot.numberOfItems, 2)

		let e4 = expectation(description: "test_apply_whenRemovingItemsFromMainSection_shouldDiffCorrectly() e4")
		dataSource.apply(snapshot, completion: e4.fulfill)
		wait(for: [e4], timeout: 1)
		snapshot.deleteItems([dummyItems[3]])
		XCTAssertEqual(snapshot.numberOfItems, 1)
	}

	func test_apply_whenRemovingAllItemsFromMainSection_shouldDiffCorrectly() {
		
		let e1 = expectation(description: "test_apply_whenRemovingAllItemsFromMainSection_shouldDiffCorrectly() e1")
		dataSource.apply(snapshot, completion: e1.fulfill)
		wait(for: [e1], timeout: 1)
		snapshot.appendSections([dummySection])
		snapshot.appendItems([
			dummyItems[0],
			dummyItems[2],
			dummyItems[3],
			dummyItems[4],
		])
		XCTAssertEqual(snapshot.numberOfItems, 4)
		snapshot.deleteAllItems()
		XCTAssertEqual(snapshot.numberOfItems, 0)
	}
	
	func test_add() {
		
		let e1 = expectation(description: "test_add() e1")
		sut.add([dummyItems[0]], to: dummySection) {
			e1.fulfill()
		}
		wait(for: [e1], timeout: 1)
		XCTAssertEqual(sut.items.count, 1)

		let e2 = expectation(description: "test_add() e2")
		sut.add([], to: dummySection) {
			e2.fulfill()
		}
		wait(for: [e2], timeout: 0.001)
		XCTAssertEqual(sut.items.count, 1)

		let e3 = expectation(description: "test_add() e3")
		sut.add([dummyItems[1]], to: dummySection) {
			e3.fulfill()
		}
		wait(for: [e3], timeout: 0.001)
		XCTAssertEqual(sut.items.count, 2)

		let e4 = expectation(description: "test_add() e4")
		sut.add([], to: dummySection) {
			e4.fulfill()
		}
		wait(for: [e4], timeout: 0.001)
		XCTAssertEqual(sut.items.count, 2)
	}

	func test_remove() {
		
		let e1 = expectation(description: "test_remove() e1")
		sut.add([
			dummyItems[0],
			dummyItems[1],
			dummyItems[2],
			dummyItems[3],
		], to: dummySection)
		XCTAssertEqual(sut.items.count, 4, "precondition")
		sut.remove([dummyItems[0]], from: dummySection) {
			e1.fulfill()
		}
		wait(for: [e1], timeout: 0.001)
		XCTAssertEqual(sut.items.count, 3)

		let e2 = expectation(description: "test_remove() e2")
		sut.remove([dummyItems[2]], from: dummySection) {
			e2.fulfill()
		}
		wait(for: [e2], timeout: 0.001)
		XCTAssertEqual(sut.items.count, 2)

		let e3 = expectation(description: "test_remove() e3")
		sut.remove([dummyItems[1]], from: dummySection ) {
			e3.fulfill()
		}
		wait(for: [e3], timeout: 0.001)
		XCTAssertEqual(sut.items.count, 1)
	}
	
	func test_snapshot() {
		
		let snapshot1 = dataSource.snapshot()
		XCTAssertEqual(snapshot1.sectionIdentifiers, [])
		XCTAssertEqual(snapshot1.itemIdentifiers, [])
		
		var snapshot2 = dataSource.snapshot()
		snapshot2.appendSections([dummySection])
		
		let snapshot3 = dataSource.snapshot()
		XCTAssertEqual(snapshot3.sectionIdentifiers, [])
		XCTAssertEqual(snapshot3.itemIdentifiers, [])
		snapshot.appendSections([dummySection])
		snapshot.appendItems([
			dummyItems[0],
			dummyItems[1],
			dummyItems[2],
		]
		)
		dataSource.apply(snapshot)
		
		let snapshot4 = dataSource.snapshot()
		XCTAssertEqual(snapshot4.sectionIdentifiers, [dummySection])
		XCTAssertEqual(
			snapshot4.itemIdentifiers,
			[
				dummyItems[0],
				dummyItems[1],
				dummyItems[2]
			])
		
		var snapshot5 = dataSource.snapshot()
		snapshot5.appendSections([])
		XCTAssertEqual(snapshot5.sectionIdentifiers, [dummySection])
		XCTAssertEqual(
			snapshot5.itemIdentifiers,
			[
				dummyItems[0],
				dummyItems[1],
				dummyItems[2]
			])
		
		var snapshot6 = dataSource.snapshot()
		XCTAssertEqual(snapshot6.sectionIdentifiers, [dummySection])
		XCTAssertEqual(
			snapshot6.itemIdentifiers,
			[
				dummyItems[0],
				dummyItems[1],
				dummyItems[2]
			])
		
		snapshot6.appendSections([])
		snapshot6.appendItems([
			dummyItems[3],
			dummyItems[4],
			dummyItems[5]
		])
		dataSource.apply(snapshot6)
		
		let snapshot7 = dataSource.snapshot()
		XCTAssertEqual(snapshot7.sectionIdentifiers, [dummySection])
		XCTAssertEqual(
			snapshot7.itemIdentifiers,
			[
				dummyItems[0],
				dummyItems[1],
				dummyItems[2],
				dummyItems[3],
				dummyItems[4],
				dummyItems[5],
			])
	}
	
	func test_itemIdentifier() {
		
		snapshot.appendSections([dummySection])
		snapshot.appendItems([
			dummyItems[0],
			dummyItems[1],
			dummyItems[2]
		], toSection: dummySection)
		dataSource.apply(snapshot)
		XCTAssertEqual(dataSource.itemIdentifier(for: IndexPath(item: 0, section: 0)), dummyItems[0])
		XCTAssertEqual(dataSource.itemIdentifier(for: IndexPath(item: 1, section: 0)), dummyItems[1])
		XCTAssertEqual(dataSource.itemIdentifier(for: IndexPath(item: 2, section: 0)), dummyItems[2])
		XCTAssertEqual(dataSource.itemIdentifier(for: IndexPath(item: 100, section: 100)), nil)
	}

	func test_indexPathFor() {
		
		snapshot.appendSections([dummySection])
		snapshot.appendItems([
			dummyItems[0],
			dummyItems[1],
			dummyItems[2]
		], toSection: dummySection)
		dataSource.apply(snapshot)
		XCTAssertEqual(dataSource.indexPath(for: dummyItems[2]), IndexPath(item: 2, section: 0))
		XCTAssertEqual(dataSource.indexPath(for: dummyItems[0]), IndexPath(item: 0, section: 0))
	}

	func test_numberOfSections() {
				
		XCTAssertEqual(dataSource.numberOfSections(in: tableVC.tableView), 0, "precondition")
		snapshot.appendSections([dummySection])
		snapshot.appendItems([
			dummyItems[0],
			dummyItems[1],
			dummyItems[2]
		], toSection: dummySection)
		dataSource.apply(snapshot)
		XCTAssertEqual(dataSource.numberOfSections(in: tableVC.tableView), 1)
	}

	func test_numberOfRowsInSection() {
		
		snapshot.appendSections([dummySection])
		snapshot.appendItems([
			dummyItems[0],
			dummyItems[1],
			dummyItems[2]
		], toSection: dummySection)
		dataSource.apply(snapshot)
		XCTAssertEqual(dataSource.tableView(tableVC.tableView, numberOfRowsInSection: 0), 3)
	}
	
	func test_cellForRowAt() {

		snapshot.appendSections([dummySection])
		snapshot.appendItems([
			dummyItems[0],
			dummyItems[1],
			dummyItems[2]
		], toSection: dummySection)
		dataSource.apply(snapshot)

		let sutCell = tableVC.tableView.dequeueReusableCell(withIdentifier: "FakeUITableViewCell", for: IndexPath(item: 0, section: 0)) as? FakeUITableViewCell
		sutCell?.provide(dummyItems[1])
		
		let dataSourceCell = dataSource.tableView(tableVC.tableView, cellForRowAt:  IndexPath(item: 0, section: 0)) as? FakeUITableViewCell
		dataSourceCell?.provide(dummyItems[1])
		XCTAssertEqual(
			dataSourceCell?.textLabel?.text,
			sutCell?.textLabel?.text
		)
	}
	
	func test_canMoveRowAt() {
		
		snapshot.appendSections([dummySection])
		snapshot.appendItems([
			dummyItems[0],
			dummyItems[1],
			dummyItems[2]
		], toSection: dummySection)
		dataSource.apply(snapshot)
		XCTAssertEqual(
			dataSource.tableView(tableVC.tableView, canMoveRowAt: IndexPath(item: 1, section: 0)),
			false
		)
	}
}
#endif
