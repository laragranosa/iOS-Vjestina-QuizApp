import UIKit
import SnapKit

class QuizViewController: UIViewController {
    private var titleLabel: UILabel!
    private var currentQuestionLabel: UILabel!
    private var questionLabel: UILabel!
    private var buttonsStackView: UIStackView!
    private var progressStatus = 0
    private var progressBarStackView : UIStackView!

    private var selectedQuiz: IndexPath!
    private var coordinator: QuizAppProtocol!
    private var sections = QuizCategory.allCases
    private var quizData: Quiz!
    private var questionIndex: Int!
    private var tTime = Timer()
    
    convenience init(coordinator: QuizAppProtocol, data: IndexPath, questionIndex: Int) {
        self.init()
        self.coordinator = coordinator
        self.selectedQuiz = data
        self.questionIndex = questionIndex
    }
    
    private let data = DataService().fetchQuizes()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        defineQuizdata()
        getStackView()
        buildViews()
        addConstraints()
        
        self.view = view
        
    }
    
    private func buildViews() {
        view.backgroundColor = .purple
        
        titleLabel = UILabel()
        titleLabel.text = "PopQuiz"
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name:"ArialRoundedMTBold", size: 30.0)
        
        currentQuestionLabel = UILabel()
        currentQuestionLabel.text = "\(self.questionIndex+1)/\(self.quizData.questions.count)"
        currentQuestionLabel.backgroundColor = .purple
        currentQuestionLabel.textColor = .white
        currentQuestionLabel.textAlignment = .center
        currentQuestionLabel.font = UIFont(name:"ArialRoundedMTBold", size: 20)
        
        questionLabel = UILabel()
        questionLabel.backgroundColor = .purple
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
        view.addSubview(self.progressBarStackView)
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
            $0.size.equalTo(CGSize(width: 340, height: 20))
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
    
    private func getStackView(){
        self.progressBarStackView = coordinator.setProgressBarView()
    }

    private func defineQuizdata(){
        if self.selectedQuiz.section == 0{
            self.quizData = self.data.filter{$0.category == sections[0]}[self.selectedQuiz.item]
        } else {
            self.quizData = self.data.filter{$0.category == sections[1]}[self.selectedQuiz.item]
        }
    }
    
    private func setButtons(){
        let numberOfAnswers = 4
        for i in 0...(numberOfAnswers-1) {
            let button = UIButton()
            button.setTitle(String(self.quizData.questions[self.questionIndex].answers[i]), for: .normal)
            button.titleLabel?.font = UIFont(name:"ArialRoundedMTBold", size: 20.0)
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = UIColor.white.withAlphaComponent(0.6)
            button.clipsToBounds = true
            button.layer.cornerRadius = 20
            button.addTarget(self, action: #selector(self.correctAnswer), for: .touchUpInside)
            buttonsStackView.addArrangedSubview(button)
        }
    }
    
    @objc func correctAnswer(_ sender: UIButton) {
        let answers = self.quizData.questions[self.questionIndex].answers
        let correctAnswer = self.quizData.questions[self.questionIndex].correctAnswer
        var currentIndex = 0
        var pageView : QuestionsViewController?
        if let pageViewController = self.parent as? QuestionsViewController {
            pageView = (self.parent as? QuestionsViewController)!
            currentIndex =
                pageViewController.controllers.firstIndex(of: self)! }
        for button in buttonsStackView.arrangedSubviews {
            button.isUserInteractionEnabled = false }
        if (sender.currentTitle == answers[correctAnswer]) {
            sender.backgroundColor = .green
            coordinator.updatequizResult()
            let currentProgressBar = pageView!.progressBarStackView.arrangedSubviews[currentIndex] as? UIProgressView
            currentProgressBar?.tintColor = .green
            currentProgressBar?.setProgress(1, animated: true)
        } else {
            sender.backgroundColor = .red
            let currentProgressBar = pageView!.progressBarStackView.arrangedSubviews[currentIndex] as? UIProgressView
            currentProgressBar?.tintColor = .red
            currentProgressBar?.setProgress(1, animated: true)
            for button in buttonsStackView.arrangedSubviews {
                if ((button as! UIButton).currentTitle == answers[correctAnswer]){
                    button.backgroundColor = .green
                }
            }
        }
        tTime = Timer.scheduledTimer(timeInterval: 3.5, target: self, selector: #selector(changeSlide), userInfo: nil, repeats: true)
        //.setProgress(Float(progressStatus), animated: true)
    }
    
    @objc func changeSlide(){
        tTime.invalidate()
        //coordinator.nextQuestion()
        if let pageViewController = self.parent as? QuestionsViewController {
            if let currentIndex = pageViewController.controllers.firstIndex(of: self) {
                guard (pageViewController.controllers.count - currentIndex) > 1 else {
                    fatalError("Can't navigate to the next view controller!")
            }
                let nextViewController = pageViewController.controllers[currentIndex + 1]
            pageViewController.setViewControllers([nextViewController], direction: .forward, animated: false, completion: nil)
          }
        }
    }
}
