import XCTest
@testable import DDSViewModels

final class NSDiffableDataSourceSnapshotTests: XCTestCase {
	
	func test_appendSections_snapshotShouldHaveCorrectSections() {
		typealias Test = (initial: [Int], append: [Int], expected: [Int])

		let tests: [Test] = [
			(initial: [0, 1], append: [], expected: [0, 1]),
			(initial: [], append: [0, 1, 2], expected: [0, 1, 2]),
			(initial: [0, 1], append: [2, 3, 4], expected: [0, 1, 2, 3, 4]),
			(initial: [0, 1], append: [4, 3, 2], expected: [0, 1, 4, 3, 2])
		]

		tests.forEach {
			var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
			snapshot.appendSections($0.initial)
			snapshot.appendSections($0.append)
			XCTAssertEqual(snapshot.sectionIdentifiers, $0.expected)
		}
	}

	func test_insertSections_beforeSection_snapshotShouldHaveCorrectSections() {
		typealias Test = (initial: [Int], insert: [Int], before: Int, expected: [Int])

		let tests: [Test] = [
			(initial: [0, 1], insert: [3, 4], before: 1, expected: [0, 3, 4, 1]),
			(initial: [0, 1], insert: [3, 4], before: 0, expected: [3, 4, 0, 1]),
			(initial: [0, 1, 2], insert: [3, 4], before: 2, expected: [0, 1, 3, 4, 2]),
			(initial: [0, 1, 2], insert: [], before: 2, expected: [0, 1, 2])
		]

		tests.forEach {
			var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
			snapshot.appendSections($0.initial)
			snapshot.insertSections($0.insert, beforeSection: $0.before)
			XCTAssertEqual(snapshot.sectionIdentifiers, $0.expected)
		}
	}

	func test_insertSections_afterSection_snapshotShouldHaveCorrectSections() {
		typealias Test = (initial: [Int], insert: [Int], after: Int, expected: [Int])

		let tests: [Test] = [
			(initial: [0, 1], insert: [3, 4], after: 1, expected: [0, 1, 3, 4]),
			(initial: [0, 1], insert: [3, 4], after: 0, expected: [0, 3, 4, 1]),
			(initial: [0, 1, 2], insert: [3, 4], after: 2, expected: [0, 1, 2, 3, 4]),
			(initial: [0, 1, 2], insert: [], after: 2, expected: [0, 1, 2]),
			(initial: [0], insert: [1], after: 0, expected: [0, 1])
		]

		tests.forEach {
			var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
			snapshot.appendSections($0.initial)
			snapshot.insertSections($0.insert, afterSection: $0.after)
			XCTAssertEqual(snapshot.sectionIdentifiers, $0.expected)
		}
	}

	func test_deleteSections_snapshotShouldDeleteCorrectSections() {
		typealias Test = (initial: [Int], delete: [Int], expected: [Int])

		let tests: [Test] = [
			(initial: [0, 1], delete: [1], expected: [0]),
			(initial: [0, 1], delete: [0], expected: [1]),
			(initial: [0, 1, 2], delete: [1], expected: [0, 2]),
			(initial: [0, 1], delete: [1], expected: [0]),
			(initial: [], delete: [1], expected: []),
			(initial: [0, 1], delete: [100], expected: [0, 1])
		]

		tests.forEach {
			var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
			snapshot.appendSections($0.initial)
			snapshot.deleteSections($0.delete)
			XCTAssertEqual(snapshot.sectionIdentifiers, $0.expected)
		}
	}

	func test_moveSection_beforeSection_snapshotShouldHaveCorrectSections() {
		typealias Test = (initial: [Int], move: Int, before: Int, expected: [Int])

		let tests: [Test] = [
			(initial: [0, 1], move: 1, before: 0, expected: [1, 0]),
			(initial: [0, 1, 2], move: 2, before: 0, expected: [2, 0, 1]),
			(initial: [0, 1, 2], move: 0, before: 2, expected: [1, 0, 2]),
			(initial: [0, 1, 2], move: 1, before: 2, expected: [0, 1, 2])
		]

		tests.forEach {
			var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
			snapshot.appendSections($0.initial)
			snapshot.moveSection($0.move, beforeSection: $0.before)
			XCTAssertEqual(snapshot.sectionIdentifiers, $0.expected)
		}
	}

