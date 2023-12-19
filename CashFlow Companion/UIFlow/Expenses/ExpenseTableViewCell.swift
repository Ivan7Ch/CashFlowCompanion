//
//  ExpenseTableViewCell.swift
//  CashFlow Companion
//
//  Created by Ivan Chernetskiy on 02.12.2023.
//
import UIKit

class ExpenseTableViewCell: UITableViewCell {
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 8
        containerView.clipsToBounds = true
    }

    func configure(with expense: Expense) {
        colorView.backgroundColor = expense.category.color
        amountLabel.text = "\(expense.amount) uah"
        categoryNameLabel.text = expense.category.rawValue
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
        dateLabel.text = dateFormatter.string(from: expense.date)
        
        if let description = expense.description {
            descriptionLabel.text = description
        } else {
            descriptionLabel.text = ""
        }
    }
}
