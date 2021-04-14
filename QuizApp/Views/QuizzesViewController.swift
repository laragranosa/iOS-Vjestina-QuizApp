import UIKit
import SnapKit

class QuizzesViewController: UIViewController  {
    
    private var funFact: UILabel!
    @IBOutlet var dataFetchButton: UIButton!
    private var questCount: UILabel!
    private var quizes: UICollectionView!
    private var titleLabel: UILabel!
    private var headerView: UIStackView!

    private var data = [Quiz]()
    private var sections = [QuizCategory]()
    
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
        dataFetchButton.translatesAutoresizingMaskIntoConstraints = false
        dataFetchButton.widthAnchor.constraint(equalToConstant: 340).isActive = true
        dataFetchButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        dataFetchButton.setTitle("Get Quiz!", for: .normal)
        dataFetchButton.titleLabel?.font = UIFont(name:"ArialRoundedMTBold", size: 15.0)
        dataFetchButton.setTitleColor(.purple, for: .normal)
        dataFetchButton.backgroundColor = .white
        dataFetchButton.clipsToBounds = true
        dataFetchButton.layer.cornerRadius = 20
        
        funFact = UILabel()
        funFact.text = "💡 Fun fact!"
        funFact.textColor = .white
        funFact.font = UIFont(name:"ArialRoundedMTBold", size: 23.0)
        
        questCount = UILabel()
        questCount.textColor = .white
        questCount.numberOfLines = 2
        questCount.text = ""
        questCount.font = UIFont(name:"ArialRoundedMTBold", size: 15.0)
        
        headerView = UIStackView(arrangedSubviews: [titleLabel, dataFetchButton, funFact, questCount])
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
        }
        
        quizes.snp.makeConstraints{
            $0.top.equalTo(headerView).offset(250)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
    }
    
    @objc func fetchQuiz(_ sender: UIButton) {
        self.data = DataService().fetchQuizes()
        self.sections = QuizCategory.allCases
        self.quizes.reloadData()
        self.questCount.text = "There are " + String(self.data.flatMap{$0.questions}.filter{$0.question.contains("NBA")}.count) + " questions that cointain the word 'NBA'"
    }
    
    //MARK: Setup functionn
    func setupCollection() {
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
}

extension QuizzesViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0{
            return data.filter{$0.category == sections[0]}.count
        } else {
            return data.filter{$0.category == sections[1]}.count
        }
    }
    
    //Cells
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCell
        cell.data = self.data[indexPath.item]
        cell.backgroundColor = UIColor.gray.withAlphaComponent(0.7)
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
       print("User tapped on item \(indexPath.row)")
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return QuizCategory.allCases.count
    }
    
}




