import CoreData

struct QuizViewModel {

    let id: Int
    let title: String
    let description: String
    let category: String
    let level: Int
    let imageUrl: String
    let questions: [Question]

    init(_ quiz: Quiz) {
        self.id = quiz.id
        self.title = quiz.title
        self.description = quiz.description
        self.category = quiz.category
        self.level = quiz.level
        self.imageUrl = quiz.imageUrl

        /*if let storedImageData = quiz.storedImageData {
            self.image = UIImage(data: storedImageData)
        } else {
            self.image = UIImage(named: quiz.image)
        }*/

        self.questions = quiz.questions
    }

}
