import UIKit
import SnapKit

class QuizResultViewController: UIViewController {
    
    private var coordinator: QuizAppProtocol!
    private var start_time: DispatchTime!
    private var quiz_id: Int!
    private var correctAnswers: Int!
    
    convenience init(coordinator: QuizAppProtocol, time: DispatchTime, quiz_id: Int) {
        self.init()
        self.coordinator = coordinator
        self.start_time = time
        self.quiz_id = quiz_id
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
        self.correctAnswers = coordinator.getResult()
        let numberOfQuestions = coordinator.getNumberOfQuestions()
        self.result.text = "\(Int(self.correctAnswers))/\(numberOfQuestions)"
    }
    
    @objc func finishQuiz(_ sender: UIButton){
        let end_time = DispatchTime.now()
        let quizTime = Double(end_time.uptimeNanoseconds - start_time.uptimeNanoseconds) / 1_000_000_000
        
        guard let url = URL(string: "https://iosquiz.herokuapp.com/api/result") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let token = UserDefaults.standard.string(forKey: "token")
        request.setValue(token, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let user_id = UserDefaults.standard.integer(forKey: "user_id")
        request.httpBody = try! JSONEncoder().encode(QuizResult(time: quizTime, no_of_correct: self.correctAnswers, quiz_id: self.quiz_id, user_id: user_id))

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
