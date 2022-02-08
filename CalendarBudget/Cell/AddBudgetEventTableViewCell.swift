//
//  AddBudgetEventTableViewCell.swift
//  CalendarBudget
//
//  Created by ERAY on 2021/1/25.
//

import UIKit

enum AddBudgetEventTableViewCellType {
    case category
    case description
    case cost
}



class AddBudgetEventTableViewCell: UITableViewCell, UITextFieldDelegate {
    public static var identifier = "AddBudgetEventTableViewCell"
    var userDidEndEditingDescriptionTextFieldClosure: ((String)->())?
    var userDidEndEditingCostTextFieldClosure: ((Int)->())?
    private var userDidSelectCategoryValue: String = "Food"
    private var userDidEndEditinValue: Int = 0
    private var slotView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var categoryTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .hex("454545")
        label.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight(rawValue: 0.5))
        return label
    }()
    
    private lazy var descriptionTextField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .done
        textField.placeholder = "Add something"
        textField.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight(rawValue: 0.3))
        textField.textColor = .hex("454545")
        textField.tintColor = .hex("667e95")
        return textField
    }()
    
    private lazy var costTextField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .done
        textField.keyboardType = .numberPad
        textField.placeholder = "0"
        textField.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight(rawValue: 0.3))
        textField.textColor = .hex("454545")
        textField.tintColor = .hex("667e95")
        return textField
    }()
    
    lazy var doneToolBar: UIToolbar = {
        let bar = UIToolbar()
        bar.barStyle = .blackTranslucent
        bar.barTintColor = .lightGray
        return bar
    }()
    
    lazy var flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    
    lazy var donButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(userDidEndEditing))
    
    lazy var items = [UIBarButtonItem]()
    
    private var contentString: String = ""
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func config(type: AddBudgetEventTableViewCellType, content: String) {
        
        self.slotView.subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        
        switch type {
        case .category:
            self.categoryTitleLabel.text = content
            self.accessoryType = .disclosureIndicator
            self.slotView.addSubview(self.categoryTitleLabel)
            self.categoryTitleLabel.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
                make.height.equalTo(44)
            }
            
        case .description:
//            descriptionTextField
            self.slotView.addSubview(self.descriptionTextField)
            self.descriptionTextField.snp.makeConstraints { (make) in
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

//MARK:- TextfieldDelegate
extension AddBudgetEventTableViewCell {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == descriptionTextField {
            let descriptionUserInput = textField.text ?? ""
            if let closure = self.userDidEndEditingDescriptionTextFieldClosure {
                closure(descriptionUserInput)
            }
        } else {
            let intOfUserInput = Int(textField.text ?? "")
            userDidEndEditinValue = intOfUserInput ?? 0
            if let closure = self.userDidEndEditingCostTextFieldClosure {
                closure(userDidEndEditinValue)
            }
        }
        
    }
}
