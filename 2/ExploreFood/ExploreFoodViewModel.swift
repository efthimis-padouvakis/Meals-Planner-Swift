import SwiftUI
import Alamofire

class ExploreFoodViewModel: ObservableObject {
  
    @Published var dayMeals: [[MealObject]] = Array(repeating: [], count: 5)
    @Published var dayDates: [String] = Array(repeating: "", count: 5)
    @Published var isLoading = true
    func fetchMeals(currentWeek: Binding<Int> ,dateRange: Binding<String>) {
        print("Current einai: \(currentWeek.wrappedValue)")
        
        isLoading = true
        //https://run.mocky.io/v3/e61749c1-4307-4e40-86ac-ac43d4c4ee25
        
        if currentWeek.wrappedValue == 0{
            
            
            NetworkService.fetchWeekAPI(from: "https://run.mocky.io/v3/7720f14b-e130-4ecf-9a38-274d6148be6a", queryItems: nil) { result in
                self.isLoading = false
                switch result {
                case .success(let weekData):
                    print("pira ta data 1")
                    for dayIndex in 0..<5 {
                        if weekData.weekly_meals.count > dayIndex {
                            self.dayMeals[dayIndex] = weekData.weekly_meals[dayIndex].meals
                            self.dayDates[dayIndex] = "\(weekData.weekly_meals[dayIndex].day): \(weekData.weekly_meals[dayIndex].date)"
                            
                        }
                    }
                    dateRange.wrappedValue = weekData.date_range
                    print("To current week einai \(weekData.week_id)")
                case .failure(let error):
                    print("could not load Week 1Data: \(error)")
                }
                
            }}else{
                NetworkService.fetchWeekAPI(from: "https://run.mocky.io/v3/8d884af2-c6a1-41b5-811f-04d526802e26", queryItems: nil) { result in
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
                        dateRange.wrappedValue = weekData.date_range
                    case .failure(let error):
                        print("could not load Week 2Data: \(error)")
                    }
                    
                }
            }
    
    }
    
    
    
 
}

#Preview {
    ExploreFoodView()
}