	func test_moveSection_afterSection_snapshotShouldHaveCorrectSections() {
		typealias Test = (initial: [Int], move: Int, after: Int, expected: [Int])

		let tests: [Test] = [
			(initial: [0, 1], move: 0, after: 1, expected: [1, 0]),
			(initial: [0, 1, 2], move: 2, after: 0, expected: [0, 2, 1]),
			(initial: [0, 1, 2], move: 0, after: 2, expected: [1, 2, 0]),
			(initial: [0, 1, 2], move: 1, after: 0, expected: [0, 1, 2])
		]

		tests.forEach {
			var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
			snapshot.appendSections($0.initial)
			snapshot.moveSection($0.move, afterSection: $0.after)
			XCTAssertEqual(snapshot.sectionIdentifiers, $0.expected)
		}
	}

	func test_reloadSections_snapshotShouldHaveCorrectSections() {

		typealias Test = (initial: [Int], reload: [Int], sections: [Int])

		let tests: [Test] = [
			(initial: [], reload: [], sections: []),
			(initial: [0], reload: [1], sections: [0]),
			(initial: [0], reload: [0], sections: [0]),
			(initial: [0, 1, 2], reload: [2], sections: [0, 1, 2]),
			(initial: [2, 1, 0], reload: [0, 1], sections: [3, 2, 1])
		]

		tests.forEach {
			var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
			snapshot.appendSections($0.initial)
			snapshot.reloadSections($0.initial)
			XCTAssertEqual(snapshot.sectionIdentifiers, $0.initial)
			XCTAssertEqual(snapshot.sectionIdentifiers.count, $0.sections.count)
		}
	}

	func test_appendItems_snapshotShouldHaveCorrectItems() {
		typealias Test = (initial: [Int], append: [Int], expected: [Int])

		let tests: [Test] = [
			(initial: [0, 1], append: [2, 3], expected: [0, 1, 2, 3]),
			(initial: [], append: [2, 3], expected: [2, 3]),
			(initial: [1], append: [0], expected: [1, 0])
		]

		tests.forEach {
			var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
			snapshot.appendSections([0, 1])
			snapshot.appendItems($0.initial)
			snapshot.appendItems($0.append)
			XCTAssertEqual(snapshot.itemIdentifiers(inSection: 1), $0.expected)
		}
	}

	func test_appendItems_toSection_snapshotSectionsShouldHaveCorrectItems() {
		typealias Test = (initial: [[Int]], append: [Int], section: Int, expected: [[Int]])

		let tests: [Test] = [
			(initial: [[], [0, 1]], append: [2, 3], section: 1, [[], [0, 1, 2, 3]]),
			(initial: [[], []], append: [2, 3], section: 1, expected: [[], [2, 3]]),
			(initial: [[], [1]], append: [0], section: 1, expected: [[], [1, 0]]),
			(initial: [[], [1]], append: [2], section: 0, expected: [[2], [1]]),
			(initial: [[], [1]], append: [2, 3], section: 0, expected: [[2, 3], [1]]),
			(initial: [[], []], append: [0], section: 0, expected: [[0], []])
		]

		tests.forEach {
			var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
			for (section, items) in $0.initial.enumerated() {
				snapshot.appendSections([section])
				snapshot.appendItems(items)
			}
			snapshot.appendItems($0.append, toSection: $0.section)
			for (section, items) in $0.expected.enumerated() {
				XCTAssertEqual(snapshot.itemIdentifiers(inSection: section), items)
			}
		}
	}

