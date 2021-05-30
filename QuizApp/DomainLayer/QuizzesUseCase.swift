final class QuizzesUseCase {

    private let quizzesRepository: QuizRepository


    init(quizzesRepository: QuizRepository) {
        self.quizzesRepository = quizzesRepository
    }

    func refreshData() throws {
        try quizzesRepository.fetchRemoteData()
    }

    func getQuizzes(filter: FilterSettings) -> [Quiz] {
        quizzesRepository.fetchLocalData(filter: filter)
    }

    func deleteQuiz(withId id: Int) {
        quizzesRepository.deleteLocalData(withId: id)
    }

}
