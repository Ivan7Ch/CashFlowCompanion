//
//  CategoryTableViewCell.swift
//  CashFlow Companion
//
//  Created by Ivan Chernetskiy on 02.12.2023.
//

import UIKit

class AnalyticsCategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var categoryColorView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var percentageLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        configureContainerView()
    }

    func configure(with category: ExpenseCategory, amount: Double, totalAmount: Double, percentage: Double) {
        categoryColorView.backgroundColor = category.color
        categoryLabel.text = category.rawValue
        amountLabel.text = String(format: "%.0f", amount)
        
        percentageLabel.text = String(format: "%.2f%%", percentage)
    }

    private func configureContainerView() {
        containerView.layer.cornerRadius = 8
        containerView.layer.masksToBounds = true
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.lightGray.cgColor
    }
}

