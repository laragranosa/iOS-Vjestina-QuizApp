import UIKit
import SnapKit

class QuizzesViewController: UIViewController  {
    
    private var funFact: UILabel!
    private var dataFetchButton: UIButton!
    private var questCount: UILabel!
    private var quizes: UICollectionView!
    private var titleLabel: UILabel!
    private var headerView: UIStackView!
    private var questCountView: UIView!
    
    private var selectedQuiz: Quiz!

    //var data: Quizzes?
    var data = [Quiz]()
    var sections = [QuizCategory]()
    
    private var coordinator: QuizAppProtocol!
    
    convenience init(coordinator: QuizAppProtocol) {
        self.init()
        self.coordinator = coordinator
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildViews()
        setupCollection()

        addConstraints()
        
        quizes.dataSource = self
        quizes.delegate = self
        
        self.view = view
    }
    
    private func buildViews(){
        view.backgroundColor = .purple
        
        titleLabel = UILabel()
        titleLabel.text = "PopQuiz"
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        titleLabel.font = UIFont(name:"ArialRoundedMTBold", size: 30.0)
        
        dataFetchButton = UIButton(type: .system)
        dataFetchButton.addTarget(self, action: #selector(self.fetchQuiz), for: .touchUpInside)

        dataFetchButton.setTitle("Get Quiz!", for: .normal)
        dataFetchButton.titleLabel?.font = UIFont(name:"ArialRoundedMTBold", size: 15.0)
        dataFetchButton.setTitleColor(.purple, for: .normal)
        dataFetchButton.backgroundColor = .white
        dataFetchButton.clipsToBounds = true
        dataFetchButton.layer.cornerRadius = 15
        
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
        
        headerView = UIStackView(arrangedSubviews: [titleLabel, dataFetchButton, funFact, questCountView])
        headerView.axis = .vertical
        headerView.spacing = 25
        headerView.backgroundColor = .purple
        
    }
    
    private func addConstraints(){
        
        view.addSubview(headerView)
        view.addSubview(quizes)
        
        headerView.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(15)
            $0.centerX.equalTo(view.safeAreaLayoutGuide.snp.centerX)
            $0.size.equalTo(CGSize(width: 340, height: 200))
            
        }
        
        quizes.snp.makeConstraints{
            $0.top.equalTo(headerView).offset(250)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
    }
    
    @objc func fetchQuiz(_ sender: UIButton) {
        //self.data = DataService().fetchQuizes()
        self.sections = QuizCategory.allCases
        
        DispatchQueue.global(qos: .userInitiated).sync {
            self.fetchRemoteData()
        }
        
        
        
        //print(self.data)
        //let questionFilter = String(self.data.flatMap{$0.questions}.filter{$0.question.contains("NBA")}.count)
        //self.questCount.text = "There are " + questionFilter + " questions that cointain the word 'NBA'"
        self.questCount.lineBreakMode = .byWordWrapping
        self.questCount.numberOfLines = 0
    }
    
    
    private func setupCollection() {
        let frame = view.frame
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        quizes = UICollectionView(frame: frame, collectionViewLayout: layout)
        quizes.delegate = self
        quizes.dataSource = self
        quizes.backgroundColor = UIColor.purple
            
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: 400, height: 100)
        layout.headerReferenceSize = CGSize(width: 400, height: 50)
        
        quizes.register(SelectIconHeaderViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SelectIconHeaderViewCell.reuseId)
        quizes.register(CustomCell.self, forCellWithReuseIdentifier: "cell")

        }
    
    private func fetchRemoteData() {
        guard let url = URL(string: "https://iosquiz.herokuapp.com/api/quizzes") else { return }
        var request = URLRequest(url: url)
        print(url)
        print(request)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        NetworkService().executeUrlRequest(request) { (result: Result<Quizzes, RequestError>) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let value):
                self.data = value.quizzes
                DispatchQueue.main.async {
                    self.quizes.reloadData()
                    self.quizes.collectionViewLayout.invalidateLayout()
                    self.quizes.layoutSubviews()
                }
        }}
    }
    
    func fetchData() -> [Quiz] {
        DispatchQueue.global(qos: .userInitiated).async {
            self.fetchRemoteData()
        }
        return self.data
    }
    
}

extension QuizzesViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return QuizCategory.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0{
            return (self.data.filter{$0.category == sections[0]}.count)
        } else {
            return (self.data.filter{$0.category == sections[1]}.count)
        }
    }
    
    //Cells
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCell
        if indexPath.section == 0{
            cell.data = self.data.filter{$0.category == sections[0]}[indexPath.item]
        } else {
            cell.data = self.data.filter{$0.category == sections[1]}[indexPath.item]
        }
        cell.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        cell.clipsToBounds = true
        cell.layer.cornerRadius = 20
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
                cell.setTitle(title: sections[indexPath.section].rawValue)
            }
            return cell
        default:  fatalError("Unexpected element kind")
        }
    }
}

extension QuizzesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            self.selectedQuiz = self.data.filter{$0.category == sections[0]}[indexPath.item]
        } else {
            self.selectedQuiz = self.data.filter{$0.category == sections[1]}[indexPath.item]
        }
        print("User tapped on item \(indexPath.row)")
        coordinator.createPageViewController(data: self.selectedQuiz)
    }
    
}
