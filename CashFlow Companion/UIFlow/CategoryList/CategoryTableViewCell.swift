//
//  CategoryTableViewCell.swift
//  CashFlow Companion
//
//  Created by Ivan Chernetskiy on 02.12.2023.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    static let identifier = "CategoryCellIdentifier"

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var categoryNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 10
        containerView.clipsToBounds = true
    }
}
