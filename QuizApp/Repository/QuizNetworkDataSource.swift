import Foundation
import SystemConfiguration

class QuizNetworkDataSource {
    
    init() {}
    static let network = QuizNetworkDataSource()
    
    let urlSession = URLSession.shared
    var baseURL = URL(string: "https://iosquiz.herokuapp.com/api/")
    
    func getQuizzes<T: Codable>(_ request: URLRequest, completionHandler: @escaping(Result<T, RequestError>) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, err in

            if !Reachability.isConnectedToNetwork(){
                completionHandler(.failure(.networkConnectivity))
            }
            
            
            guard err == nil else {
                completionHandler(.failure(.clientError))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,(200...299).contains(httpResponse.statusCode) else {
                completionHandler(.failure(.serverError))
                ServerStatus.allCases.forEach {
                    if $0.code == (response as? HTTPURLResponse)?.statusCode {
                        print($0)
                    }
                }
                return
            }
            
            guard let data = data else {
                completionHandler(.failure(.noData))
                return
            }
            guard let value = try? JSONDecoder().decode(T.self, from: data) else {
                completionHandler(.failure(.dataDecodingError))
                return
            }
            completionHandler(.success(value))
            }
            dataTask.resume()
    }
}
