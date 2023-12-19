//
//  ExpensesViewController.swift
//  CashFlow Companion
//
//  Created by Ivan Chernetskiy on 02.12.2023.
//

import UIKit

class ExpensesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    
    var expenses: [Expense] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        addButton.layer.cornerRadius = addButton.frame.size.width / 2
        addButton.layer.shadowColor = UIColor.black.cgColor
        addButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        addButton.layer.shadowRadius = 3.0
        addButton.layer.shadowOpacity = 0.5
        
        reloadData()
    }
    
    func reloadData() {
        expenses = CoreDataManager.shared.loadExpenses().sorted { $0.date > $1.date }
        tableView.reloadData()
        
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        let currentMonth = dateFormatter.string(from: currentDate)
        title = currentMonth
        
        let currentMonthStart = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: currentDate))!
        let currentMonthEnd = Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: currentMonthStart)!
        expenses = expenses.filter { $0.date >= currentMonthStart && $0.date <= currentMonthEnd }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expenses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExpenseTableViewCell", for: indexPath) as! ExpenseTableViewCell
        
        let expense = expenses[indexPath.row]
        cell.configure(with: expense)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            expenses.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            CoreDataManager.shared.saveExpenses(expenses)
        }
    }
}
