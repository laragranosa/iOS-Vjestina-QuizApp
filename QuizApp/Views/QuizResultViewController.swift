import UIKit
import SnapKit

class QuizResultViewController: UIViewController {
    
    private var coordinator: QuizAppProtocol!
    
    convenience init(coordinator: QuizAppProtocol) {
        self.init()
        self.coordinator = coordinator
    }
    
    private let result: UILabel = {
        let result = UILabel()
        result.textColor = .white
        result.textAlignment = .center
        result.font = UIFont(name:"ArialRoundedMTBold", size: 50)
        return result
    }()
    
    private let finishButton: UIButton = {
        let finishButton = UIButton()
        finishButton.setTitle("Finish quiz", for: .normal)
        finishButton.titleLabel?.font = UIFont(name:"ArialRoundedMTBold", size: 15.0)
        finishButton.setTitleColor(.purple, for: .normal)
        finishButton.backgroundColor = .white
        finishButton.clipsToBounds = true
        finishButton.layer.cornerRadius = 20
        finishButton.addTarget(self, action: Selector(("finishQuiz:")), for: .touchUpInside)
        return finishButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildViews()
        addConstraints()
        
        self.view = view
        updateLabel()
        
        
    }
    
    private func buildViews(){
        view.backgroundColor = .purple

        view.addSubview(finishButton)
        view.addSubview(result)
    }
    
    private func addConstraints(){
        
        result.snp.makeConstraints {
            $0.centerY.equalTo(view.safeAreaLayoutGuide).offset(-100)
            $0.centerX.equalTo(view.safeAreaLayoutGuide)
            $0.size.equalTo(CGSize(width: 340,height: 40))
        }
        
        finishButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.centerX.equalTo(view.safeAreaLayoutGuide)
            $0.size.equalTo(CGSize(width: 340,height: 40))
        }
    }
    
    private func updateLabel() {
        let correctAnswers = coordinator.getResult()
        let numberOfQuestions = coordinator.getNumberOfQuestions()
        self.result.text = "\(correctAnswers)/\(numberOfQuestions)"
    }
    
    @objc func finishQuiz(_ sender: UIButton){
        coordinator.showQuizzesViewController()
    }
}
