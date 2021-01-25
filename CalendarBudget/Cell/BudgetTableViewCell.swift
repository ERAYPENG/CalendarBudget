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
//        view.backgroundColor = .clear
        return view
    }()
    
    private var budgetEventTextField: UITextField = {
        let textField = UITextField()
        return textField
    }()
    
    private var budgetCostTextField: UITextField = {
        let textField = UITextField()
        textField.keyboardType = .numberPad
        return textField
    }()

    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case budgetEventTextField:
            budgetEventUserInputText = textField.text ?? ""
        case budgetCostTextField:
            budgetCostUserInputText = textField.text ?? ""
        default:
            return
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
        return true
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func config() {
        self.slotView.addSubview(self.budgetEventTextField)
        self.slotView.addSubview(self.budgetCostTextField)
            
        self.budgetEventTextField.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
                make.height.equalTo(44)
            }
        self.budgetCostTextField.snp.makeConstraints { (make) in
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
