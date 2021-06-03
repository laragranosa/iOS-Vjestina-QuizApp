import Foundation

final class QuizzesPresenter {

    private var coordinator: QuizAppProtocol!
    private var quizUseCase: QuizzesUseCase!
    private var quizzesViewModels: [QuizViewModel] = []
    private var sectionNames: [String] = []
    private var currentFilterSettings: FilterSettings

    init(quizUseCase: QuizzesUseCase, coordinator: QuizAppProtocol) {
        self.coordinator = coordinator
        self.quizUseCase = quizUseCase
        self.currentFilterSettings = FilterSettings()
    }

    func refreshQuizzes() throws {
        try quizUseCase.refreshData()
        filterQuizzes(filter: currentFilterSettings)
    }

    func filterQuizzes(filter: FilterSettings) { //-> [QuizViewModel]
        currentFilterSettings = filter
        quizzesViewModels = quizUseCase.getQuizzes(filter: currentFilterSettings).map{ QuizViewModel($0) }
        sectionNames = Set(quizzesViewModels.map { ($0.category) }).sorted()
        //return quizzesViewModels
    }

    func deleteQuiz(at indexPath: IndexPath) {
        guard let id = viewModelForIndexPath(indexPath)?.id else { return }
        quizUseCase.deleteQuiz(withId: id)
        filterQuizzes(filter: currentFilterSettings)
    }

    func numberOfSections() -> Int {
        return sectionNames.count
    }

    func numberOfRows(for section: Int) -> Int {
        return quizzesViewModels
            .filter { $0.category == sectionNames[section] }
            .count
    }

    func viewModelForIndexPath(_ indexPath: IndexPath) -> QuizViewModel? {
        return quizzesViewModels
            .filter { $0.category == sectionNames[indexPath.section] }[indexPath.row]
    }

    func titleForSection(_ section: Int) -> String {
        return sectionNames[section]
    }

}
