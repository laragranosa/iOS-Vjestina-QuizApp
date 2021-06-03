import CoreData

class QuizDatabaseDataSource {

    private let coreDataContext: NSManagedObjectContext

        init(coreDataContext: NSManagedObjectContext) {
            self.coreDataContext = coreDataContext
        }

    func fetchQuizzesFromCoreData(filter: FilterSettings) -> [Quiz] {
        let request: NSFetchRequest<QuizEntity> = QuizEntity.fetchRequest()
        var namePredicate = NSPredicate(value: true)

        if let text = filter.searchText, !text.isEmpty {
            namePredicate = NSPredicate(format: "%K CONTAINS[Entity] %@", #keyPath(QuizEntity.title), text)
            request.predicate = namePredicate
        }
        
        do {
            return try coreDataContext.fetch(request).map { Quiz(with: $0) }
        } catch {
            print("Error when fetching restaurants from core data: \(error)")
            return []
        }
    }

    func saveNewQuizzes(_ quizzes: [Quiz]) {
        do {
            let newIds = quizzes.map { $0.id }
            try deleteAllQuizzesExcept(withId: newIds)
        }
        catch {
            print("Error when deleting restaurants from core data: \(error)")
        }

        quizzes.forEach { quiz in
            do {
                let quizEntity = try fetchQuiz(withId: quiz.id) ?? QuizEntity(context: coreDataContext)
                quiz.populate(quizEntity, in: coreDataContext)
            } catch {
                print("Error when fetching/creating a restaurant: \(error)")
            }
            do {
                try coreDataContext.save()
            } catch {
                print("Error when saving updated restaurant: \(error)")
            }
        }
    }

    func deleteQuiz(withId id: Int) {
        guard let quiz = try? fetchQuiz(withId: id) else { return }
        coreDataContext.delete(quiz)

        do {
            try coreDataContext.save()
        } catch {
            print("Error when saving after deletion of restaurant: \(error)")
        }
    }

    private func fetchQuiz(withId id: Int) throws -> QuizEntity? {
        let request: NSFetchRequest<QuizEntity> = QuizEntity.fetchRequest()
        request.predicate = NSPredicate(format: "%K == %u", #keyPath(QuizEntity.id), id)

        let cdResponse = try coreDataContext.fetch(request)
        return cdResponse.first
    }

    private func deleteAllQuizzesExcept(withId ids: [Int]) throws {
        let request: NSFetchRequest<QuizEntity> = QuizEntity.fetchRequest()
        request.predicate = NSPredicate(format: "NOT %K IN %@", #keyPath(QuizEntity.id), ids)

        let quizzesToDelete = try coreDataContext.fetch(request)
        quizzesToDelete.forEach { coreDataContext.delete($0) }
        try coreDataContext.save()
    }
}
