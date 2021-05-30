import Foundation
import UIKit
import SnapKit

class SearchQuizViewController: UIViewController {
    
    private var searchBarView: UIStackView!
    private var searchField: UITextField!
    private var searchButton: UIButton!
    private var collectionView: UICollectionView!
    private var repository: QuizRepository!
    private var coordinator: QuizzAppCoordinator!
    private var presenter: QuizzesPresenter!
    private var data = [Quiz]()

    init(coordinator: QuizzAppCoordinator, presenter: QuizzesPresenter,repository: QuizRepository) {
        super.init(nibName: nil, bundle: nil)
        self.coordinator = coordinator
        self.presenter = presenter
        self.repository = repository
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = customDesign().mycolor
        
        buildStackView()
        buildCollectionView()
        addConstraints()
        
    }

    private func buildCollectionView() {
        let frame = view.frame
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = customDesign().mycolor
            
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: 400, height: 100)
        layout.headerReferenceSize = CGSize(width: 400, height: 50)
        collectionView.register(SelectIconHeaderViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SelectIconHeaderViewCell.reuseId)
        collectionView.register(CustomCell.self, forCellWithReuseIdentifier: "cell")

    }
    
    private func buildStackView() {
        searchField = customDesign().buildTextField(string: "Search")
        searchButton = UIButton(type: .system)
        searchButton.addTarget(self, action: Selector(("buttonPress:")), for: .touchUpInside)
        searchButton = customDesign().styleButton(button: searchButton, title: "Search", width: 100)
        self.searchBarView = UIStackView(arrangedSubviews: [searchField, searchButton])
        searchBarView.axis = .horizontal
        searchBarView.spacing = 3
        searchBarView.backgroundColor = customDesign().mycolor
    }
    
    private func addConstraints(){
        view.addSubview(searchBarView)
        view.addSubview(collectionView)
        
        searchBarView.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(15)
            $0.centerX.equalTo(view.safeAreaLayoutGuide.snp.centerX)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(15)
            
        }
        
        collectionView.snp.makeConstraints{
            $0.top.equalTo(searchBarView).offset(100)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    @objc func buttonPress(_ sender: UIButton) {
        updateSearchResults(for: searchField)
    }
    
    func updateSearchResults(for searchField: UITextField) {
        let filter = FilterSettings(searchText: searchField.text)
        self.data = repository.fetchLocalData(filter: filter)
        presenter.filterQuizzes(filter: filter)
        collectionView.reloadData()
    }
}

extension SearchQuizViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if data.isEmpty {
            return 0
        }
        return presenter.numberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if data.isEmpty {
            return 0
        }
        return presenter.numberOfRows(for: section)
    }
    
    //Cells
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCell
        let viewModel = presenter.viewModelForIndexPath(indexPath)!
        cell.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        cell.clipsToBounds = true
        cell.layer.cornerRadius = 20
        cell.set(viewModel: viewModel)
        return cell
    }
    
    //Section header
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SelectIconHeaderViewCell.reuseId, for: indexPath) as! SelectIconHeaderViewCell
            cell.initializeUI()
            cell.createConstraints()
            cell.setTitle(title: presenter.titleForSection(indexPath.first!))
            return cell
        default:  fatalError("Unexpected element kind")
        }
    }
    
}

extension SearchQuizViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("User tapped on item \(indexPath.row)")
        coordinator.createQuizViewController(data: presenter.viewModelForIndexPath(indexPath)!)
    }
    
}
