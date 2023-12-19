//
//  CoreDataManager.swift
//  CashFlow Companion
//
//  Created by Ivan Chernetskiy on 19.12.2023.
//

import CoreData
import UIKit

class CoreDataManager {
    static let shared = CoreDataManager()

    private init() {}

    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "database")
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    // MARK: - CRUD Operations
    func createExpense(category: String, amount: Double, date: Date, description: String?) {
        let newExpense = Expense(context: context)
        newExpense.category = category
        newExpense.amount = amount
        newExpense.date = date
        newExpense.expenseDescription = description // Assuming 'description' is named 'expenseDescription' in Core Data to avoid conflict with Swift's 'description'
        saveContext()
    }

    func fetchExpenses() -> [Expense] {
        let fetchRequest: NSFetchRequest<Expense> = Expense.fetchRequest()
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Error fetching expenses: \(error)")
            return []
        }
    }

    func updateExpense(expense: Expense, category: String, amount: Double, date: Date, description: String?) {
        expense.category = category
        expense.amount = amount
        expense.date = date
        expense.expenseDescription = description
        saveContext()
    }

    func deleteExpense(expense: Expense) {
        context.delete(expense)
        saveContext()
    }
}

