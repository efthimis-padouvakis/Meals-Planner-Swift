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



struct MealObject: Decodable {
    let mealId: Int // Changed from meal_id to mealId
    var title: String
    let description: String
    let calories: Int
    var isLiked: Bool
    var isSelected: Bool

    enum CodingKeys: String, CodingKey {
        case mealId = "meal_id" // Map mealId to "meal_id" in JSON
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

}
