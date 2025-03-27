import SwiftUI

struct MealsPerDayView: View {
    var meals: [MealObject]
    var date: String
    @State private var selectedMealID: Int?
   // @State private var likedMealsArray: [Bool]?
    var body: some View {
        VStack(alignment: .leading) {
            Text(date)
                .font(.headline)
                .padding(.leading)
                       
            ScrollViewReader { scrollViewProxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(meals, id: \.mealId) { meal in
                            mealCard(meal: meal)
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


    
    
    func mealCard(meal: MealObject) -> some View {
        @State var isLiked: Bool? = meal.isLiked

        return VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(meal.title).font(.title3).bold()
                Spacer()
               
                
                Image(systemName: (isLiked ?? false) ? "heart.fill" : "heart")
                    .foregroundColor((isLiked ?? false) ? .red : .gray)
                
                
            }

            Text("launch")
                .font(.caption)
                .bold()
                .padding(4)
                .background(Color(.systemGray2))
                .cornerRadius(20)

            .task {
                if meal.isSelected == true {
                    selectedMealID = meal.mealId
                }
            }

            ScrollView(showsIndicators: true) {
                Text(meal.description).font(.system(size: 12))
            }
            .frame(maxHeight: 100)

            Text("kcal \(meal.calories)").font(.caption).bold()

            ScrollViewReader { innerScrollViewProxy in
                Button(action: {
                  
                    
                    withAnimation {
                        selectedMealID = selectedMealID == meal.mealId ? nil : meal.mealId
                        if selectedMealID == meal.mealId {
                            innerScrollViewProxy.scrollTo(meal.mealId, anchor: .center)
                        }
                    }
                }) {
                    Text(selectedMealID == meal.mealId ? "Unsave" : "Save")
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
        .opacity(selectedMealID == nil || selectedMealID == meal.mealId ? 1 : 0)
        .scaleEffect(selectedMealID == nil || selectedMealID == meal.mealId ? 1 : 0)
        .animation(.easeInOut, value: selectedMealID)
      
    }
}

#Preview {
    ExploreFoodView()
}
