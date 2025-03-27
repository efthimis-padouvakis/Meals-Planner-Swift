import SwiftUI
import Alamofire

class ExploreFoodViewModel: ObservableObject {
    
    @Published var dayMeals: [[MealObject]] = Array(repeating: [], count: 5)
    @Published var dayDates: [String] = Array(repeating: "", count: 5)
    @Published var isLoading = true
    private let networkService = NetworkService() // Create an instance
    
    func fetchMeals(weekIamAsking: Binding<Int> ,dateRange: Binding<String>) {
        isLoading = true
        
        //https://run.mocky.io/v3/8d884af2-c6a1-41b5-811f-04d526802e26
        // https://run.mocky.io/v3/b7740267-87f0-46b9-b2b9-bcc3f8e9d526  //api me selected
        //https://run.mocky.io/v3/c6b41e70-6efd-47dc-a668-4ee655c5b716
  
        
        let myURL = "http://localhost:3000/api/v1/available_meals/"
        let tokenKey = "1"  //kodikos anaktisiss token
        if let myToken = KeychainManager.loadToken(key: tokenKey) {
            //      print("Loaded token: \(myToken)")
            
            
            
            if weekIamAsking.wrappedValue == 10000000000 {
                networkService.fetchDataWithBearerToken(url: myURL, bearerToken: myToken) { result in
                    self.isLoading = false
                    switch result {
                    case .success(let weekData):
                        weekIamAsking.wrappedValue = weekData.week_id
                        print("current week\(weekData.week_id)")
                        print(weekIamAsking.wrappedValue)
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
            }else {
                let myURL = "http://localhost:3000/api/v1/available_meals"
                let newURL = "\(myURL)?week_id=\(weekIamAsking.wrappedValue)"
                let tokenKey = "1"
                
                if let myToken = KeychainManager.loadToken(key: tokenKey) {
                    print("Loaded token: \(myToken)") 
                    print(newURL)
                    networkService.fetchDataWithBearerToken(url: newURL, bearerToken: myToken) { result in
                        self.isLoading = false
                        switch result {
                        case .success(let weekData):
                            weekIamAsking.wrappedValue = weekData.week_id
                            print("current week\(weekData.week_id)")
                            print("Data Received")
                            for dayIndex in 0..<5 {
                                if weekData.weekly_meals.count > dayIndex {
                                    self.dayMeals[dayIndex] = weekData.weekly_meals[dayIndex].meals
                                    self.dayDates[dayIndex] = "\(weekData.weekly_meals[dayIndex].day): \(weekData.weekly_meals[dayIndex].date)"
                                }
                            }
                            dateRange.wrappedValue = weekData.date_range
                        case .failure(let error):
                            print("could not load Week 1Data: \(error)")
                        }
                    }
                } else {
                    print("Token not found in keychain.")
                    isLoading = false;
                }
            }}
        
    }
    
}

#Preview {
    ExploreFoodView()
}
