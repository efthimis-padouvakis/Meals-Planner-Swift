import SwiftUI

struct MealsPerDayView: View {
    @State var meals: [MealObject]
    var date: String
    @State private var selectedMealID: Int?
    @Binding var likedArray: [Int]
    var body: some View {
        VStack(alignment: .leading) {
            Text(date)
                .font(.headline)
                .padding(.leading)
            
            ScrollViewReader { scrollViewProxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach($meals) { $meal in
                            mealCard(meal: $meal, date: date)
                                .frame(width: 250, height: 250)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom)
                .onChange(of: selectedMealID) { oldValue, newValue in
                    if let newValue = newValue {
                        withAnimation {
                            scrollViewProxy.scrollTo(newValue, anchor: .center)
                        }
                    }
                }
            }
        }
    }
    func mealCard(meal: Binding<MealObject>, date: String) -> some View {
        let networkService = NetworkService()
        
        return VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(meal.wrappedValue.title).font(.title3).bold()
                Spacer()
                
                Button(action: {
                   
                    if likedArray.contains(meal.wrappedValue.mealId) {
                        likedArray.removeAll { $0 == meal.wrappedValue.mealId }     //remove like
                        
                        if let myToken = KeychainManager.loadToken(key: "1") {
                            networkService.MealUnLike(mealId: meal.wrappedValue.mealId, bearerToken: myToken) { result in
                                switch result {
                                case .success:
                                    print("Meal unliked successfully")
                                case .failure(let error):
                                    print("Meal unliking failed: \(error)")
                                }
                            }
                        } else {
                            print("Token not found in keychain.")
                        }
                        
                    } else {
                        likedArray.append(meal.wrappedValue.mealId)//sent like
                        
                        if let myToken = KeychainManager.loadToken(key: "1") {
                            networkService.MealLike(mealId: meal.wrappedValue.mealId, bearerToken: myToken) { result in
                                switch result {
                                case .success:
                                    print("Meal liked successfully")
                                case .failure(let error):
                                    print("Meal liking failed: \(error)")
                                }
                            }
                        } else {
                            print("Token not found in keychain.")
                        }
                        
                    }
                    
                }) {
                    Image(systemName: likedArray.contains(meal.wrappedValue.mealId) ? "heart.fill" : "heart")
                        .foregroundColor(likedArray.contains(meal.wrappedValue.mealId) ? .red : .gray)
                }
            }
            
            Text("launch")
                .font(.caption)
                .bold()
                .padding(4)
                .background(Color(.systemGray2))
                .cornerRadius(20)
            
                .task {
                    if meal.wrappedValue.isSelected == true {
                        selectedMealID = meal.wrappedValue.mealId
                    }
                }
            
            ScrollView(showsIndicators: true) {
                Text(meal.wrappedValue.description).font(.system(size: 12))
            }
            .frame(maxHeight: 100)
            
            Text("kcal \(meal.wrappedValue.calories)").font(.caption).bold()
            
            ScrollViewReader { innerScrollViewProxy in
                Button(action: {
                    print("to id einai \(meal.wrappedValue.mealId)")
                    if meal.wrappedValue.isSelected == false {
                        if let extractedDate = extractDate(from: date) {
                            if let myToken = KeychainManager.loadToken(key: "1") {
                                networkService.MealSelect(mealId: meal.wrappedValue.mealId, date: extractedDate, bearerToken: myToken) { result in
                                    switch result {
                                    case .success(_)://let data
                                        print("Meal selection successful")
                                    case .failure(let error):
                                        print("Meal selection failed: \(error)")
                                    }
                                }
                            } else {
                                print("Token not found in keychain.")
                            }
                        }
                    } else {
                        if let extractedDate = extractDate(from: date) {
                            if let myToken = KeychainManager.loadToken(key: "1") {
                                let deleteURL = "http://localhost:3000/api/v1/user_meal_selections/\(meal.wrappedValue.mealId)/\(extractedDate)"
                                networkService.MealUnSelect(url: deleteURL, bearerToken: myToken) { result in
                                    switch result {
                                    case .success:
                                        print("Meal selection deleted successfully")
                                    case .failure(let error):
                                        print("Meal selection deletion failed: \(error)")
                                    }
                                }
                            } else {
                                print("Token not found in keychain.")
                            }
                        }
                    }
                    meal.wrappedValue.isSelected.toggle()
                    selectedMealID = selectedMealID == meal.wrappedValue.mealId ? nil : meal.wrappedValue.mealId
                }) {
                    Text(selectedMealID == meal.wrappedValue.mealId ? "Unselect" : "Select")
                        .padding(.horizontal, 60)
                        .padding(.vertical, 10)
                        .foregroundColor(.black)
                        .bold()
                        .background(Color(.systemGray3))
                        .cornerRadius(20)
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .opacity(selectedMealID == nil || selectedMealID == meal.wrappedValue.mealId ? 1 : 0)
        .scaleEffect(selectedMealID == nil || selectedMealID == meal.wrappedValue.mealId ? 1 : 0)
        .animation(.easeInOut, value: selectedMealID)
    }
    
    func extractDate(from inputString: String) -> String? {
        let components = inputString.components(separatedBy: ": ")//vazo kai to space
        if components.count == 2 {
            return components[1]
        } else {
            return nil
        }
    }
}
#Preview {
    ExploreFoodView()
}
