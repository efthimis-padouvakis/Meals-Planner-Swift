import SwiftUI

struct ExploreFoodView: View {
    @StateObject var viewModel = ExploreFoodViewModel()
    @State var currentDates = ""
    @State var islikedArray = [Int]()
    @State private var weekIamAsking = 10000000000

    var body: some View {
        VStack {
            HStack {
                Button {
                    weekIamAsking -= 1
                    viewModel.fetchMeals(initialFetch: false, weekIamAsking: $weekIamAsking, dateRange: $currentDates)
                } label: {
                    Image(systemName: "chevron.left.circle")
                        .foregroundColor(.black)
                }
                .disabled(viewModel.isLoading)
                .background(Color(.systemGray3))
                .cornerRadius(30)

                Text(currentDates)
                    .font(.callout)
                    .bold()
                    .padding()
                    .background(Color(.systemGray3))
                    .cornerRadius(30)
                    .overlay(RoundedRectangle(cornerRadius: 30).stroke(Color.black, lineWidth: 1))

                Button {
                    weekIamAsking += 1
                    viewModel.fetchMeals(initialFetch: false, weekIamAsking: $weekIamAsking, dateRange: $currentDates)
                } label: {
                    Image(systemName: "chevron.right.circle")
                        .foregroundColor(.black)
                }
                .disabled(viewModel.isLoading)
                .background(Color(.systemGray3))
                .cornerRadius(30)
            }

            ScrollView {
                VStack {
                    if viewModel.isLoading {
                        ProgressView("Meals...")
                    } else {
                        ForEach(0..<viewModel.dayMeals.count, id: \.self) { index in
                            if !viewModel.dayMeals[index].isEmpty {
                                MealsPerDayView(meals: viewModel.dayMeals[index], date: viewModel.dayDates[index], likedArray: $islikedArray)
                            } else {
                                Text("\(viewModel.dayDates[index]) has no food.")
                                    .frame(width: 400, height: 200)
                                    .background(Color(.systemGray3))
                                    .cornerRadius(20)
                                
                            }
                        }
                    }
                }
            }
        }
        .onChange(of: viewModel.dayMeals) { _, newValue in  //equitable
            islikedArray.removeAll()
            for day in newValue {
                for meal in day {
                    if meal.isLiked && !islikedArray.contains(meal.mealId) {
                        islikedArray.append(meal.mealId)
                    }
                }
            }
            print("likes are on this page: \(islikedArray)")
        }
        .onAppear {
            viewModel.fetchMeals(initialFetch: true, weekIamAsking: $weekIamAsking, dateRange: $currentDates)
        }
    }

}

#Preview {
    ExploreFoodView()
}
