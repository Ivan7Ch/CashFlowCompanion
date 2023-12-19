//
//  UserDefaultsManager.swift
//  CashFlow Companion
//
//  Created by Ivan Chernetskiy on 02.12.2023.
//

import Foundation

class UserDefaultsManager {
    
    static let shared = UserDefaultsManager()

    private let expensesKey = "UserExpenses"

    private init() {}

    func saveExpenses(_ expenses: [Expense]) {
        do {
            let encodedData = try JSONEncoder().encode(expenses)
            UserDefaults.standard.set(encodedData, forKey: expensesKey)
        } catch {
            print("Error encoding expenses: \(error.localizedDescription)")
        }
    }

    func loadExpenses() -> [Expense] {
        guard let encodedData = UserDefaults.standard.data(forKey: expensesKey) else { return [] }

        do {
            let expenses = try JSONDecoder().decode([Expense].self, from: encodedData)
            return expenses
        } catch {
            print("Error decoding expenses: \(error.localizedDescription)")
            return []
        }
    }

    func addExpense(_ expense: Expense) {
        var existingExpenses = loadExpenses()
        existingExpenses.append(expense)
        saveExpenses(existingExpenses)
    }

    func updateExpense(at index: Int, with newExpense: Expense) {
        var existingExpenses = loadExpenses()
        guard index >= 0, index < existingExpenses.count else { return }
        existingExpenses[index] = newExpense
        saveExpenses(existingExpenses)
    }

    func deleteExpense(at index: Int) {
        var existingExpenses = loadExpenses()
        guard index >= 0, index < existingExpenses.count else { return }
        existingExpenses.remove(at: index)
        saveExpenses(existingExpenses)
    }
}