	func test_insertItems_beforeItem_snapshotShouldHaveCorrectItems() {
		typealias Test = (initial: [Int], insert: [Int], before: Int, expected: [Int])

		let tests: [Test] = [
			(initial: [0, 1], insert: [2, 3], before: 1, expected: [0, 2, 3, 1]),
			(initial: [0, 1], insert: [2, 3], before: 0, expected: [2, 3, 0, 1]),
			(initial: [0, 1, 2], insert: [3, 4], before: 1, expected: [0, 3, 4, 1, 2]),
			(initial: [0, 1, 2], insert: [], before: 1, expected: [0, 1, 2]),
			(initial: [0], insert: [1], before: 0, expected: [1, 0])
		]
		
		tests.forEach {
			var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
			snapshot.appendSections([0, 1])
			snapshot.appendItems($0.initial)
			snapshot.insertItems($0.insert, beforeItem: $0.before)

			XCTAssertEqual(snapshot.itemIdentifiers(inSection: 1), $0.expected)
		}
	}

	func test_insertItems_afterItem_snapshotShouldHaveCorrectItems() {
		typealias Test = (initial: [Int], insert: [Int], after: Int, expected: [Int])

		let tests: [Test] = [
			(initial: [0, 1], insert: [2, 3], after: 1, expected: [0, 1, 2, 3]),
			(initial: [0, 1], insert: [2, 3], after: 0, expected: [0, 2, 3, 1]),
			(initial: [0, 1, 2], insert: [3, 4], after: 1, expected: [0, 1, 3, 4, 2]),
			(initial: [0, 1, 2], insert: [], after: 1, expected: [0, 1, 2]),
			(initial: [0], insert: [1], after: 0, expected: [0, 1])
		]

		tests.forEach {
			var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
			snapshot.appendSections([0, 1])
			snapshot.appendItems($0.initial)
			snapshot.insertItems($0.insert, afterItem: $0.after)
			XCTAssertEqual(snapshot.itemIdentifiers(inSection: 1), $0.expected)
		}
	}

	func test_deleteItems_snapshotSectionsShouldDeleteCorrectItems() {
		typealias Test = (initial: [[Int]], delete: [Int], expected: [[Int]])

		let tests: [Test] = [
			(initial: [[], [0, 1]], delete: [0], expected: [[], [1]]),
			(initial: [[0, 1], [2, 3]], delete: [0, 2], expected: [[1], [3]]),
			(initial: [[], []], delete: [100], expected: [[], []]),
			(initial: [[0, 1], [2, 3]], delete: [0, 1], expected: [[], [2, 3]]),
			(initial: [[0, 1], [2, 3]], delete: [0], expected: [[1], [2, 3]]),
			(initial: [[0, 1], [2, 3]], delete: [0, 1, 2, 3], expected: [[], []]),
			(initial: [[0, 1], [2, 3]], delete: [0, 1, 2, 3, 4, 5], expected: [[], []])
		]

		tests.forEach {
			var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
			for (section, items) in $0.initial.enumerated() {
				snapshot.appendSections([section])
				snapshot.appendItems(items, toSection: section)
			}
			snapshot.deleteItems($0.delete)
			for (section, items) in $0.expected.enumerated() {
				XCTAssertEqual(snapshot.itemIdentifiers(inSection: section), items)
			}
		}
	}

	func test_deleteAllItems_snapshotShouldDeleteAllItems() {
		typealias Test = [[Int]]

		let tests: [Test] = [
			([[], [0, 1]]),
			([[0], [1]]),
			([[], []]),
			([[0, 1], [2, 3]]),
			([[0, 1, 2], []]),
			([[], [0, 1, 2]])
		]

		tests.forEach {
			var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
			for (section, items) in $0.enumerated() {
				snapshot.appendSections([section])
				snapshot.appendItems(items, toSection: section)
			}
			snapshot.deleteAllItems()
			XCTAssertEqual(snapshot.itemIdentifiers, [])
		}
	}

