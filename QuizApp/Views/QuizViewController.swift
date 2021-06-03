import UIKit
import SnapKit
import CoreData

class QuizViewController: UIViewController {
    private var titleLabel: UILabel!
    private var currentQuestionLabel: UILabel!
    private var questionLabel: UILabel!
    private var buttonsStackView: UIStackView!
    private var progressStatus = 0
    private var progressBarStackView : UIStackView!

    private var currentQuestion: Question!
    private var coordinator: QuizAppProtocol!
    private var quizData: QuizViewModel!
    private var questionIndex = 0
    private var tTime = Timer()
    private var result = 0
    private var startTime = DispatchTime.now()
    
    convenience init(coordinator: QuizAppProtocol, quizData: QuizViewModel) {
        self.init()
        self.coordinator = coordinator
        self.quizData = quizData
    }
    
    private var data =  [Quiz]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.currentQuestion = self.quizData.questions[questionIndex]
        progressBarStackView = UIStackView()
        progressBarStackView.axis = .horizontal
        progressBarStackView.distribution = .fillEqually
        progressBarStackView.spacing = 2.5
        setProgressBars()
        
        buildViews()
        addConstraints()
        
        self.view = view
        
    }
    
    private func buildViews() {
        view.backgroundColor = customDesign().mycolor
        
        titleLabel = UILabel()
        titleLabel.text = "PopQuiz"
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name:"ArialRoundedMTBold", size: 30.0)
        
        currentQuestionLabel = UILabel()
        currentQuestionLabel.text = "\(self.questionIndex+1)/\(self.quizData.questions.count)"
        currentQuestionLabel.backgroundColor = customDesign().mycolor
        currentQuestionLabel.textColor = .white
        currentQuestionLabel.textAlignment = .center
        currentQuestionLabel.font = UIFont(name:"ArialRoundedMTBold", size: 15)
        
        questionLabel = UILabel()
        questionLabel.backgroundColor = customDesign().mycolor
        questionLabel.numberOfLines = 3
        questionLabel.textColor = .white
        questionLabel.font = UIFont(name:"ArialRoundedMTBold", size: 23.0)
        questionLabel.text = self.quizData.questions[self.questionIndex].question
        
        buttonsStackView = UIStackView()
        buttonsStackView.axis = .vertical
        buttonsStackView.distribution = .fillEqually
        buttonsStackView.spacing = 5
        setButtons()
        
        view.addSubview(titleLabel)
        view.addSubview(currentQuestionLabel)
        view.addSubview(progressBarStackView)
        view.addSubview(questionLabel)
        view.addSubview(buttonsStackView)
        
    }
    
    private func addConstraints(){
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(15)
            $0.size.equalTo(CGSize(width: 340, height: 40))
        }
        
        currentQuestionLabel.snp.makeConstraints{
            $0.leading.equalTo(titleLabel)
                .offset(self.questionIndex*(340/self.quizData.questions.count))
            $0.top.equalTo(titleLabel).inset(100)
            $0.size.equalTo(CGSize(width: (340/self.quizData.questions.count), height: 20))
        }
        
        self.progressBarStackView.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalTo(currentQuestionLabel).inset(30)
            $0.size.equalTo(CGSize(width: 340, height: 10))
        }
        
        questionLabel.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalTo(self.progressBarStackView).inset(60)
            $0.size.equalTo(CGSize(width: 340, height: 100))
        }
        
        buttonsStackView.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalTo(questionLabel).inset(150)
            $0.size.equalTo(CGSize(width: 340, height: 350))
        }
        
    }
    
    private func setButtons(){
        let answers = self.currentQuestion.answers
        for i in 0...(answers.count-1) {
            let button = UIButton()
            button.setTitle(String(answers[i]), for: .normal)
            button.titleLabel?.font = UIFont(name:"ArialRoundedMTBold", size: 20.0)
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = UIColor.white.withAlphaComponent(0.6)
            button.clipsToBounds = true
            button.layer.cornerRadius = 20
            button.addTarget(self, action: #selector(self.correctAnswer), for: .touchUpInside)
            buttonsStackView.addArrangedSubview(button)
        }
    }
    
    private func setProgressBars() {
        for _ in 1...self.quizData.questions.count {
            let QuestionTrackerView = UIProgressView(progressViewStyle: .bar)
            QuestionTrackerView.trackTintColor = .white
            QuestionTrackerView.setProgress(0, animated:false)
            QuestionTrackerView.bounds = CGRect(x: 0, y: 0, width: 50, height: 5)
            QuestionTrackerView.clipsToBounds = true
            QuestionTrackerView.layer.cornerRadius = 3
            self.progressBarStackView.addArrangedSubview(QuestionTrackerView)
        }
    }
    
    @objc func correctAnswer(_ sender: UIButton) {
        let answers = self.currentQuestion.answers
        let correctAnswer = self.currentQuestion.correctAnswer
        for button in buttonsStackView.arrangedSubviews {
            button.isUserInteractionEnabled = false }
        if (sender.currentTitle == answers[correctAnswer]) {
            sender.backgroundColor = .green
            self.result+=1
            let currentProgressBar = progressBarStackView.arrangedSubviews[self.questionIndex] as? UIProgressView
            currentProgressBar?.tintColor = .green
            currentProgressBar?.setProgress(1, animated: true)
        } else {
            sender.backgroundColor = .red
            let currentProgressBar = progressBarStackView.arrangedSubviews[self.questionIndex] as? UIProgressView
            currentProgressBar?.tintColor = .red
            currentProgressBar?.setProgress(1, animated: true)
            for button in buttonsStackView.arrangedSubviews {
                if ((button as! UIButton).currentTitle == answers[correctAnswer]){
                    button.backgroundColor = .green
                }
            }
        }
        tTime = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateQuizViewController), userInfo: nil, repeats: false)
    }
    
    @objc func updateQuizViewController(){
        if self.questionIndex == self.quizData.questions.count-1 {
            let endTime = DispatchTime.now()
            let quizTime = Double(endTime.uptimeNanoseconds - self.startTime.uptimeNanoseconds) / 1_000_000_000
            let quizResults = "\(self.result)/\(self.quizData.questions.count)"
            coordinator.setResultViewController(time: quizTime, quizId: self.quizData.id, quizResult: quizResults)
        } else {
            self.questionIndex+=1
            self.currentQuestion = self.quizData.questions[self.questionIndex]
            tTime.invalidate()
            view.subviews.forEach({ $0.removeFromSuperview() })
            buildViews()
            addConstraints()
        }
    }
}
