import CoreData

class QuizRepository {
    
    //private let persistentContainer: NSPersistentContainer
    private let jsonDataSource: QuizNetworkDataSource
    private let coreDataSource: QuizDatabaseDataSource
    
    init(jsonDataSource: QuizNetworkDataSource, coreDataSource: QuizDatabaseDataSource) {
        self.jsonDataSource = jsonDataSource
        self.coreDataSource = coreDataSource
    }

    func fetchRemoteData() throws {
        guard let url = QuizNetworkDataSource.network.baseURL?.appendingPathComponent("quizzes") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        jsonDataSource.getQuizzes(request) { (result: Result<Quizzes, RequestError>) in
        switch result {
        case .success(let value):
            self.coreDataSource.saveNewQuizzes(value.quizzes)
        case .failure( _):
            print("")
        }}
    }

    func fetchLocalData(filter: FilterSettings) -> [Quiz] {
        self.coreDataSource.fetchQuizzesFromCoreData(filter: filter)
    }

    func deleteLocalData(withId id: Int) {
        self.coreDataSource.deleteQuiz(withId: id)
    }
    
}
