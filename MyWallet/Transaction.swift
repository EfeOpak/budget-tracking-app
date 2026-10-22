
import Foundation
import SwiftData

@Model
final class Transaction {
    var title: String
    var amount: Double
    var category: String
    var date: Date
    var isIncome: Bool

    init(
        title: String,
        amount: Double,
        category: String,
        date: Date = .now,
        isIncome: Bool
    )  {
        self.title = title
        self.amount = amount
        self.category = category
        self.date = date
        self.isIncome = isIncome
    }
}
