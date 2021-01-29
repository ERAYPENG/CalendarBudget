//
//  BudgetTableViewCell.swift
//  CalendarBudget
//
//  Created by ERAY on 2021/1/25.
//

import UIKit
import SnapKit

enum BudgetTableViewCellType {
    case food
    case clothing
    case housing
    case transportation
    case entertainment
}

class BudgetTableViewCell: UITableViewCell, UITextFieldDelegate {
    public static var identifier: String = "BudgetTableViewCell"
    public var budgetEventUserInputText: String = ""
    public var budgetCostUserInputText: String = ""
    
    private var budgetEventLabel: UILabel = {
        let textField = UILabel()
        textField.textColor = .black
        return textField
    }()
    
    private var budgetCostLabel: UILabel = {
        let textField = UILabel()
        textField.textColor = .black
        return textField
    }()

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func config(model: AddBudgetEventContent) {
        self.contentView.addSubview(self.budgetEventLabel)
        self.contentView.addSubview(self.budgetCostLabel)
            
        self.budgetEventLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
            }
        self.budgetCostLabel.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
            }
        self.budgetEventLabel.text = model.descriptionValueString
        self.budgetCostLabel.text = String(model.costValueInt)
        
    }
    

}
//MARK:- private
extension BudgetTableViewCell {
    private func setupUI() {
        self.budgetEventLabel.textColor = .darkText
        self.budgetCostLabel.textColor = .darkText
    }
}
