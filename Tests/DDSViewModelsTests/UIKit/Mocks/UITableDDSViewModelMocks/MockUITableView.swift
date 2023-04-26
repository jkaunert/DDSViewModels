#if os(iOS) || os(tvOS)
import XCTest
@testable import DDSViewModels

final class MockUITableView: UITableView {
	var performBatchUpdatesCalledCount = 0
	
	init() {
		super.init(frame: .zero, style: .plain)
		
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
	
	override func insertSections(_ sections: IndexSet, with animation: RowAnimation) {}
	override func insertRows(at indexPaths: [IndexPath], with animation: RowAnimation) {}
}
#endif
