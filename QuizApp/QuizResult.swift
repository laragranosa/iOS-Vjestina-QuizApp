struct QuizResult: Codable {
    
    var time: Double
    var no_of_correct: Int
    var quiz_id: Int
    var user_id: Int
    
    enum CodingKeys: Int, CodingKey {
        case time
        case no_of_correct
        case quiz_id
        case user_id
    }
    
}
