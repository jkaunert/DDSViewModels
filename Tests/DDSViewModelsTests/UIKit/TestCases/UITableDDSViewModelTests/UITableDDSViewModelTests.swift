#if os(iOS) || os(tvOS)
import XCTest
@testable import DDSViewModels

final class UITableDDSViewModelTests: XCTestCase {
	
	private typealias Snapshot = NSDiffableDataSourceSnapshot<DummySection, DummyItem>
	
	private let dummySection1 = DummySection(title: "dummySection")
	private let dummySection2 = DummySection(title: "dummySection2")
	
	private let section1DummyItems: [DummyItem] = [
		DummyItem(text: "dummy1"),
		DummyItem(text: "dummy2"),
		DummyItem(text: "dummy3"),
		DummyItem(text: "dummy4"),
		DummyItem(text: "dummy5"),
		DummyItem(text: "dummy6"),
	]
	
	private let section2DummyItems: [DummyItem] = [
		DummyItem(text: "dummy7"),
		DummyItem(text: "dummy8"),
		DummyItem(text: "dummy9"),
		DummyItem(text: "dummy10"),
		DummyItem(text: "dummy11"),
		DummyItem(text: "dummy12"),
	]
	
	private var sut: UITableDDSViewModel<DummySection, FakeUITableViewCell>!
	private var tableVC: FakeUITableViewController!
	private var dataSource: UITableViewDiffableDataSource<DummySection, DummyItem>!
	private var snapshot: Snapshot!
	
	override func setUpWithError() throws {
		try super.setUpWithError()
		DummySection.allSections = [dummySection1, dummySection2]
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
		
		XCTAssertTrue(try XCTUnwrap(dataSource) .isKind(of: UITableViewDiffableDataSource<DummySection, DummyItem>.self))
	}
	
	func test_apply_whenAppendingItemsToMainSection_shouldDiffCorrectly() {
	
		let e1 = expectation(description: "test_apply_whenAppendingItemsToMainSection_shouldDiffCorrectly() e1")
		dataSource.apply(snapshot, completion: e1.fulfill)
		wait(for: [e1], timeout: 1)
		snapshot.appendSections([dummySection1])
		snapshot.appendItems([section1DummyItems[0]])
		XCTAssertEqual(snapshot.numberOfItems, 1)

		let e2 = expectation(description: "test_apply_whenAppendingItemsToMainSection_shouldDiffCorrectly() e2")
		dataSource.apply(snapshot, completion: e2.fulfill)
		wait(for: [e2], timeout: 1)
		XCTAssertEqual(snapshot.numberOfItems, 1)

		let e3 = expectation(description: "test_apply_whenAppendingItemsToMainSection_shouldDiffCorrectly() e3")
		dataSource.apply(snapshot, completion: e3.fulfill)
		wait(for: [e3], timeout: 1)
		snapshot.appendItems([section1DummyItems[1]])
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
		snapshot.appendSections([dummySection1])
		snapshot.appendItems([section1DummyItems[0], section1DummyItems[1]])
		XCTAssertEqual(snapshot.numberOfItems, 2)

		let e2 = expectation(description: "test_apply_whenRemovingItemsFromMainSection_shouldDiffCorrectly() e2")
		dataSource.apply(snapshot, completion: e2.fulfill)
		wait(for: [e2], timeout: 1)
		snapshot.deleteItems([section1DummyItems[0]])
		XCTAssertEqual(snapshot.numberOfItems, 1)

		let e3 = expectation(description: "test_apply_whenRemovingItemsFromMainSection_shouldDiffCorrectly() e3")
		dataSource.apply(snapshot, completion: e3.fulfill)
		wait(for: [e3], timeout: 1)
		snapshot.appendItems([
			section1DummyItems[1],
			section1DummyItems[2],
			section1DummyItems[3],
		])
		snapshot.deleteItems([section1DummyItems[2]])
		XCTAssertEqual(snapshot.numberOfItems, 2)

		let e4 = expectation(description: "test_apply_whenRemovingItemsFromMainSection_shouldDiffCorrectly() e4")
		dataSource.apply(snapshot, completion: e4.fulfill)
		wait(for: [e4], timeout: 1)
		snapshot.deleteItems([section1DummyItems[3]])
		XCTAssertEqual(snapshot.numberOfItems, 1)
	}

	func test_apply_whenRemovingAllItemsFromMainSection_shouldDiffCorrectly() {
		
		let e1 = expectation(description: "test_apply_whenRemovingAllItemsFromMainSection_shouldDiffCorrectly() e1")
		dataSource.apply(snapshot, completion: e1.fulfill)
		wait(for: [e1], timeout: 1)
		snapshot.appendSections([dummySection1])
		snapshot.appendItems([
			section1DummyItems[0],
			section1DummyItems[2],
			section1DummyItems[3],
			section1DummyItems[4],
		])
		XCTAssertEqual(snapshot.numberOfItems, 4)
		snapshot.deleteAllItems()
		XCTAssertEqual(snapshot.numberOfItems, 0)
	}
	
