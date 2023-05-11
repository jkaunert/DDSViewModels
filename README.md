# DDSViewModels 
[![Platform](https://img.shields.io/badge/Platform-iOS_15-green.svg)]()
[![Platform](https://img.shields.io/badge/Platform-tvOS_15-darkgreen.svg)]()
[![Language](https://img.shields.io/badge/Language-Swift_5.8-orange.svg)]()
[![SPM](https://img.shields.io/badge/SPM-Supported-red.svg)]()
[![License](https://img.shields.io/badge/License-MIT-blue.svg)]()



#### If you like the project, please give it a star ⭐ It will show your appreciation and help others to discover this repo.

---


## About
🪶 Lightweight, reusable, generic NSDiffableDataSource-backed view models for UICollectionView and UITableView, intended to help simplify implementing Diffable Data Sources in Swift/UIKit apps.


- **Lightweight**
    - Two Protocols. Two Classes. Two Reusable Views. One Purpose.
- **Flexible**
    - Use the provided convenience methods, or
    - Easily override default behavior to suit your specific needs.
    - Generic view model classes for both UITableView and UICollectionView eliminate the need for most boilerplate.
    - Protocols for Section and ItemType + take the guesswork out of datasource management.
- **Modern**
    - Uses Swift's `Diffable Data Sources`, `Compositional Layouts`, `Generics` and `Modern Concurrency`
- **Fully Tested**
	- I have tested it thoroughly, so you don’t have to.
  
---

# Usage

### Data Model
Define the data model for `ItemType`. Must conform to `Hashable` protocol.

```swift
import DDSViewModels

public struct DummyItem: Hashable {
	let text: String
	private let creationDate: Date

	public init(text: String) {
		self.text = text
		self.creationDate = Date()
	}
	
	public var formattedDate: String {
		let formatter = DateFormatter()
		formatter.dateStyle = .medium
		formatter.timeStyle = .medium
		return formatter.string(from: creationDate)
	}
}
```

### DiffableSection
Create the model for your apps sections that implements `DiffableSection`.

```swift
import DDSViewModels

struct Section: DiffableSection {
	public var items: [Item]
		
	public var id = UUID()
	public var title: String

	init(title: String, items: [Item] = []) {
		self.title = title
		self.items = items
	}
	
	public func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}
	
	public static func == (lhs: Section, rhs: Section) -> Bool {
		lhs.id == rhs.id
	}
}
```

### Define Sections 
Add sections to your heart’s content in an extension on your custom `Section` object. Make sure to conform to `Hashable`.

```swift
extension Section: Hashable {
	
	public static var allSections: [Section] = [
		Section(title: "Section1"),
		Section(title: "Section2"),
	]
	
	public static func returnSections() -> [Section] {
		return self.allSections
	}
}
```

### Create ItemType/CellType model
```swift
import DDSViewModels

final class TableViewCell: UITableViewCell {
let dateLabel = UILabel()
}
```

### Adopt Providing
Extend your ItemType, implementing `Providing`.

```swift
extension TableViewCell: Providing {
	
	public typealias Provided = Item
	
	public func provide(_ item: Item) {
		self.textLabel?.text = item.text
		self.dateLabel.text = item.formattedDate
	}
}
```
### Create the DDSViewModel

```swift
import DDSViewModels

final class TableViewModel: UITableDDSViewModel<Section, TableViewCell> {
		
	init(tableView: UITableView) {
		super.init(tableView: tableView, cellReuseIdentifier: "TableViewCell")
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let item = diffableDataSource?.itemIdentifier(for: indexPath) else { return }
		
		print(item)
		// DO SOMETHING HERE...
	}
}
```

### Provide ViewModel

```swift
import DDSViewModels

final class TableViewController: UIViewController {
	
	lazy var tableView = UITableView()
	
	private var cancellables = [AnyCancellable]()
	
	lazy var viewModel = TableViewModel(tableView: tableView)
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.addSubview(tableView)
		configureTableView()
	}
	
	private func configureTableView() {
		tableView.dataSource = viewModel.makeDiffableDataSource()
		
	}
}
```

---

# Installation

## Swift Package Manager

### Xcode 13+

1. Open `MenuBar` → `File` → `Swift Packages` → `Add Package Dependency...`
2. Paste the package repository url `https://github.com/jkaunert/DDSViewModels` and hit `Next`.
3. Select the version/target.
4. `import DDSViewModels` where needed.

### Package.swift
If you are building your own package simply add a new dependency:

```swift
dependencies: [
    .package(url: "https://github.com/jkaunert/DDSViewModels", from: "1.0.0")
]
```

---
# Contributing
Your contributions are always appreciated. There are many ways how you help with the project:

- Write additional documentation.
- Implement a new feature.
- Fix a bug.
- Help to maintain by answering to the questions (if any) that other folks have.


Overall guidelies are:

2. Fork the project repository. This creates a copy of the project on your account that you can modify without affecting the original project.
3. Clone the forked repository to your local machine using a Git client like Git or GitHub Desktop.
4. Create and checkout a new branch with a descriptive name (e.g., `new-feature-branch` or `bugfix-issue-123`).
5. Make changes to the project’s codebase.
6. Commit your changes to your local branch with a clear commit message that explains the changes you’ve made. `git commit -m Implemented new feature`.
6. Push your changes to your forked repository on GitHub. `git push origin new-feature-branch`.
7. Create a pull request to the original repository. Open a new pull request to the original project repository. In the pull request, describe the changes you’ve made and why they’re necessary. The project maintainers will review your changes and provide feedback or merge them into the main branch.

---

# Author 
[@jkaunert](https://github.com/jkaunert)


The project is available under MIT Licence
