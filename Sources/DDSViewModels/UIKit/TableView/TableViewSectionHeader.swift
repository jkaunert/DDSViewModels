#if os(iOS) || os(tvOS)
import UIKit

open class TableViewSectionHeader: UITableViewHeaderFooterView {
	
	static var reuseIdentifier: String {
		return String(describing: TableViewSectionHeader.self)
	}
	
	lazy public var titleLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = UIFont.systemFont(
			ofSize: UIFont.preferredFont(forTextStyle: .title1).pointSize,
			weight: .bold)
		label.adjustsFontForContentSizeCategory = true
		label.textColor = .label
		label.textAlignment = .left
		label.numberOfLines = 1
		label.setContentCompressionResistancePriority(
			.defaultHigh, for: .horizontal)
		return label
	}()

	public override init(reuseIdentifier: String?) {
		super.init(reuseIdentifier: Self.reuseIdentifier)
		
		backgroundColor = .systemBackground
		addSubview(titleLabel)
		if UIDevice.current.userInterfaceIdiom == .pad {
			NSLayoutConstraint.activate([
				titleLabel.leadingAnchor.constraint(
					equalTo: leadingAnchor,
					constant: 5),
				titleLabel.trailingAnchor.constraint(
					lessThanOrEqualTo: trailingAnchor,
					constant: -5)])
		} else {
			NSLayoutConstraint.activate([
				titleLabel.leadingAnchor.constraint(
					equalTo: readableContentGuide.leadingAnchor),
				titleLabel.trailingAnchor.constraint(
					lessThanOrEqualTo: readableContentGuide.trailingAnchor)
			])
		}
		NSLayoutConstraint.activate([
			titleLabel.topAnchor.constraint(
				equalTo: topAnchor,
				constant: 10),
			titleLabel.bottomAnchor.constraint(
				equalTo: bottomAnchor,
				constant: -10)
		])
	}
	
	required public init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
#endif
