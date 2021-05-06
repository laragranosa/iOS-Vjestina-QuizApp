import UIKit

class QuestionsViewController: UIPageViewController {
    
    private var coordinator: QuizAppProtocol!
    private var selectedQuiz: IndexPath!
    private var sections = QuizCategory.allCases
    private let data = DataService().fetchQuizes()
    private var result = 0
    
    convenience init(coordinator: QuizAppProtocol, indexPath: IndexPath) {
        self.init()
        self.coordinator = coordinator
        self.selectedQuiz = indexPath
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

        //dataSource = self
        setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
    }
    
    private func buildViews(){
        self.progressBarStackView = UIStackView()
        self.progressBarStackView.axis = .horizontal
        self.progressBarStackView.distribution = .fillEqually
        self.progressBarStackView.spacing = 5
        createControllers()
    }
    
    private func createControllers(){
        var numberOfQuestions = 0
        if self.selectedQuiz.section == 0 {
            numberOfQuestions = self.data.filter{$0.category == sections[0]}[self.selectedQuiz.item].questions.count
        } else {
            numberOfQuestions = self.data.filter{$0.category == sections[1]}[self.selectedQuiz.item].questions.count
        }
        for questionIndex in 0...(numberOfQuestions-1) {
            controllers.append(QuizViewController(coordinator: coordinator, data: self.selectedQuiz, questionIndex: questionIndex))
            setProgressBars()
        }
        controllers.append(QuizResultViewController(coordinator: coordinator))
    }
    
    private func setProgressBars() {
        let QuestionTrackerView = UIProgressView(progressViewStyle: .bar)
        QuestionTrackerView.trackTintColor = .white
        QuestionTrackerView.setProgress(0, animated:false)
        QuestionTrackerView.bounds = CGRect(x: 0, y: 0, width: 50, height: 10)
        QuestionTrackerView.clipsToBounds = true
        QuestionTrackerView.layer.cornerRadius = 10
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
