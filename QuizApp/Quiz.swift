import CoreData

struct Quiz: Codable {
    
    let id: Int
    let title: String
    let description: String
    let category: String
    let level: Int
    let imageUrl: String
    let questions: [Question]
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description 
        case category
        case level
        case imageUrl = "image"
        case questions = "questions"
    }
}

extension Quiz {

    init(with entity: QuizEntity) {
        id = Int(entity.id)
        title = String(entity.title ?? "no title")
        description = String(entity.quizDescription ?? "no description")
        category = String(entity.category ?? "no category added")
        level = Int(entity.level)
        imageUrl = entity.imageURL ?? "no image"
        questions = (entity.questions as? Set<QuestionEntity> ?? []).map() { Question(with: $0) }
        
    }
    
    func populate(_ entity: QuizEntity, in context: NSManagedObjectContext) {
        entity.id = Int16(id)
        entity.title = title
        entity.quizDescription = description
        entity.category = category
    	entity.level = Int16(level)
        entity.imageURL = String(imageUrl)
        entity.removeFromQuestions(entity.questions)
        questions.forEach { question in
            let questionEntity = QuestionEntity(context: context)
            question.populate(questionEntity, in: context)
            entity.addToQuestions(questionEntity)
        }
    }
}
