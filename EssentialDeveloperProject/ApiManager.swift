import Foundation
class ApiManager {
    
    static let shared = ApiManager()
    
    private init() {}
        
    func getUsers(completion: @escaping (Result<[User],Error>) -> Void ) {
        
        // 1.URL
        let urlString = "https://jsonplaceholder.typicode.com/users"
        let url = URL(string: urlString)!
        
        //2.session
        URLSession.shared.dataTask (with: url) { data, response, error in
            
            if let error = error {
                completion(.failure(error))
            }
            
            guard let data = data else {
                return
            }
            
            do {
                
                let users = try JSONDecoder().decode([User].self, from: data)
                completion(.success(users))
            }
            
            catch(let error) {
                completion(.failure(error))
            }
        }.resume()
    }
}
