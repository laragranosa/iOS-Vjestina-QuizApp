import UIKit
import SnapKit

class QuizResultViewController: UIViewController {
    
    private var coordinator: QuizAppProtocol!
    private var quizTime: Double!
    private var quizId: Int!
    private var correctAnswers: Int!
    private var quizResult: String!
    
    convenience init(coordinator: QuizAppProtocol, time: Double, quizId: Int, quizResult: String) {
        self.init()
        self.coordinator = coordinator
        self.quizTime = time
        self.quizId = quizId
        self.quizResult = quizResult
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
        
    }
    
    private func buildViews(){
        view.backgroundColor = .purple
        
        result.text = self.quizResult

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

    @objc func finishQuiz(_ sender: UIButton){
        
        self.correctAnswers = (self.quizResult.split(separator: "/")[0] as NSString).integerValue
        
        guard let url = URL(string: "https://iosquiz.herokuapp.com/api/result") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let token = UserDefaults.standard.string(forKey: "token")
        request.setValue(token, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let userId = UserDefaults.standard.integer(forKey: "user_id")
        request.httpBody = try! JSONEncoder().encode(QuizResult(time: self.quizTime, noOfCorrect: self.correctAnswers, quizId: self.quizId, userId: userId))

        NetworkService().executeUrlRequest(request) { (result: Result<empty, RequestError>) in
            switch result {
            case .failure(let error):
                //handleRequestError(error)
                print(error)
            case .success(let value):
                //print(value)
                print(value)
        }}
        
        coordinator.startTabBarController()
    }
}