	func test_add() {
		
		let e1 = expectation(description: "test_add() e1")
		sut.add([section1DummyItems[0]], to: dummySection1) {
			e1.fulfill()
		}
		wait(for: [e1], timeout: 1)
		XCTAssertEqual(sut.items.count, 1)

		let e2 = expectation(description: "test_add() e2")
		sut.add([], to: dummySection1) {
			e2.fulfill()
		}
		wait(for: [e2], timeout: 0.001)
		XCTAssertEqual(sut.items.count, 1)

		let e3 = expectation(description: "test_add() e3")
		sut.add([section1DummyItems[1]], to: dummySection1) {
			e3.fulfill()
		}
		wait(for: [e3], timeout: 0.001)
		XCTAssertEqual(sut.items.count, 2)

		let e4 = expectation(description: "test_add() e4")
		sut.add([], to: dummySection1) {
			e4.fulfill()
		}
		wait(for: [e4], timeout: 0.001)
		XCTAssertEqual(sut.items.count, 2)
	}

	func test_remove() {
		
		let e1 = expectation(description: "test_remove() e1")
		sut.add([
			section1DummyItems[0],
			section1DummyItems[1],
			section1DummyItems[2],
			section1DummyItems[3],
		], to: dummySection1)
		XCTAssertEqual(sut.items.count, 4, "precondition")
		sut.remove([section1DummyItems[0]], from: dummySection1) {
			e1.fulfill()
		}
		wait(for: [e1], timeout: 0.001)
		XCTAssertEqual(sut.items.count, 3)

		let e2 = expectation(description: "test_remove() e2")
		sut.remove([section1DummyItems[2]], from: dummySection1) {
			e2.fulfill()
		}
		wait(for: [e2], timeout: 0.001)
		XCTAssertEqual(sut.items.count, 2)

		let e3 = expectation(description: "test_remove() e3")
		sut.remove([section1DummyItems[1]], from: dummySection1) {
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
		snapshot2.appendSections([dummySection1])
		
		let snapshot3 = dataSource.snapshot()
		XCTAssertEqual(snapshot3.sectionIdentifiers, [])
		XCTAssertEqual(snapshot3.itemIdentifiers, [])
		snapshot.appendSections([dummySection1])
		snapshot.appendItems([
			section1DummyItems[0],
			section1DummyItems[1],
			section1DummyItems[2],
		]
		)
		dataSource.apply(snapshot)
		
		let snapshot4 = dataSource.snapshot()
		XCTAssertEqual(snapshot4.sectionIdentifiers, [dummySection1])
		XCTAssertEqual(
			snapshot4.itemIdentifiers,
			[
				section1DummyItems[0],
				section1DummyItems[1],
				section1DummyItems[2]
			])
		
		var snapshot5 = dataSource.snapshot()
		snapshot5.appendSections([])
		XCTAssertEqual(snapshot5.sectionIdentifiers, [dummySection1])
		XCTAssertEqual(
			snapshot5.itemIdentifiers,
			[
				section1DummyItems[0],
				section1DummyItems[1],
				section1DummyItems[2]
			])
		
		var snapshot6 = dataSource.snapshot()
		XCTAssertEqual(snapshot6.sectionIdentifiers, [dummySection1])
		XCTAssertEqual(
			snapshot6.itemIdentifiers,
			[
				section1DummyItems[0],
				section1DummyItems[1],
				section1DummyItems[2]
			])
		
		snapshot6.appendSections([])
		snapshot6.appendItems([
			section1DummyItems[3],
			section1DummyItems[4],
			section1DummyItems[5]
		])
		dataSource.apply(snapshot6)
		
		let snapshot7 = dataSource.snapshot()
		XCTAssertEqual(snapshot7.sectionIdentifiers, [dummySection1])
		XCTAssertEqual(
			snapshot7.itemIdentifiers,
			[
				section1DummyItems[0],
				section1DummyItems[1],
				section1DummyItems[2],
				section1DummyItems[3],
				section1DummyItems[4],
				section1DummyItems[5],
			])
	}
	
	func test_itemIdentifier() {
		
		snapshot.appendSections([dummySection1])
		snapshot.appendItems([
			section1DummyItems[0],
			section1DummyItems[1],
			section1DummyItems[2]
		], toSection: dummySection1)
		dataSource.apply(snapshot)
		XCTAssertEqual(dataSource.itemIdentifier(for: IndexPath(item: 0, section: 0)), section1DummyItems[0])
		XCTAssertEqual(dataSource.itemIdentifier(for: IndexPath(item: 1, section: 0)), section1DummyItems[1])
		XCTAssertEqual(dataSource.itemIdentifier(for: IndexPath(item: 2, section: 0)), section1DummyItems[2])
		XCTAssertEqual(dataSource.itemIdentifier(for: IndexPath(item: 100, section: 100)), nil)
	}

	func test_indexPathFor() {
		
		snapshot.appendSections([dummySection1])
		snapshot.appendItems([
			section1DummyItems[0],
			section1DummyItems[1],
			section1DummyItems[2]
		], toSection: dummySection1)
		dataSource.apply(snapshot)
		XCTAssertEqual(dataSource.indexPath(for: section1DummyItems[2]), IndexPath(item: 2, section: 0))
		XCTAssertEqual(dataSource.indexPath(for: section1DummyItems[0]), IndexPath(item: 0, section: 0))
	}

	func test_numberOfSections() {
				
		XCTAssertEqual(dataSource.numberOfSections(in: tableVC.tableView), 0, "precondition")
		snapshot.appendSections([dummySection1])
		snapshot.appendItems([
			section1DummyItems[0],
			section1DummyItems[1],
			section1DummyItems[2]
		], toSection: dummySection1)
		dataSource.apply(snapshot)
		XCTAssertEqual(dataSource.numberOfSections(in: tableVC.tableView), 1)
	}

	func test_numberOfRowsInSection() {
		
		snapshot.appendSections([dummySection1])
		snapshot.appendItems([
			section1DummyItems[0],
			section1DummyItems[1],
			section1DummyItems[2]
		], toSection: dummySection1)
		dataSource.apply(snapshot)
		XCTAssertEqual(dataSource.tableView(tableVC.tableView, numberOfRowsInSection: 0), 3)
	}
	
	func test_cellForRowAt() {

		snapshot.appendSections([dummySection1])
		snapshot.appendItems([
			section1DummyItems[0],
			section1DummyItems[1],
			section1DummyItems[2]
		], toSection: dummySection1)
		dataSource.apply(snapshot)

		let sutCell = tableVC.tableView.dequeueReusableCell(withIdentifier: "FakeUITableViewCell", for: IndexPath(item: 0, section: 0)) as? FakeUITableViewCell
		sutCell?.provide(section1DummyItems[1])
		
		let dataSourceCell = dataSource.tableView(tableVC.tableView, cellForRowAt:  IndexPath(item: 0, section: 0)) as? FakeUITableViewCell
		dataSourceCell?.provide(section1DummyItems[1])
		XCTAssertEqual(
			dataSourceCell?.textLabel?.text,
			sutCell?.textLabel?.text
		)
	}
	
	func test_canMoveRowAt() {
		
		snapshot.appendSections([dummySection1])
		snapshot.appendItems([
			section1DummyItems[0],
			section1DummyItems[1],
			section1DummyItems[2]
		], toSection: dummySection1)
		dataSource.apply(snapshot)
		XCTAssertEqual(
			dataSource.tableView(tableVC.tableView, canMoveRowAt: IndexPath(item: 1, section: 0)),
			false
		)
	}
	
	func test_moveRowAt() throws {
		let sections = DummySection.allSections
		let item = section1DummyItems[0]
		snapshot.appendSections(sections)
		snapshot.appendItems([
			item
		], toSection: sections[0])
		dataSource.apply(snapshot)
		
		let dataSourceCell = try XCTUnwrap(dataSource.tableView(tableVC.tableView, cellForRowAt:  IndexPath(item: 0, section: 0)) as? FakeUITableViewCell)
		
		dataSourceCell.provide(item)
		XCTAssertEqual(dataSource.tableView(tableVC.tableView, numberOfRowsInSection: 0), 1, "precondition")
		XCTAssertEqual(dataSource.tableView(tableVC.tableView, numberOfRowsInSection: 1), 0, "precondition")
		dataSource.tableView(tableVC.tableView, moveRowAt: IndexPath(row: 0, section: 0), to: IndexPath(row: 0, section: 1))
		
//		let moveCell = try XCTUnwrap(dataSource.tableView(tableVC.tableView, cellForRowAt:  IndexPath(item: 0, section: 1)) as? FakeUITableViewCell)
//
//		XCTAssertNotNil(moveCell, "precondition")
		XCTAssertEqual(dataSource.tableView(tableVC.tableView, numberOfRowsInSection: 1), 0)
		XCTAssertEqual(dataSource.tableView(tableVC.tableView, numberOfRowsInSection: 0), 1)
//		XCTAssertEqual(dataSourceCell.textLabel?.text, moveCell.textLabel?.text)
//		
	}
}
#endif
