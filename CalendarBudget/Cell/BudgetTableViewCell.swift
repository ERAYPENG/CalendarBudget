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
}

class BudgetTableViewCell: UITableViewCell, UITextFieldDelegate {
    public static var identifier: String = "BudgetTableViewCell"
    public var budgetEventUserInputText: String = ""
    public var budgetCostUserInputText: String = ""
    
    private var slotView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    private var budgetEventLabel: UILabel = {
        let textField = UILabel()
        return textField
    }()
    
    private var budgetCostLabel: UILabel = {
        let textField = UILabel()
        return textField
    }()

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func config() {
        self.slotView.addSubview(self.budgetEventLabel)
        self.slotView.addSubview(self.budgetCostLabel)
            
        self.budgetEventLabel.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
                make.height.equalTo(44)
            }
        self.budgetCostLabel.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
                make.height.equalTo(44)
            }
        
    }
    

}
//MARK:- private
extension BudgetTableViewCell {
    private func setupUI() {
        self.contentView.addSubview(self.slotView)
        self.slotView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview().inset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
}
