import SwiftUI

struct MealsPerDay: View {
    var meals: [Meal]
    var dayTitle: String
    var date: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(dayTitle) \(date)")
                .font(.headline)
                .padding(.leading)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(meals) { meal in
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Text(meal.Name)
                                    .font(.title3)
                                    .bold()
                                Spacer()
                                Image(systemName: "heart")
                            }
                            
                            Text("Μεσημεριανό") // logika ola mesimeriana ipothetw? opote mpainei fixed
                                .font(.caption)
                                .foregroundColor(.gray)
                            
                            ScrollView {
                                Text(meal.Desc)
                                    .font(.body)
                            }
                            .frame(maxHeight: 100)
                            
                            Text("kcal \(meal.Kcal)")
                                .font(.caption)
                                .bold()
                            
                            Button(action: {
                                print("Meal selected: \(meal)")
                            }) {
                                Text("selectt")
                                    .padding(.horizontal, 20)
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
                        .frame(width: 250, height: 250) // Fixed width and height for square boxes
                    }
                }
                .padding(.horizontal)
            }
            .padding(.bottom)
        }
    }
}
