//
//  SettingViewController.swift
//  CalendarBudget
//
//  Created by ERAY on 2020/12/6.
//

import UIKit
import GuillotineMenu



class SettingViewController: UIViewController, GuillotineMenu, UITextFieldDelegate {
    //UI
    var dismissButton: UIButton?
    var titleLabel: UILabel?
    private lazy var budgetTextLabel: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.backgroundColor = .lightGray
        textField.placeholder = "0"
        textField.text = userinputBudgetValue
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        textField.textColor = .black
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .done
        textField.font = UIFont.systemFont(ofSize: 48)
        return textField
    }()
    
    //properties
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("Setting vc will appear")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        userinputBudgetValue = textField.text ?? ""
        textField.backgroundColor = .lightGray
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.budgetTextLabel.endEditing(true)
        return true
    }
    
    private func menuButtonTapped(_ sender: UIButton) {
        presentingViewController!.dismiss(animated: true, completion: nil)
    }
    
    private func closeMenu(_ sender: UIButton) {
        presentingViewController!.dismiss(animated: true, completion: nil)
    }
}
//MARK: Private
extension SettingViewController {
    private func setupUI() {
        self.view.backgroundColor = .gray
        dismissButton = {
            let button = UIButton(frame: .zero)
            button.setImage(UIImage(named: "cogwheel"), for: .normal)
            button.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
            return button
        }()
        
        titleLabel = {
            let label = UILabel()
            return label
        }()
        
        self.view.addSubview(self.budgetTextLabel)
        
        self.budgetTextLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(200)
            make.width.equalTo(300)
            make.height.equalTo(80)
        }
        
    
    }
}

//MARK: Event
extension SettingViewController {
    @objc func dismissButtonTapped(_ sender: UIButton) {
        presentingViewController!.dismiss(animated: true, completion: nil)
    }
}
