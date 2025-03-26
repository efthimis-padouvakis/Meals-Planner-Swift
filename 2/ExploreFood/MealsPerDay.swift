import SwiftUI

struct MealsPerDayView: View {
    var meals: [MealObject]
    var date: String
    @State private var selectedMealID: Int?
    var body: some View {
        VStack(alignment: .leading) {
            Text(date)
                .font(.headline)
                .padding(.leading)

            ScrollViewReader { scrollViewProxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing : 20) {
                        ForEach(meals, id: \.meal_id) { meal in
                            GeometryReader { geometry in
                                VStack(alignment: .leading, spacing: 10) {
                                    HStack {
                                        Text(meal.title)
                                            .font(.title3)
                                            .bold()
                                        Spacer()
                                       Image(systemName: meal.isLiked ? "heart.fill" : "heart")
                                           .foregroundColor(meal.isLiked ? .red : .gray)
//                                           .onTapGesture {
//                                               //     meal.isLiked.toggle()
//                                               print("hah")
//                                           }
                                    }

                                    Text("launch")
                                        .font(.caption)
                                        .bold()
                                        .padding(.horizontal)
                                        .background(Color(.systemGray2))
                                        .cornerRadius(30)

                                    ScrollView(showsIndicators: true) {
                                        Text(meal.description)
                                            .font(.system(size: 12))
                                    }
                                    .frame(maxHeight: 100)

                                    Text("kcal \(meal.calories)")
                                        .font(.caption)
                                        .bold()

                                    Button(action: {
                                        withAnimation {
                                            if selectedMealID == meal.meal_id {
                                                selectedMealID = nil
                                            } else {
                                                selectedMealID = meal.meal_id
                                            }
                                            if selectedMealID == meal.meal_id {
                                                scrollViewProxy.scrollTo(meal.meal_id, anchor: .center)
                                            }
                                        }
                                    }) {
                                        Text(selectedMealID == meal.meal_id ? "Unsave" : "selectt")
                                            .padding(.horizontal, 60)
                                            .padding(.vertical, 10)
                                            .foregroundColor(.black).bold()
                                            .background(Color(.systemGray3))
                                            .cornerRadius(20)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .center)
                                }
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                                .frame(width: 250, height: 250)
                                .opacity(selectedMealID == nil || selectedMealID == meal.meal_id ? 1 : 0)
                                .scaleEffect(selectedMealID == nil || selectedMealID == meal.meal_id ? 1 : 0)
                                .padding(.trailing, selectedMealID == meal.meal_id ? 40 : 0)
                                .animation(.easeInOut, value: selectedMealID)
                                .id(meal.meal_id)
                            }
                            .frame(width: 250, height: 250)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom)
            }
        }
    }
}

#Preview {
    ExploreFoodView()
}
