import Foundation
import Alamofire

struct JsonWeekAPIResponse: Decodable { 
    let status: String
    let date_range: String
    let week_id: Int
    let previous_week: Int
    
    let next_week: Int
    var weekly_meals: [MealsPerDay]
}

struct MealsPerDay: Decodable {
    let day: String
    let date: String
    var meals: [MealObject]
}



struct MealObject: Decodable, Identifiable, Equatable { // Conform to Identifiable
    let mealId: Int
    var title: String
    let description: String
    let calories: Int
    var isLiked: Bool
    var isSelected: Bool
    var id: Int { mealId } // gia to identifiable

    enum CodingKeys: String, CodingKey {
        case mealId = "meal_id"
        case title
        case description
        case calories
        case isLiked = "is_liked"
        case isSelected = "is_selected"
    }
}

struct NetworkService {
    
    
    func fetchDataWithBearerToken(url: String, bearerToken: String, completion: @escaping (Result<JsonWeekAPIResponse, Error>) -> Void) {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(bearerToken)",
            "Accept": "application/json"
        ]

        AF.request(url, headers: headers).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let decodedResponse = try JSONDecoder().decode(JsonWeekAPIResponse.self, from: data)
                    completion(.success(decodedResponse))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    
    func MealSelect(mealId: Int, date: String, bearerToken: String, completion: @escaping (Result<Data?, Error>) -> Void) {
            let url = "http://localhost:3000/api/v1/user_meal_selections"
            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(bearerToken)",
                "Accept": "application/json",
                "Content-Type": "application/json" //  JSON body
            ]

            let parameters: [String: Any] = [
                "meal_id": mealId,
                "date": date
            ]

            AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseData { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    
    
    
    
    
    
    func MealUnSelect(url: String, bearerToken: String, completion: @escaping (Result<Void, Error>) -> Void) {
           let headers: HTTPHeaders = [
               "Authorization": "Bearer \(bearerToken)",
               "Accept": "application/json"
           ]

           AF.request(url, method: .delete, headers: headers).response { response in
               switch response.result {
               case .success:
                   completion(.success(())) 
               case .failure(let error):
                   completion(.failure(error))
               }
           }
       }
    
    func MealUnLike(mealId: Int, bearerToken: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let url = "http://localhost:3000/api/v1/likes/\(mealId)"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(bearerToken)",
            "Accept": "application/json"
        ]

        AF.request(url, method: .delete, headers: headers).response { response in
            switch response.result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    func MealLike(mealId: Int, bearerToken: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let url = "http://localhost:3000/api/v1/likes"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(bearerToken)",
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]

        let parameters: [String: Any] = [
            "meal_id": mealId
        ]

        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).response { response in
            switch response.result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

}
