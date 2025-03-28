import Foundation
import SwiftUI

class ExploreFoodViewModel: ObservableObject {
    @Published var dayMeals: [[MealObject]] = Array(repeating: [], count: 5)
    @Published var dayDates: [String] = Array(repeating: "", count: 5)
    @Published var isLoading = false
    @Published var dateRange = ""
    let networkService = NetworkService()

    func fetchMeals(initialFetch: Bool, weekIamAsking: Binding<Int>, dateRange: Binding<String>) {
        isLoading = true
        let tokenKey = "1"

        if let myToken = KeychainManager.loadToken(key: tokenKey) {
            let urlString = initialFetch ? "http://localhost:3000/api/v1/available_meals" : "http://localhost:3000/api/v1/available_meals?week_id=\(weekIamAsking.wrappedValue)"
            networkService.fetchDataWithBearerToken(url: urlString, bearerToken: myToken) { result in
                DispatchQueue.main.async {
                    self.isLoading = false
                    switch result {
                    case .success(let weekData):
                        weekIamAsking.wrappedValue = weekData.week_id
                        for dayIndex in 0..<5 {
                            if weekData.weekly_meals.count > dayIndex {
                                self.dayMeals[dayIndex] = weekData.weekly_meals[dayIndex].meals
                                self.dayDates[dayIndex] = "\(weekData.weekly_meals[dayIndex].day): \(weekData.weekly_meals[dayIndex].date)"
                            }
                        }
                        dateRange.wrappedValue = weekData.date_range
                    case .failure(let error):
                        print("could not load Week Data: \(error)")
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                print("Token not found in keychain.")
                self.isLoading = false
            }
        }
    }
}
 
#Preview {
    ExploreFoodView()
}
