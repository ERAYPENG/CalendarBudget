//
//  LoginTextfield.swift
//  CalendarBudget
//
//  Created by ERAY on 2021/3/6.
//

import UIKit

class LoginTextfieldView: UIView {
    
    public var textfield: UITextField = {
        let textfield = UITextField()
        textfield.font = UIFont(name: "Menlo", size: 16)
        textfield.tintColor = .hex("454545")
        return textfield
    }()
    
    init(placeholder: String = "type...") {
        super.init(frame: .zero)
        self.backgroundColor = .groupTableViewBackground
        self.layer.cornerRadius = 10
        
        textfield.placeholder = placeholder
        self.addSubview(textfield)
        textfield.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview().inset(5)
            make.leading.trailing.equalToSuperview().inset(12)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
