#if os(iOS) || os(tvOS)
import UIKit
import Combine
@testable import DDSViewModels

final class FakeUICollectionViewController: UIViewController {
	
	var collectionView = MockUICollectionView()
	
	private var cancellables = [AnyCancellable]()
	
	lazy var viewModel = StubUICollectionViewModel(collectionView: collectionView)
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.addSubview(collectionView)
		configureCollectionView()
	}
	
	private func configureCollectionView() {
		collectionView.dataSource = viewModel.makeDiffableDataSource()
		
		collectionView.register(FakeUICollectionViewCell.self, forCellWithReuseIdentifier: "FakeUICollectionViewCell")
		
		collectionView.delegate = viewModel
		
		if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
			layout.estimatedItemSize = CGSize(width: UIScreen.main.bounds.width * 0.9, height: 100)
		}
	}
}
#endif