	func test_moveItems_beforeItem_snapshotSectionsShouldHaveCorrectItems() {
		typealias Test = (initial: [[Int]], move: Int, before: Int, expected: [[Int]])

		let tests: [Test] = [
			(initial: [[0, 1], [2, 3]], move: 0, before: 2, expected: [[1], [0, 2, 3]]),
			(initial: [[0, 1], [2, 3]], move: 1, before: 0, expected: [[1, 0], [2, 3]]),
			(initial: [[0, 1], [2, 3]], move: 3, before: 0, expected: [[3, 0, 1], [2]]),
			(initial: [[0, 1], [2, 3]], move: 2, before: 3, expected: [[0, 1], [2, 3]]),
			(initial: [[0], [1]], move: 0, before: 1, expected: [[], [0, 1]]),
			(initial: [[0], [1]], move: 1, before: 0, expected: [[1, 0], []]),
			(initial: [[], [0, 1]], move: 1, before: 0, expected: [[], [1, 0]])
		]

		tests.forEach {
			var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
			for (section, items) in $0.initial.enumerated() {
				snapshot.appendSections([section])
				snapshot.appendItems(items, toSection: section)
			}
			snapshot.moveItem($0.move, beforeItem: $0.before)
			for (section, items) in $0.expected.enumerated() {
				XCTAssertEqual(snapshot.itemIdentifiers(inSection: section), items)
			}
		}
	}

	func test_moveItems_afterItem_snapshotSectionsShouldHaveCorrectItems() {
		typealias Test = (initial: [[Int]], move: Int, after: Int, expected: [[Int]])

		let tests: [Test] = [
			(initial: [[0, 1], [2, 3]], move: 0, after: 2, expected: [[1], [2, 0, 3]]),
			(initial: [[0, 1], [2, 3]], move: 1, after: 0, expected: [[0, 1], [2, 3]]),
			(initial: [[0, 1], [2, 3]], move: 3, after: 0, expected: [[0, 3, 1], [2]]),
			(initial: [[0, 1], [2, 3]], move: 2, after: 3, expected: [[0, 1], [3, 2]]),
			(initial: [[0], [1]], move: 0, after: 1, expected: [[], [1, 0]]),
			(initial: [[0], [1]], move: 1, after: 0, expected: [[0, 1], []]),
			(initial: [[], [0, 1]], move: 1, after: 0, expected: [[], [0, 1]])
		]

		tests.forEach {
			var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
			for (section, items) in $0.initial.enumerated() {
				snapshot.appendSections([section])
				snapshot.appendItems(items, toSection: section)
			}
			snapshot.moveItem($0.move, afterItem: $0.after)
			for (section, items) in $0.expected.enumerated() {
				XCTAssertEqual(snapshot.itemIdentifiers(inSection: section), items)
			}
		}
	}

	func test_numberOfSections_snapshotShouldHaveCorrectNumberOfSections() {
		typealias Test = (initial: [Int], expected: Int)

		let tests: [Test] = [
			(initial: [], expected: 0),
			(initial: [0, 1, 2], expected: 3)
		]

		tests.forEach {
			var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
			snapshot.appendSections($0.initial)
			XCTAssertEqual(snapshot.numberOfSections, $0.expected)
		}
	}

	func test_itemIdentifiers_snapshotItemsShouldHaveCorrectIdentifiers() {
		typealias Test = (initial: [[Int]], expected: [Int])

		let tests: [Test] = [
			(initial: [[0, 1], [2, 3]], expected: [0, 1, 2, 3]),
			(initial: [[0, 1], []], expected: [0, 1]),
			(initial: [[], [2, 3]], expected: [2, 3]),
			(initial: [[], []], expected: [])
		]

		tests.forEach {
			var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
			for (section, items) in $0.initial.enumerated() {
				snapshot.appendSections([section])
				snapshot.appendItems(items, toSection: section)
			}
			XCTAssertEqual(snapshot.itemIdentifiers, $0.expected)
		}
	}

	func test_sectionIdentifiers_snapshotSectionsShouldHaveCorrectIdentifiers() {
		typealias Test = (initial: [Int], expected: [Int])

		let tests: [Test] = [
			(initial: [], expected: []),
			(initial: [0, 1], expected: [0, 1])
		]

		tests.forEach {
			var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
			snapshot.appendSections($0.initial)
			XCTAssertEqual(snapshot.sectionIdentifiers, $0.expected)
		}
	}

