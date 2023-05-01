//#if os(iOS) || os(tvOS)
//import UIKit
//
//public typealias Section = DiffableSection
//
//public class DiffableTableViewDataSource<SectionType: Section, CellType: UITableViewCell & Providing>: UITableViewDiffableDataSource<SectionType, CellType.Provided> {
//	
//	typealias Section = SectionType
//
//	public override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//		let sectionKind = Section.allSections[section]
//		return sectionKind.title
//	}
//	public override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
//		let sectionKind = Section.allSections[section]
//		return sectionKind.id.uuidString
//	}
//	
//	public override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
//		return true
//	}
//	
//	public override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//		var snapshot = snapshot()
//		guard let sourceIdentifier = itemIdentifier(for: sourceIndexPath) else { return }
//		guard sourceIndexPath != destinationIndexPath else { return }
//		guard let destinationIdentifier = itemIdentifier(for: destinationIndexPath) else {
//			let destinationSectionIdentifier = snapshot.sectionIdentifiers[destinationIndexPath.section]
//			snapshot.deleteItems([sourceIdentifier])
//			snapshot.appendItems([sourceIdentifier], toSection: destinationSectionIdentifier)
//			self.apply(snapshot, animatingDifferences: false)
//			return
//		}
//			if let sourceIndex = snapshot.indexOfItem(sourceIdentifier),
//			   let destinationIndex = snapshot.indexOfItem(destinationIdentifier) {
//				let isAfter = destinationIndex > sourceIndex &&
//				snapshot.sectionIdentifier(containingItem: sourceIdentifier) ==
//				snapshot.sectionIdentifier(containingItem: destinationIdentifier)
//				snapshot.deleteItems([sourceIdentifier])
//				if isAfter {
//					snapshot.insertItems([sourceIdentifier], afterItem: destinationIdentifier)
//				}
//				else {
//					snapshot.insertItems([sourceIdentifier], beforeItem: destinationIdentifier)
//				}
//				self.apply(snapshot, animatingDifferences: false)
//			}
//	}
//
//	public override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//		return true
//	}
//	
//	public override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//		if editingStyle == .delete {
//			if let identifierToDelete = itemIdentifier(for: indexPath) {
//				var snapshot = self.snapshot()
//				snapshot.deleteItems([identifierToDelete])
//				apply(snapshot)
//			}
//		}
//	}
//}
//#endif
