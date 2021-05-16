import UIKit

class QuestionsViewController: UIPageViewController {
    
    private var coordinator: QuizAppProtocol!
    private var selectedQuiz: IndexPath!
    private var sections = QuizCategory.allCases
    private var data : Quiz!
    private var result = 0
    private var start_time : DispatchTime!
    
    convenience init(coordinator: QuizAppProtocol, data: Quiz) {
        self.init()
        self.coordinator = coordinator
        self.data = data
    }
    
    
    var controllers =  [UIViewController]()
    var progressBarStackView: UIStackView!

    private var displayedIndex = 0
    private var numberOfQuestions = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        buildViews()

        view.backgroundColor = .white
        self.numberOfQuestions = self.controllers.count - 1

        guard let firstVC = controllers.first else { return }

        setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
    }
    
    private func buildViews(){
        self.progressBarStackView = UIStackView()
        self.progressBarStackView.axis = .horizontal
        self.progressBarStackView.distribution = .fillEqually
        self.progressBarStackView.spacing = 2.5
        createControllers()
    }
    
    private func createControllers(){
        self.start_time = DispatchTime.now()
        let numberOfQuestions = self.data.questions.count
        for questionIndex in 0...(numberOfQuestions-1) {
            let questionData = self.data.questions[questionIndex]
            controllers.append(QuizViewController(coordinator: coordinator, questionData: questionData, quizData: self.data))
            setProgressBars()
        }
        controllers.append(QuizResultViewController(coordinator: coordinator, time: start_time, quiz_id: self.data.id))
    }
    
    private func setProgressBars() {
        let QuestionTrackerView = UIProgressView(progressViewStyle: .bar)
        QuestionTrackerView.trackTintColor = .white
        QuestionTrackerView.setProgress(0, animated:false)
        QuestionTrackerView.bounds = CGRect(x: 0, y: 0, width: 50, height: 10)
        QuestionTrackerView.clipsToBounds = true
        QuestionTrackerView.layer.cornerRadius = 20
        self.progressBarStackView.addArrangedSubview(QuestionTrackerView)
    }
    
    func updateResult(){
        self.result+=1
    }
    
    func getResult() -> Int {
        return self.result
    }
    
    func getNumberOfQuestions() -> Int {
        return self.numberOfQuestions
    }
    
    func getStackView() -> UIStackView {
        return self.progressBarStackView
    }
}
