import SwiftUI


struct ExploreFoodView: View {
    @State private var dayMeals: [[Meal]] = Array(repeating: [], count: 5)
    @State private var dayTitles: [String] = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
    @State private var dayDates: [String] = Array(repeating: "", count: 5)

    var body: some View {
        ScrollView {
            VStack {
                Button {
                    Task {
                        do {
                            let weekData = try await generateMockWeekData()
                            for dayIndex in 0..<5 {
                                if weekData.dayMeals.count > dayIndex {
                                    dayMeals[dayIndex] = weekData.dayMeals[dayIndex].Meals
                                    dayDates[dayIndex] = weekData.dayMeals[dayIndex].Date
                                }
                            }
                        } catch {
                            print("could not load Week Data: \(error)")
                        }
                    }
                } label: {
                    Text("boom")
                }

                ForEach(0..<dayMeals.count, id: \.self) { index in
                    if !dayMeals[index].isEmpty {
                        MealsPerDay(meals: dayMeals[index], dayTitle: dayTitles[index], date: dayDates[index]) 
                    } else {
                        Text("den exei masa for \(dayTitles[index]).")
                            .frame(width: 300,height: 100)
                            .background(Color(.systemGray6))
                    }
                }

                Button {
                    if !dayMeals[0].isEmpty {
                        dayMeals[0][0].updateName(newName: "New Meal fdhgfdhgfdhgfName \(Int.random(in: 1...100))")
                    }
                } label: {
                    Text("change")
                }
            }
        }
    }
}


#Preview {
    ExploreFoodView()
}
