import SwiftUI

struct ExploreFoodView: View {
    @StateObject var viewModel = ExploreFoodViewModel()
    var body: some View {
        
        ScrollView {
            VStack {
                if viewModel.isLoading {
                    ProgressView("Loading Meals...")
                } else {
                    ForEach(0..<viewModel.dayMeals.count, id: \.self) { index in
                        if !viewModel.dayMeals[index].isEmpty {
                            MealsPerDayView(meals: viewModel.dayMeals[index], date: viewModel.dayDates[index])
                        } else {
                            Text("den exei masa for .")
                                .frame(width: 400, height: 200)
                                .background(Color(.systemGray3))
                                .cornerRadius(20)
                        }
                    }
                }
            }
            .onAppear {
                viewModel.fetchMeals()
            }
        }
    }
}

#Preview {
    ExploreFoodView()
}
