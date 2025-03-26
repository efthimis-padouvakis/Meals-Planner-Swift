import SwiftUI

struct ExploreFoodView: View {
    @StateObject var viewModel = ExploreFoodViewModel()
    @State var weekStepper = 0
    @State var currentDates = ""
    var body: some View {
        
        HStack {
            Button {
                weekStepper -= 1
                viewModel.fetchMeals(currentWeek: $weekStepper, dateRange: $currentDates)
                print(weekStepper)
            } label: {
                Image(systemName: "chevron.left.circle")
                    .foregroundColor(.black)
            }.disabled(viewModel.isLoading)
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
                weekStepper += 1
                viewModel.fetchMeals(currentWeek: $weekStepper, dateRange: $currentDates)
            } label: {
                Image(systemName: "chevron.right.circle")
                    .foregroundColor(.black)
            }.disabled(viewModel.isLoading)
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
                viewModel.fetchMeals(currentWeek: $weekStepper, dateRange: $currentDates)
            }
        }
    }
}

#Preview {
    ExploreFoodView()
}
