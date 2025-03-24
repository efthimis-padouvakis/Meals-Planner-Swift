import Foundation

struct Meal: Decodable, Identifiable {
    let id = UUID()
    var Name: String
    let Desc: String
    let Kcal: Int
    var Favourite: Bool?
    var Selected: Bool?

    enum CodingKeys: String, CodingKey {
        case Name
        case Desc
        case Kcal
        case Favourite
        case Selected
    }

    mutating func updateName(newName: String) {
        self.Name = newName
    }
}

struct DayMeal: Decodable {
    let Date: String
    let Meals: [Meal]

    enum CodingKeys: String, CodingKey {
        case Date
        case Meals
    }
}

struct WeekAPI: Decodable, Identifiable {
    var id: String? = UUID().uuidString
    let WeekId: Int
    let DateRange: String
    let dayMeals: [DayMeal]

    enum CodingKeys: String, CodingKey {
        case id
        case WeekId = "Week_id"
        case DateRange = "Date_range"
        case dayMeals
    }

    init(WeekId: Int, DateRange: String, dayMeals: [DayMeal]) {
        self.WeekId = WeekId
        self.DateRange = DateRange
        self.dayMeals = dayMeals
    }
}

func generateMockMealsForDay(dayOffset: Int) async throws -> [Meal] {
    try await Task.sleep(nanoseconds: 500_000)

    let meals: [[Meal]] = [
        [
            Meal(Name: "Chicken a la cream", Desc: "Creamhgfjhgfjgffbggffdghhdfgfdhgdfghhdfgfdghhdfghdfg dhfgdcvhgfcdhgfd fgd hfgd hfgd hfgdchvgfdcvhgfdvhgfdvhgfdhvfhgfhgfy chhgfjhgfjickengfjhgfghffhgfhgfj", Kcal: 450, Favourite: true, Selected: true),
            Meal(Name: "Simple Salad", Desc: "Lettuce, tomato", Kcal: 150, Favourite: true, Selected: true),
            Meal(Name: "Chocolate cake", Desc: "Dessert", Kcal: 300, Favourite: true, Selected: false)
        ],
        [
            Meal(Name: "Spaghetti", Desc: "Pasta", Kcal: 500, Favourite: true, Selected: true),
            Meal(Name: "Apple", Desc: "Fruit", Kcal: 100, Favourite: false, Selected: false)
        ],
        [], // Wednesday is empty
        [
            Meal(Name: "Bean soup", Desc: "Soup", Kcal: 400, Favourite: true, Selected: true),
            Meal(Name: "Bread", Desc: "Side", Kcal: 150, Favourite: false, Selected: false)
        ],
        [
            Meal(Name: "Pizza", Desc: "Italian", Kcal: 600, Favourite: true, Selected: true)
        ]
    ]

    return meals[dayOffset]
}
func generateMockWeekData() async throws -> WeekAPI {
    let startDate = Date()
    let calendar = Calendar.current
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"

    var dayMeals: [DayMeal] = []
    for dayOffset in 0..<5 { // Weekdays (Monday to Friday)
        if let date = calendar.date(byAdding: .day, value: dayOffset, to: startDate) {
            let dateString = dateFormatter.string(from: date)
            let meals = try await generateMockMealsForDay(dayOffset: dayOffset)
            dayMeals.append(DayMeal(Date: dateString, Meals: meals))
        }
    }

    let endDate = calendar.date(byAdding: .day, value: 4, to: startDate)!
    let dateRange = "\(dateFormatter.string(from: startDate)) to \(dateFormatter.string(from: endDate))"

    return WeekAPI(WeekId: 1, DateRange: dateRange, dayMeals: dayMeals)
}
