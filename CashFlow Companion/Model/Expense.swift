//
//  Expense.swift
//  CashFlow Companion
//
//  Created by Ivan Chernetskiy on 02.12.2023.
//

import Foundation

struct Expense: Codable {
    let category: ExpenseCategory
    let amount: Double
    let date: Date
    let description: String?
    
    enum CodingKeys: String, CodingKey {
        case category, amount, date, description
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        category = try container.decode(ExpenseCategory.self, forKey: .category)
        amount = try container.decode(Double.self, forKey: .amount)
        date = try container.decode(Date.self, forKey: .date)
        description = try container.decodeIfPresent(String.self, forKey: .description) // Декодуємо як необов'язкове значення
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(category, forKey: .category)
        try container.encode(amount, forKey: .amount)
        try container.encode(date, forKey: .date)
        try container.encodeIfPresent(description, forKey: .description) // Кодуємо як необов'язкове значення
    }
    
    init(category: ExpenseCategory, amount: Double, date: Date, description: String?) {
        self.category = category
        self.amount = amount
        self.date = date
        self.description = description
    }
}
