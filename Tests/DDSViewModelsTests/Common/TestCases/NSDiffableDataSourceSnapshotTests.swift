@testable import DDSViewModels
import XCTest

final class NSDiffableDataSourceSnapshotTests: XCTestCase {
	
	func test_appendSections_snapshotShouldHaveCorrectSections() {
		typealias Test = (initial: [Int], append: [Int], expected: [Int])

		let tests: [Test] = [
			([0, 1], [], [0, 1]),
			([], [0, 1, 2], [0, 1, 2]),
			([0, 1], [2, 3, 4], [0, 1, 2, 3, 4]),
			([0, 1], [4, 3, 2], [0, 1, 4, 3, 2])
		]

		for test in tests {
			var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
			snapshot.appendSections(test.initial)
			snapshot.appendSections(test.append)
			XCTAssertEqual(snapshot.sectionIdentifiers, test.expected)
		}
	}

	func test_insertSections_beforeSection_snapshotShouldHaveCorrectSections() {
		typealias Test = (initial: [Int], insert: [Int], before: Int, expected: [Int])

		let tests: [Test] = [
			([0, 1], [3, 4], 1, [0, 3, 4, 1]),
			([0, 1], [3, 4], 0, [3, 4, 0, 1]),
			([0, 1, 2], [3, 4], 2, [0, 1, 3, 4, 2]),
			([0, 1, 2], [], 2, [0, 1, 2])
		]

		for test in tests {
			var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
			snapshot.appendSections(test.initial)
			snapshot.insertSections(test.insert, beforeSection: test.before)
			XCTAssertEqual(snapshot.sectionIdentifiers, test.expected)
		}
	}

	func test_insertSections_afterSection_snapshotShouldHaveCorrectSections() {
		typealias Test = (initial: [Int], insert: [Int], after: Int, expected: [Int])

		let tests: [Test] = [
			([0, 1], [3, 4], 1, [0, 1, 3, 4]),
			([0, 1], [3, 4], 0, [0, 3, 4, 1]),
			([0, 1, 2], [3, 4], 2, [0, 1, 2, 3, 4]),
			([0, 1, 2], [], 2, [0, 1, 2]),
			([0], [1], 0, [0, 1])
		]

		for test in tests {
			var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
			snapshot.appendSections(test.initial)
			snapshot.insertSections(test.insert, afterSection: test.after)
			XCTAssertEqual(snapshot.sectionIdentifiers, test.expected)
		}
	}

	func test_deleteSections_snapshotShouldDeleteCorrectSections() {
		typealias Test = (initial: [Int], delete: [Int], expected: [Int])

		let tests: [Test] = [
			([0, 1], [1], [0]),
			([0, 1], [0], [1]),
			([0, 1, 2], [1], [0, 2]),
			([0, 1], [1], [0]),
			([], [1], []),
			([0, 1], [100], [0, 1])
		]

		for test in tests {
			var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
			snapshot.appendSections(test.initial)
			snapshot.deleteSections(test.delete)
			XCTAssertEqual(snapshot.sectionIdentifiers, test.expected)
		}
	}

	func test_moveSection_beforeSection_snapshotShouldHaveCorrectSections() {
		typealias Test = (initial: [Int], move: Int, before: Int, expected: [Int])

		let tests: [Test] = [
			([0, 1], 1, 0, [1, 0]),
			([0, 1, 2], 2, 0, [2, 0, 1]),
			([0, 1, 2], 0, 2, [1, 0, 2]),
			([0, 1, 2], 1, 2, [0, 1, 2])
		]

		for test in tests {
			var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
			snapshot.appendSections(test.initial)
			snapshot.moveSection(test.move, beforeSection: test.before)
			XCTAssertEqual(snapshot.sectionIdentifiers, test.expected)
		}
	}

