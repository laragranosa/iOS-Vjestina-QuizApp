import CoreData

struct Question: Codable {
    
    let id: Int
    let question: String
    let answers: [String]
    let correctAnswer: Int

    enum CodingKeys: String, CodingKey {
        case id
        case question
        case answers
        case correctAnswer = "correct_answer"
    }
}

extension Question {

    init(with entity: QuestionEntity) {
        id = Int(entity.id)
        question = String(entity.question ?? "question not defined")
        answers = entity.answers
        correctAnswer = Int(entity.correctAnswer)
    }
    
    func populate(_ entity: QuestionEntity, in context: NSManagedObjectContext) {
        entity.id = Int16(id)
        entity.question = question
        entity.answers = answers
        entity.correctAnswer = Int16(correctAnswer)
    }
}

