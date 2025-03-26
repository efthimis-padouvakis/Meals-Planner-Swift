import Foundation
import Alamofire

struct JsonWeekAPIResponse: Decodable { 
    let status: String
    let week_id: Int
    let date_range: String
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
    let meal_id: Int
    var title: String
    let description: String
    let calories: Int
    var isLiked: Bool
    var isSelected: Bool
}



struct NetworkService {
    static func fetchWeekAPI(from urlString: String, queryItems: [URLQueryItem]?, completion: @escaping (Result<JsonWeekAPIResponse, Error>) -> Void) {
        AF.request(urlString, parameters: queryItems?.reduce(into: [String: String]()) { result, item in
            result[item.name] = item.value
        })
        .validate()
        .responseDecodable(of: JsonWeekAPIResponse.self) { response in
            switch response.result {
            case .success(let weekAPI):
                completion(.success(weekAPI))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
