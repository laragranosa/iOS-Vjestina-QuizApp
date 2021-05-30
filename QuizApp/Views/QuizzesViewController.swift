import UIKit
import SnapKit
import CoreData

class QuizzesViewController: UIViewController  {
    
    private var funFact: UILabel!
    private var questCount: UILabel!
    private var quizzes: UICollectionView!
    private var titleLabel: UILabel!
    private var headerView: UIStackView!
    private var questCountView: UIView!
    private var selectedQuiz: Quiz!
    
    var data : [Quiz] = []
    var sections = QuizCategory.allCases
    
    private var coordinator: QuizAppProtocol!
    private var presenter: QuizzesPresenter!
    private var repository: QuizRepository!
    
    init(coordinator: QuizAppProtocol, presenter: QuizzesPresenter, quizRepository: QuizRepository) {
        super.init(nibName: nil, bundle: nil)
        self.presenter = presenter
        self.coordinator = coordinator
        self.repository = quizRepository
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildViews()
        setupCollection()

        addConstraints()
        getQuizzes()
        
        quizzes.dataSource = self
        quizzes.delegate = self
        
        self.view = view
    }
    
    private func buildViews(){
        view.backgroundColor = customDesign().mycolor
        
        titleLabel = UILabel()
        titleLabel.text = "PopQuiz"
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        titleLabel.font = UIFont(name:"ArialRoundedMTBold", size: 30.0)
        
        funFact = UILabel()
        funFact.text = "💡 Fun fact!"
        funFact.textColor = .white
        funFact.font = UIFont(name:"ArialRoundedMTBold", size: 23.0)
        
        questCountView = UIView()
        questCount = UILabel()
        questCount.textColor = .white
        questCount.numberOfLines = 0
        questCount.font = UIFont(name:"ArialRoundedMTBold", size: 15.0)
        questCount.frame = CGRect(x: 0, y: 0, width: 340, height: 50)
        questCountView.addSubview(questCount)
        
        headerView = UIStackView(arrangedSubviews: [titleLabel, funFact, questCountView])
        headerView.axis = .vertical
        headerView.spacing = 25
        headerView.backgroundColor = customDesign().mycolor
        
    }
    
    private func addConstraints(){
        
        view.addSubview(headerView)
        view.addSubview(quizzes)
        
        headerView.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(15)
            $0.centerX.equalTo(view.safeAreaLayoutGuide.snp.centerX)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
            
        }
        
        quizzes.snp.makeConstraints{
            $0.top.equalTo(headerView).offset(200)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
    }
    
    func getQuizzes() {
        try? presenter.refreshQuizzes()
        data = repository.fetchLocalData(filter: FilterSettings())
        DispatchQueue.main.async {
            self.quizzes.reloadData()
            self.quizzes.collectionViewLayout.invalidateLayout()
            self.quizzes.layoutSubviews()
            let questionFilter = String(self.data.flatMap{$0.questions}.filter{$0.question.contains("NBA")}.count)
            self.questCount.text = "There are " + questionFilter + " questions that cointain the word 'NBA'"
            self.questCount.lineBreakMode = .byWordWrapping
            self.questCount.numberOfLines = 0
        }
    }
    
    
    private func setupCollection() {
        let frame = view.frame
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        quizzes = UICollectionView(frame: frame, collectionViewLayout: layout)
        quizzes.delegate = self
        quizzes.dataSource = self
        quizzes.backgroundColor = customDesign().mycolor
            
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: 400, height: 100)
        layout.headerReferenceSize = CGSize(width: 400, height: 50)
        
        quizzes.register(SelectIconHeaderViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SelectIconHeaderViewCell.reuseId)
        quizzes.register(CustomCell.self, forCellWithReuseIdentifier: "cell")

        }
    
}

extension QuizzesViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return presenter.numberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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
            if (!sections.isEmpty){
                cell.setTitle(title: presenter.titleForSection(indexPath.first!))
            }
            return cell
        default:  fatalError("Unexpected element kind")
        }
    }
}

extension QuizzesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("User tapped on item \(indexPath.row)")
        coordinator.createQuizViewController(data: presenter.viewModelForIndexPath(indexPath)!)
    }
    
}
