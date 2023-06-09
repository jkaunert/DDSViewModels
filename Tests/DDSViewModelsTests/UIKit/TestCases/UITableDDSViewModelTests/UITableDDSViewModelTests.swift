#if os(iOS) || os(tvOS)
import XCTest
@testable import DDSViewModels

final class UITableDDSViewModelTests: XCTestCase {
	
	private typealias DiffableDataSource = UITableViewDiffableDataSource<DummySection, DummyItem>
	
	private typealias Snapshot = NSDiffableDataSourceSnapshot<DummySection, DummyItem>
	
	var sections: [DummySection]!
	
	private var dummySection1: DummySection!
	
	private var dummySection2: DummySection!
	
	private var section1DummyItems: [DummyItem]!
	
	private var section2DummyItems: [DummyItem]!
	
	private var tableVC: FakeUITableViewController!
	
	private var dataSource: DiffableDataSource!
	
	private var snapshot: Snapshot!
	
	private var sut: StubUITableViewModel!
	
	override func setUpWithError() throws {
		
		try super.setUpWithError()
		
		section1DummyItems = [
			DummyItem(text: "dummy1"),
			DummyItem(text: "dummy2"),
			DummyItem(text: "dummy3"),
			DummyItem(text: "dummy4"),
			DummyItem(text: "dummy5"),
			DummyItem(text: "dummy6"),
		]
		
		section2DummyItems = [
			DummyItem(text: "dummy7"),
		 DummyItem(text: "dummy8"),
		 DummyItem(text: "dummy9"),
		 DummyItem(text: "dummy10"),
		 DummyItem(text: "dummy11"),
		 DummyItem(text: "dummy12"),
	 ]
		
		sections = DummySection.returnSections()
		
		dummySection1 = sections[0]
		
		dummySection2 = sections[1]

		tableVC = FakeUITableViewController()
		
		sut = tableVC.viewModel
		
		tableVC.loadViewIfNeeded()
		
		dataSource = sut.diffableDataSource
		
		snapshot = Snapshot()
	}
	
	override func tearDownWithError() throws {
		
		section1DummyItems = nil
		section2DummyItems = nil
		dummySection1 = nil
		dummySection2 = nil
		sections = nil
		snapshot = nil
		dataSource = nil
		tableVC = nil
		try super.tearDownWithError()
	}
	
	func test_viewController_tableView_shouldBeSetUp() throws {
			
			XCTAssertNotNil(try XCTUnwrap(tableVC.tableView))
		}
	
	func test_init_viewModelShouldNotBeNil() {
		XCTAssertNotNil(sut)
	}
	
	func test_init_dataSource_shouldBeCorrectKind() throws {
		
		XCTAssertTrue(try XCTUnwrap(dataSource) .isKind(of: UITableViewDiffableDataSource<DummySection, DummyItem>.self))
	}
	
	func test_apply_whenAppendingItemsToMainSection_shouldDiffCorrectly() {
	
		let e1 = expectation(description: "test_apply_whenAppendingItemsToMainSection_shouldDiffCorrectly() e1")
		dataSource.apply(snapshot, completion: e1.fulfill)
		wait(for: [e1], timeout: 0.001)
		snapshot.appendSections([dummySection1])
		snapshot.appendItems([section1DummyItems[0]])
		XCTAssertEqual(snapshot.numberOfItems, 1)

		let e2 = expectation(description: "test_apply_whenAppendingItemsToMainSection_shouldDiffCorrectly() e2")
		dataSource.apply(snapshot, completion: e2.fulfill)
		wait(for: [e2], timeout: 0.001)
		XCTAssertEqual(snapshot.numberOfItems, 1)

		let e3 = expectation(description: "test_apply_whenAppendingItemsToMainSection_shouldDiffCorrectly() e3")
		dataSource.apply(snapshot, completion: e3.fulfill)
		wait(for: [e3], timeout: 0.001)
		snapshot.appendItems([section1DummyItems[1]])
		XCTAssertEqual(snapshot.numberOfItems, 2)

		let e4 = expectation(description: "test_apply_whenAppendingItemsToMainSection_shouldDiffCorrectly() e4")
		dataSource.apply(snapshot, completion: e4.fulfill)
		wait(for: [e4], timeout: 0.001)
		XCTAssertEqual(snapshot.numberOfItems, 2)
	}

	func test_apply_whenRemovingItemsFromMainSection_shouldDiffCorrectly() {
	
		let e1 = expectation(description: "test_apply_whenRemovingItemsFromMainSection_shouldDiffCorrectly() e1")
		dataSource.apply(snapshot, completion: e1.fulfill)
		wait(for: [e1], timeout: 0.001)
		snapshot.appendSections([dummySection1])
		snapshot.appendItems([section1DummyItems[0], section1DummyItems[1]])
		XCTAssertEqual(snapshot.numberOfItems, 2)

		let e2 = expectation(description: "test_apply_whenRemovingItemsFromMainSection_shouldDiffCorrectly() e2")
		dataSource.apply(snapshot, completion: e2.fulfill)
		wait(for: [e2], timeout: 0.001)
		snapshot.deleteItems([section1DummyItems[0]])
		XCTAssertEqual(snapshot.numberOfItems, 1)

		let e3 = expectation(description: "test_apply_whenRemovingItemsFromMainSection_shouldDiffCorrectly() e3")
		dataSource.apply(snapshot, completion: e3.fulfill)
		wait(for: [e3], timeout: 0.001)
		snapshot.appendItems([
			section1DummyItems[1],
			section1DummyItems[2],
			section1DummyItems[3],
		])
		
		snapshot.deleteItems([section1DummyItems[2]])
		
		XCTAssertEqual(snapshot.numberOfItems, 2)

		let e4 = expectation(description: "test_apply_whenRemovingItemsFromMainSection_shouldDiffCorrectly() e4")
		dataSource.apply(snapshot, completion: e4.fulfill)
		wait(for: [e4], timeout: 0.001)
		snapshot.deleteItems([section1DummyItems[3]])
		XCTAssertEqual(snapshot.numberOfItems, 1)
	}

