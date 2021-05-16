import UIKit
import SystemConfiguration

class NetworkService {
    
    func executeUrlRequest<T : Codable>(_ request: URLRequest, completionHandler: @escaping(Result<T, RequestError>) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, err in

            if !Reachability.isConnectedToNetwork(){
                print("Internet connection not available!")
            }
            
            
            guard err == nil else {
                completionHandler(.failure(.clientError))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,(200...299).contains(httpResponse.statusCode) else {
                completionHandler(.failure(.serverError))
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
