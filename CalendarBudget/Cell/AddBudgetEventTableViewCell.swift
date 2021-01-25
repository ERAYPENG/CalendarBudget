//
//  AddBudgetEventTableViewCell.swift
//  CalendarBudget
//
//  Created by ERAY on 2021/1/25.
//

import UIKit

enum AddBudgetEventTableViewCellType {
    case category
    case cost
}

class AddBudgetEventTableViewCell: UITableViewCell {
    public static var identifier = "AddBudgetEventTableViewCell"
    private var slotView: UIView = {
        let view = UIView()
        return view
    }()
    var categoryTitleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    var costTextField: UITextField = {
        let textField = UITextField()
        textField.keyboardType = .numberPad
        textField.placeholder = "0"
        return textField
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func config(type: AddBudgetEventTableViewCellType) {
        switch type {
        case .category:
            self.categoryTitleLabel.text = "Food"
            self.accessoryType = .disclosureIndicator
            
            self.slotView.addSubview(categoryTitleLabel)
            self.categoryTitleLabel.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
                make.height.equalTo(44)
            }
            
        case .cost:
            self.slotView.addSubview(costTextField)
            self.costTextField.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
                make.height.equalTo(44)
            }
        }
    }
    
    
}

//MARK:- private
extension AddBudgetEventTableViewCell {
    private func setupUI() {
        self.contentView.addSubview(self.slotView)
        slotView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview().inset(8)
            make.leading.trailing.equalToSuperview().inset(8)
        }
    }
}