	func test_add_whenAddingOneItemToSection_shouldAppendItemToSectionItems() {
		let e1 = expectation(description: "test_add_whenAddingOneItemToSection_shouldAppendItemToSectionItems() e1")
		
		sut.add([DummyItem(text: "DummyItem")], toSection: &sut.sections[0]) { e1.fulfill() }
		wait(for: [e1], timeout: 0.001)
		XCTAssertEqual(sut.sections[0].items.count, 1)
	}
	
	func test_remove_whenRemovingOneItemFromOneSection_shouldRemoveItemFromSectionItems() {
		
		let dummyItem = DummyItem(text: "DummyItem")
		let e1 = expectation(description: "test_remove_whenRemovingOneItemFromOneSection_shouldRemoveItemFromSectionItems() e1")
		
		sut.add([dummyItem], toSection: &sut.sections[0]) { e1.fulfill() }
		wait(for: [e1], timeout: 0.001)
		XCTAssertEqual(sut.sections[0].items.count, 1, "precondition")
		
		let e2 = expectation(description: "test_remove_whenRemovingOneItemFromOneSection_shouldRemoveItemFromSectionItems() e2")
		sut.remove([dummyItem], fromSection: &sut.sections[0]) {
			e2.fulfill()
		}
		wait(for: [e2], timeout: 0.001)
		XCTAssertEqual(sut.sections[0].items.count, 0)
	}
	
	func test_apply_whenRemovingAllItemsFromMainSection_shouldDiffCorrectly() {
		
		let e1 = expectation(description: "test_apply_whenRemovingAllItemsFromMainSection_shouldDiffCorrectly() e1")
		dataSource.apply(snapshot, completion: e1.fulfill)
		wait(for: [e1], timeout: 0.001)
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

	func test_snapshot_removeAll_shouldRemoveAllItemsFromAllSectionItemArrays() {
		
		let e1 = expectation(description: "test_snapshot_removeAll_shouldRemoveAllItemsFromOwningSectionsItems() e1")
		sut.add(section1DummyItems, toSection: &sut.sections[0])
		sut.add(section2DummyItems, toSection: &sut.sections[1]) { e1.fulfill() }
		wait(for: [e1], timeout: 0.001)
		XCTAssertEqual(section1DummyItems.count, sut.sections[0].items.count, "precondition, section[0] setup")
		XCTAssertEqual(section2DummyItems.count, sut.sections[1].items.count, "precondition, section[1] setup")
		
		let e2 = expectation(description: "test_snapshot_removeAll_shouldRemoveAllItemsFromOwningSectionsItems() e2")
		sut.removeAllItems() {
			e2.fulfill()
		}
		wait(for: [e2], timeout: 0.001)
		XCTAssertEqual(sut.sections[0].items.count, 0)
		XCTAssertEqual(sut.sections[1].items.count, 0)
	}
	
	func test_move_whenMovingItemsFromSection0ToSection1_shouldRemoveItemsFromSection0ItemsAndAddThemToSection1() {
		
		let e1 = expectation(description: "test_move_whenMovingItemsFromSection0ToSection1_shouldRemoveItemsFromSection0ItemsAndAddThemToSection1() e1")
		sut.add([], toSection: &dummySection2)
		sut.add(section1DummyItems, toSection: &dummySection1) { e1.fulfill() }
		wait(for: [e1], timeout: 0.001)
		XCTAssertEqual(dummySection2.items.count, 0, "precondition, section[0] setup")
		XCTAssertEqual(section1DummyItems.count, dummySection1.items.count, "precondition, section[0] setup")
		
		let e2 = expectation(description: "test_move_whenMovingItemsFromSection0ToSection1_shouldRemoveItemsFromSection0ItemsAndAddThemToSection1() e2")
		sut.move(section1DummyItems, fromSection: &dummySection1, toSection: &dummySection2) {
			e2.fulfill()
		}
		wait(for: [e2], timeout: 0.001)
		XCTAssertEqual(dummySection1.items.count, 0)
		XCTAssertEqual(dummySection2.items.count, section1DummyItems.count)
		XCTAssertEqual(dummySection2.items, section1DummyItems)
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
	
	func test_didSelectRowAt() {
		
			snapshot.appendSections([dummySection1])
			snapshot.appendItems([
				section1DummyItems[0],
				section1DummyItems[1],
				section1DummyItems[2]
			], toSection: dummySection1)
			dataSource.apply(snapshot)

			let sutCell = tableVC.tableView.dequeueReusableCell(withIdentifier: "FakeUITableViewCell", for: IndexPath(item: 0, section: 0)) as? FakeUITableViewCell
			sutCell?.provide(section1DummyItems[1])
			
			sut.tableView(tableVC.tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
			
			XCTAssertEqual(sut.didSelectRowAtCalledCount, 1)
		
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
