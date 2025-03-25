import SwiftUI
import Alamofire

class ExploreFoodViewModel: ObservableObject {
    @Published var dayMeals: [[MealObject]] = Array(repeating: [], count: 5)
    @Published var dayDates: [String] = Array(repeating: "", count: 5)
    @Published var isLoading = true
    func fetchMeals() {
        isLoading = true
                                                            //https://run.mocky.io/v3/e61749c1-4307-4e40-86ac-ac43d4c4ee25
        NetworkService.fetchWeekAPI(from: "https://run.mocky.io/v3/4969b2e6-6e15-4c89-836e-bc63103e2ad7", queryItems: nil) { result in
                self.isLoading = false
                switch result {
                case .success(let weekData):
                    print("pira ta data")
                    for dayIndex in 0..<5 {
                        if weekData.weekly_meals.count > dayIndex {
                            self.dayMeals[dayIndex] = weekData.weekly_meals[dayIndex].meals
                            self.dayDates[dayIndex] = "\(weekData.weekly_meals[dayIndex].day): \(weekData.weekly_meals[dayIndex].date)"
                        }
                    }
                case .failure(let error):
                    print("could not load Week Data: \(error)")
                }
            
        }
    }
    
    
    
 
}
