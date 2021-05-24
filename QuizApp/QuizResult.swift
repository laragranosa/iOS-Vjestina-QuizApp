struct QuizResult: Codable {
    
    var time: Double
    var noOfCorrect: Int
    var quizId: Int
    var userId: Int
    
    enum CodingKeys: Int, CodingKey {
        case time
        case noOfCorrect
        case quizId
        case userId
    }
    
}