	func testmoveSection_afterSection_snapshotShouldHaveCorrectSections() {
		typealias Test = (initial: [Int], move: Int, after: Int, expected: [Int])

		let tests: [Test] = [
			([0, 1], 0, 1, [1, 0]),
			([0, 1, 2], 2, 0, [0, 2, 1]),
			([0, 1, 2], 0, 2, [1, 2, 0]),
			([0, 1, 2], 1, 0, [0, 1, 2])
		]

		for test in tests {
			var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
			snapshot.appendSections(test.initial)
			snapshot.moveSection(test.move, afterSection: test.after)
			XCTAssertEqual(snapshot.sectionIdentifiers, test.expected)
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

		for test in tests {
			var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
			snapshot.appendSections(test.initial)
			snapshot.reloadSections(test.initial)
			
			XCTAssertEqual(snapshot.sectionIdentifiers, test.initial)

			XCTAssertEqual(snapshot.sectionIdentifiers.count, test.sections.count)
		}
	}

	func test_appendItems_snapshotShouldHaveCorrectItems() {
		typealias Test = (initial: [Int], append: [Int], expected: [Int])

		let tests: [Test] = [
			([0, 1], [2, 3], [0, 1, 2, 3]),
			([], [2, 3], [2, 3]),
			([1], [0], [1, 0])
		]

		for test in tests {
			var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
			snapshot.appendSections([0, 1])
			snapshot.appendItems(test.initial)
			snapshot.appendItems(test.append)

			XCTAssertEqual(snapshot.itemIdentifiers(inSection: 1), test.expected)
		}
	}

	func test_appendItems_toSection_snapshotSectionsShouldHaveCorrectItems() {
		typealias Test = (initial: [[Int]], append: [Int], section: Int, expected: [[Int]])

		let tests: [Test] = [
			([[], [0, 1]], [2, 3], 1, [[], [0, 1, 2, 3]]),
			([[], []], [2, 3], 1, [[], [2, 3]]),
			([[], [1]], [0], 1, [[], [1, 0]]),
			([[], [1]], [2], 0, [[2], [1]]),
			([[], [1]], [2, 3], 0, [[2, 3], [1]]),
			([[], []], [0], 0, [[0], []])
		]

		for test in tests {
			var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
			for (section, items) in test.initial.enumerated() {
				snapshot.appendSections([section])
				snapshot.appendItems(items)
			}

			snapshot.appendItems(test.append, toSection: test.section)

			for (section, items) in test.expected.enumerated() {
				XCTAssertEqual(snapshot.itemIdentifiers(inSection: section), items)
			}
		}
	}

	func test_insertItems_beforeItem_snapshotShouldHaveCorrectItems() {
		typealias Test = (initial: [Int], insert: [Int], before: Int, expected: [Int])

		let tests: [Test] = [
			([0, 1], [2, 3], 1, [0, 2, 3, 1]),
			([0, 1], [2, 3], 0, [2, 3, 0, 1]),
			([0, 1, 2], [3, 4], 1, [0, 3, 4, 1, 2]),
			([0, 1, 2], [], 1, [0, 1, 2]),
			([0], [1], 0, [1, 0])
		]

		for test in tests {
			var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
			snapshot.appendSections([0, 1])
			snapshot.appendItems(test.initial)
			snapshot.insertItems(test.insert, beforeItem: test.before)

			XCTAssertEqual(snapshot.itemIdentifiers(inSection: 1), test.expected)
		}
	}

	func test_insertItems_afterItem_snapshotShouldHaveCorrectItems() {
		typealias Test = (initial: [Int], insert: [Int], after: Int, expected: [Int])

		let tests: [Test] = [
			([0, 1], [2, 3], 1, [0, 1, 2, 3]),
			([0, 1], [2, 3], 0, [0, 2, 3, 1]),
			([0, 1, 2], [3, 4], 1, [0, 1, 3, 4, 2]),
			([0, 1, 2], [], 1, [0, 1, 2]),
			([0], [1], 0, [0, 1])
		]

		for test in tests {
			var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
			snapshot.appendSections([0, 1])
			snapshot.appendItems(test.initial)
			snapshot.insertItems(test.insert, afterItem: test.after)

			XCTAssertEqual(snapshot.itemIdentifiers(inSection: 1), test.expected)
		}
	}

	func test_deleteItems_snapshotSectionsShouldDeleteCorrectItems() {
		typealias Test = (initial: [[Int]], delete: [Int], expected: [[Int]])

		let tests: [Test] = [
			([[], [0, 1]], [0], [[], [1]]),
			([[0, 1], [2, 3]], [0, 2], [[1], [3]]),
			([[], []], [100], [[], []]),
			([[0, 1], [2, 3]], [0, 1], [[], [2, 3]]),
			([[0, 1], [2, 3]], [0], [[1], [2, 3]]),
			([[0, 1], [2, 3]], [0, 1, 2, 3], [[], []]),
			([[0, 1], [2, 3]], [0, 1, 2, 3, 4, 5], [[], []])
		]

		for test in tests {
			var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
			for (section, items) in test.initial.enumerated() {
				snapshot.appendSections([section])
				snapshot.appendItems(items, toSection: section)
			}

			snapshot.deleteItems(test.delete)

			for (section, items) in test.expected.enumerated() {
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

		for test in tests {
			var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
			for (section, items) in test.enumerated() {
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
			([[0, 1], [2, 3]], 0, 2, [[1], [0, 2, 3]]),
			([[0, 1], [2, 3]], 1, 0, [[1, 0], [2, 3]]),
			([[0, 1], [2, 3]], 3, 0, [[3, 0, 1], [2]]),
			([[0, 1], [2, 3]], 2, 3, [[0, 1], [2, 3]]),
			([[0], [1]], 0, 1, [[], [0, 1]]),
			([[0], [1]], 1, 0, [[1, 0], []]),
			([[], [0, 1]], 1, 0, [[], [1, 0]])
		]

		for test in tests {
			var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
			for (section, items) in test.initial.enumerated() {
				snapshot.appendSections([section])
				snapshot.appendItems(items, toSection: section)
			}

			snapshot.moveItem(test.move, beforeItem: test.before)

			for (section, items) in test.expected.enumerated() {
				XCTAssertEqual(snapshot.itemIdentifiers(inSection: section), items)
			}
		}
	}

	func test_moveItems_afterItem_snapshotSectionsShouldHaveCorrectItems() {
		typealias Test = (initial: [[Int]], move: Int, after: Int, expected: [[Int]])

		let tests: [Test] = [
			([[0, 1], [2, 3]], 0, 2, [[1], [2, 0, 3]]),
			([[0, 1], [2, 3]], 1, 0, [[0, 1], [2, 3]]),
			([[0, 1], [2, 3]], 3, 0, [[0, 3, 1], [2]]),
			([[0, 1], [2, 3]], 2, 3, [[0, 1], [3, 2]]),
			([[0], [1]], 0, 1, [[], [1, 0]]),
			([[0], [1]], 1, 0, [[0, 1], []]),
			([[], [0, 1]], 1, 0, [[], [0, 1]])
		]

		for test in tests {
			var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
			for (section, items) in test.initial.enumerated() {
				snapshot.appendSections([section])
				snapshot.appendItems(items, toSection: section)
			}

			snapshot.moveItem(test.move, afterItem: test.after)

			for (section, items) in test.expected.enumerated() {
				XCTAssertEqual(snapshot.itemIdentifiers(inSection: section), items)
			}
		}
	}

	func test_numberOfSections_snapshotShouldHaveCorrectNumberOfSections() {
		typealias Test = (initial: [Int], expected: Int)

		let tests: [Test] = [
			([], 0),
			([0, 1, 2], 3)
		]

		for test in tests {
			var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
			snapshot.appendSections(test.initial)

			XCTAssertEqual(snapshot.numberOfSections, test.expected)
		}
	}

	func test_itemIdentifiers_snapshotItemsShouldHaveCorrectIdentifiers() {
		typealias Test = (initial: [[Int]], expected: [Int])

		let tests: [Test] = [
			([[0, 1], [2, 3]], [0, 1, 2, 3]),
			([[0, 1], []], [0, 1]),
			([[], [2, 3]], [2, 3]),
			([[], []], [])
		]

		for test in tests {
			var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
			for (section, items) in test.initial.enumerated() {
				snapshot.appendSections([section])
				snapshot.appendItems(items, toSection: section)
			}

			XCTAssertEqual(snapshot.itemIdentifiers, test.expected)
		}
	}

	func test_sectionIdentifiers_snapshotSectionsShouldHaveCorrectIdentifiers() {
		typealias Test = (initial: [Int], expected: [Int])

		let tests: [Test] = [
			([], []),
			([0, 1], [0, 1])
		]

		for test in tests {
			var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
			snapshot.appendSections(test.initial)

			XCTAssertEqual(snapshot.sectionIdentifiers, test.expected)
		}
	}

	func test_numberOfItemsInSection_snapshotShouldHaveCorrectNumberOfSections() {
		typealias Test = (initial: [[Int]], expectedInRight: Int)

		let tests: [Test] = [
			([[0, 1], [2, 3]], 2),
			([[0, 1], []], 0),
			([[], [2, 3]], 2),
			([[], []], 0)
		]

		for test in tests {
			var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
			for (section, items) in test.initial.enumerated() {
				snapshot.appendSections([section])
				snapshot.appendItems(items, toSection: section)
			}

			XCTAssertEqual(snapshot.numberOfItems(inSection: 1), test.expectedInRight)
		}
	}

	func test_itemIdentifiersInSection_snapshotShouldHaveCorrectItemIdentifiersInSections() {
		typealias Test = (initial: [[Int]], expectedInRight: [Int])

		let tests: [Test] = [
			([[0, 1], [2, 3]], [2, 3]),
			([[0, 1], []], []),
			([[], [2, 3]], [2, 3]),
			([[], []], [])
		]

		for test in tests {
			var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
			for (section, items) in test.initial.enumerated() {
				snapshot.appendSections([section])
				snapshot.appendItems(items, toSection: section)
			}

			XCTAssertEqual(snapshot.itemIdentifiers(inSection: 1), test.expectedInRight)
		}
	}

	func test_sectionIdentifiersContainingItem_snapshotShouldHaveCorrectItemIdentifiersInSections() {
		typealias Test = (initial: [[Int]], item: Int, expected: Int?)

		let tests: [Test] = [
			([[0, 1], [2, 3]], 2, 1),
			([[0, 1], []], 0, 0),
			([[], [2, 3]], 2, 1),
			([[], []], 0, nil),
			([[0], [1]], 2, nil)
		]

		for test in tests {
			var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
			for (section, items) in test.initial.enumerated() {
				snapshot.appendSections([section])
				snapshot.appendItems(items, toSection: section)
			}

			XCTAssertEqual(snapshot.sectionIdentifier(containingItem: test.item), test.expected)
		}
	}

	func test_sectionIdentifiersContainingDulication_snapshotShouldHaveCorrectItemIdentifiersInSections() {
		typealias Test = (initial: [[Int]], item: Int, expected: Int?)

		let tests: [Test] = [
			([[0, 1], [1, 2]], 2, 1),
			([[0, 1], [1, 2]], 1, 1)
		]

		for test in tests {
			var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
			for (section, items) in test.initial.enumerated() {
				snapshot.appendSections([section])
				snapshot.appendItems(items, toSection: section)
			}

			XCTAssertEqual(snapshot.sectionIdentifier(containingItem: test.item), test.expected)
		}
	}

	func test_indexOfItem_snapshotShouldHaveCorrectItemIndex() {
		typealias Test = (initial: [[Int]], item: Int, expectedIndex: Int?)

		let tests: [Test] = [
			([[0, 1], [2, 3]], 2, 2),
			([[0, 1], []], 0, 0),
			([[], [2, 3]], 2, 0),
			([[], []], 0, nil),
			([[0], [1]], 2, nil)
		]

		for test in tests {
			var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
			for (section, items) in test.initial.enumerated() {
				snapshot.appendSections([section])
				snapshot.appendItems(items, toSection: section)
			}

			XCTAssertEqual(snapshot.indexOfItem(test.item), test.expectedIndex)
		}
	}

	func test_indexOfSection_snapshotShouldHaveCorrectSectionIndex() {
		typealias Test = (initial: [Int], section: Int, expectedIndex: Int?)

		let tests: [Test] = [
			([0, 1, 2], 1, 1),
			([0, 1, 2], 2, 2),
			([0, 1, 2], 3, nil),
			([], 0, nil)
		]

		for test in tests {
			var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
			snapshot.appendSections(test.initial)

			XCTAssertEqual(snapshot.indexOfSection(test.section), test.expectedIndex)
		}
	}
}

