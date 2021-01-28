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



class AddBudgetEventTableViewCell: UITableViewCell, UITextFieldDelegate {
    public static var identifier = "AddBudgetEventTableViewCell"
    var userDidEndEditingCostTextFieldClosure: ((Int)->())?
    private var userDidSelectCategoryValue: String = "Food"
    private var userDidEndEditinValue: Int = 0
    private var slotView: UIView = {
        let view = UIView()
        return view
    }()
    private var categoryTitleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var costTextField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .done
        textField.keyboardType = .numberPad
        textField.placeholder = "0"
        return textField
    }()
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.endEditing(true)
        return false
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        let intOfUserInput = Int(textField.text ?? "")
        userDidEndEditinValue = intOfUserInput ?? 0
        if let closure = self.userDidEndEditingCostTextFieldClosure {
            closure(userDidEndEditinValue)
        }
    }
    
    
    
    lazy var doneToolBar: UIToolbar = {
        let bar = UIToolbar()
        bar.barStyle = .blackTranslucent
        bar.barTintColor = .lightGray
        return bar
    }()
    
    lazy var flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    
    lazy var donButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(userDidEndEditing))
    
    lazy var items = [UIBarButtonItem]()
    
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
            self.categoryTitleLabel.text = userDidSelectCategoryValue
            self.accessoryType = .disclosureIndicator
            self.slotView.addSubview(self.categoryTitleLabel)
            self.categoryTitleLabel.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
                make.height.equalTo(44)
            }
            
        case .cost:
            self.slotView.addSubview(self.costTextField)
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
        self.backgroundColor = UIColor(red: 216/255, green: 223/255, blue: 221/255, alpha: 1)
        self.contentView.addSubview(self.slotView)
        self.slotView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview().inset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        self.items.append(flexSpace)
        self.items.append(donButton)
        self.doneToolBar.items = items
        self.doneToolBar.sizeToFit()
        self.costTextField.inputAccessoryView = doneToolBar
    }
}

//MARK:- Event
extension AddBudgetEventTableViewCell {
    @objc func userDidEndEditing(sender: UIBarButtonItem) {
        self.costTextField.resignFirstResponder()
    }
    

    
}
