//
//  ExpenseCategory.swift
//  CashFlow Companion
//
//  Created by Ivan Chernetskiy on 02.12.2023.
//

import UIKit

enum ExpenseCategory: String, Codable, CaseIterable {
    
    case food = "Їжа"
    case transport = "Транспорт"
    case housing = "Житло"
    case entertainment = "Розваги"
    case clothing = "Одяг"
    case health = "Здоров'я"
    case education = "Освіта"
    case giftsAndDonations = "Подарунки та благодійність"
    case financialExpenses = "Фінансові витрати"

    var color: UIColor {
        switch self {
        case .food:
            return UIColor.systemRed
        case .transport:
            return UIColor.systemBlue
        case .housing:
            return UIColor.systemGreen
        case .entertainment:
            return UIColor.systemPurple
        case .clothing:
            return UIColor.systemOrange
        case .health:
            return UIColor.systemYellow
        case .education:
            return UIColor.systemTeal
        case .giftsAndDonations:
            return UIColor.systemIndigo
        case .financialExpenses:
            return UIColor.systemPink
        }
    }
}
