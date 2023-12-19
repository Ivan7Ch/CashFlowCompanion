//
//  AddExpenseViewController.swift
//  CashFlow Companion
//
//  Created by Ivan Chernetskiy on 02.12.2023.
//

import UIKit

class AddExpenseViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var categoryPickerView: UIPickerView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!

    let expenseCategories: [ExpenseCategory] = [
        .food, .transport, .housing, .entertainment, .clothing, .health, .education, .giftsAndDonations, .financialExpenses
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        categoryPickerView.delegate = self
        categoryPickerView.dataSource = self
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return expenseCategories.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return expenseCategories[row].rawValue
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCategory = expenseCategories[row]
    }

    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard let selectedRow = categoryPickerView?.selectedRow(inComponent: 0),
              let amountText = amountTextField.text,
              let amount = Double(amountText),
              let description = descriptionTextField.text else {
            return
        }

        let selectedCategory = expenseCategories[selectedRow]
        let date = datePicker.date
        let expense = Expense(category: selectedCategory, amount: amount, date: date, description: description)

        CoreDataManager.shared.addExpense(expense)
        
        let parentVC = navigationController?.viewControllers.first as! ExpensesViewController
        parentVC.reloadData()
        
        navigationController?.popViewController(animated: true)
    }
}
