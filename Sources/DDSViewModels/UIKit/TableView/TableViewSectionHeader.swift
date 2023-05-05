#if os(iOS) || os(tvOS)
import UIKit

open class TableViewSectionHeader: UITableViewHeaderFooterView {
	static var reuseIdentifier: String {
		return String(describing: TableViewSectionHeader.self)
	}
	
	
}
#endif
