//
//  ExpensesChartViewController.swift
//  CashFlow Companion
//
//  Created by Ivan Chernetskiy on 02.12.2023.
//

import UIKit

class ExpensesChartViewController: UIViewController {
    
    @IBOutlet weak var pieChartView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var changeIncomeButton: UIButton!
    
    var expenses: [Expense] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadExpensesForCurrentMonth()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        showViews()
        reloadInfoData()
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
        changeIncomeButton.addTarget(self, action: #selector(changeIncomeTapped), for: .touchUpInside)
    }
    
    @objc func changeIncomeTapped() {
        let alertController = UIAlertController(title: "Змінити місячний дохід", message: "Введіть нову суму", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Введіть суму"
            textField.keyboardType = .decimalPad
        }
        
        let cancelAction = UIAlertAction(title: "Скасувати", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Зберегти", style: .default) { [weak self] _ in
            guard let textField = alertController.textFields?.first,
                  let newIncomeString = textField.text,
                  let newIncome = Double(newIncomeString) else {
                return
            }
            UserDefaults.standard.set(newIncome, forKey: "MonthlyIncome")
            self?.reloadInfoData()
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func reloadInfoData() {
        let monthlyIncome = UserDefaults.standard.double(forKey: "MonthlyIncome")
        
        // Всі витрати
        let allExpenses = CoreDataManager.shared.fetchExpenses()
        let totalExpenseAmount = allExpenses.reduce(0.0) { $0 + $1.amount }

        // Витрати за останній місяць
        let currentDate = Date()
        let currentMonthStart = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: currentDate))!
        let currentMonthEnd = Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: currentMonthStart)!
        
        let expensesForCurrentMonth = allExpenses.filter {
            $0.date >= currentMonthStart && $0.date <= currentMonthEnd
        }
        let totalExpenseAmountForCurrentMonth = expensesForCurrentMonth.reduce(0.0) { $0 + $1.amount }

        // Обчислення середніх витрат за місяць
        let monthsOfExpenses = Set(allExpenses.map { Calendar.current.component(.month, from: $0.date) }).count
        let averageExpensePerMonth = totalExpenseAmount / Double(monthsOfExpenses)

        // Розрахунок можливості відкладання грошей
        let savingsForCurrentMonth = monthlyIncome - totalExpenseAmountForCurrentMonth
        let savingsForYear = savingsForCurrentMonth * 12

        infoLabel.text = "Місячний дохід: \(monthlyIncome)\n"
        infoLabel.text! += "Витрати за останній місяць: \(totalExpenseAmountForCurrentMonth)\n"
        infoLabel.text! += "Середні витрати в місяць: \(averageExpensePerMonth)\n"
        infoLabel.text! += "Можна відкласти в місяць: \(savingsForCurrentMonth)\n"
        infoLabel.text! += "Можна відкласти в рік: \(savingsForYear)\n"
    }

    @objc func segmentedControlValueChanged() {
        if segmentedControl.selectedSegmentIndex == 0 {
            showViews()
        } else {
            hideViews()
        }
    }
    
    func loadExpensesForCurrentMonth() {
        let currentDate = Date()
        let currentMonthStart = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: currentDate))!
        let currentMonthEnd = Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: currentMonthStart)!
        
        expenses = CoreDataManager.shared.fetchExpenses().filter {
            $0.date >= currentMonthStart && $0.date <= currentMonthEnd
        }
    }
    
    func createPieChart() {
        var categoryAmounts: [ExpenseCategory: Double] = [:]
        var totalExpenseAmount: Double = 0.0
        
        for expense in expenses {
            totalExpenseAmount += expense.amount
            if let currentAmount = categoryAmounts[expense.category] {
                categoryAmounts[expense.category] = currentAmount + expense.amount
            } else {
                categoryAmounts[expense.category] = expense.amount
            }
        }
        
        let center = CGPoint(x: pieChartView.bounds.width / 2, y: pieChartView.bounds.height / 2)
        let innerRadius = min(pieChartView.bounds.width, pieChartView.bounds.height) / 4 // Внутрішній радіус
        let outerRadius = min(pieChartView.bounds.width, pieChartView.bounds.height) / 2 - 10 // Зовнішній радіус
        
        var startAngle: CGFloat = -CGFloat.pi / 2
        
        for (category, amount) in categoryAmounts {
            let endAngle = startAngle + CGFloat(amount / totalExpenseAmount) * 2 * CGFloat.pi
            
            let sliceLayer = CAShapeLayer()
            let path = UIBezierPath(arcCenter: center, radius: outerRadius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            path.addArc(withCenter: center, radius: innerRadius, startAngle: endAngle, endAngle: startAngle, clockwise: false)
            path.close()
            
            sliceLayer.path = path.cgPath
            sliceLayer.fillColor = category.color.cgColor
            
            pieChartView.layer.addSublayer(sliceLayer)
            
            startAngle = endAngle
        }
    }
    
    func hideViews() {
        pieChartView.isHidden = true
        tableView.isHidden = true
        infoLabel.isHidden = false
        changeIncomeButton.isHidden = false
    }
    
    func showViews() {
        pieChartView.isHidden = false
        tableView.isHidden = false
        infoLabel.isHidden = true
        changeIncomeButton.isHidden = true
        createPieChart()
    }
}

extension ExpensesChartViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let uniqueCategories = Set(expenses.map { $0.category })
        return uniqueCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AnalyticsCategoryTableViewCell", for: indexPath) as? AnalyticsCategoryTableViewCell else {
            return UITableViewCell()
        }
        
        let uniqueCategories = Array(Set(expenses.map { $0.category })).sorted(by: { $0.rawValue > $1.rawValue })
        let category = uniqueCategories[indexPath.row]
        let categoryExpenses = expenses.filter { $0.category == category }
        let amount = categoryExpenses.reduce(0.0) { $0 + $1.amount }
        let totalAmountForCategory = categoryExpenses.reduce(0.0) { $0 + $1.amount }
        let totalExpenses = expenses.reduce(0.0) { $0 + $1.amount }
        
        let percentage = totalExpenses > 0 ? (totalAmountForCategory / totalExpenses) * 100 : 0
        cell.configure(with: category, amount: amount, totalAmount: totalAmountForCategory, percentage: percentage)
        
        return cell
    }
    
}