	func test_numberOfItemsInSection_snapshotShouldHaveCorrectNumberOfSections() {
		typealias Test = (initial: [[Int]], expected: Int)

		let tests: [Test] = [
			(initial: [[0, 1], [2, 3]], expected: 2),
			(initial: [[0, 1], []], expected: 0),
			(initial: [[], [2, 3]], expected: 2),
			(initial: [[], []], expected: 0)
		]

		tests.forEach {
			var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
			for (section, items) in $0.initial.enumerated() {
				snapshot.appendSections([section])
				snapshot.appendItems(items, toSection: section)
			}
			XCTAssertEqual(snapshot.numberOfItems(inSection: 1), $0.expected)
		}
	}

	func test_itemIdentifiersInSection_snapshotShouldHaveCorrectItemIdentifiersInSections() {
		typealias Test = (initial: [[Int]], expected: [Int])

		let tests: [Test] = [
			(initial: [[0, 1], [2, 3]], expected: [2, 3]),
			(initial: [[0, 1], []], expected: []),
			(initial: [[], [2, 3]], expected: [2, 3]),
			(initial: [[], []], expected: [])
		]

		tests.forEach {
			var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
			for (section, items) in $0.initial.enumerated() {
				snapshot.appendSections([section])
				snapshot.appendItems(items, toSection: section)
			}
			XCTAssertEqual(snapshot.itemIdentifiers(inSection: 1), $0.expected)
		}
	}

	func test_sectionIdentifiersContainingItem_snapshotShouldHaveCorrectItemIdentifiersInSections() {
		typealias Test = (initial: [[Int]], item: Int, expected: Int?)

		let tests: [Test] = [
			(initial: [[0, 1], [2, 3]], item: 2, expected: 1),
			(initial: [[0, 1], []], item: 0, expected: 0),
			(initial: [[], [2, 3]], item: 2, expected: 1),
			(initial: [[], []], item: 0, expected: nil),
			(initial: [[0], [1]], item: 2, expected: nil)
		]

		tests.forEach {
			var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
			for (section, items) in $0.initial.enumerated() {
				snapshot.appendSections([section])
				snapshot.appendItems(items, toSection: section)
			}
			XCTAssertEqual(snapshot.sectionIdentifier(containingItem: $0.item), $0.expected)
		}
	}

	func test_sectionIdentifiersContainingDulication_snapshotShouldHaveCorrectItemIdentifiersInSections() {
		typealias Test = (initial: [[Int]], item: Int, expected: Int?)

		let tests: [Test] = [
			(initial: [[0, 1], [1, 2]], item: 2, expected: 1),
			(initial: [[0, 1], [1, 2]], item: 1, expected: 1)
		]

		tests.forEach {
			var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
			for (section, items) in $0.initial.enumerated() {
				snapshot.appendSections([section])
				snapshot.appendItems(items, toSection: section)
			}
			XCTAssertEqual(snapshot.sectionIdentifier(containingItem: $0.item), $0.expected)
		}
	}

	func test_indexOfItem_snapshotShouldHaveCorrectItemIndex() {
		typealias Test = (initial: [[Int]], item: Int, expected: Int?)

		let tests: [Test] = [
			(initial: [[0, 1], [2, 3]], item: 2, expected: 2),
			(initial: [[0, 1], []], item: 0, expected: 0),
			(initial: [[], [2, 3]], item: 2, expected: 0),
			(initial: [[], []], item: 0, expected: nil),
			(initial: [[0], [1]], item: 2, expected: nil)
		]

		tests.forEach {
			var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
			for (section, items) in $0.initial.enumerated() {
				snapshot.appendSections([section])
				snapshot.appendItems(items, toSection: section)
			}
			XCTAssertEqual(snapshot.indexOfItem($0.item), $0.expected)
		}
	}

	func test_indexOfSection_snapshotShouldHaveCorrectSectionIndex() {
		typealias Test = (initial: [Int], section: Int, expected: Int?)

		let tests: [Test] = [
			(initial: [0, 1, 2], section: 1, expected: 1),
			(initial: [0, 1, 2], section: 2, expected: 2),
			(initial: [0, 1, 2], section: 3, expected: nil),
			(initial: [], section: 0, expected: nil)
		]

		tests.forEach {
			var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
			snapshot.appendSections($0.initial)
			XCTAssertEqual(snapshot.indexOfSection($0.section), $0.expected)
		}
	}
}

