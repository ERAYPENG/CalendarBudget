//
//  SettingViewController.swift
//  CalendarBudget
//
//  Created by ERAY on 2020/12/6.
//

import UIKit
import GuillotineMenu
import FSCalendar


class SettingViewController: UIViewController, GuillotineMenu, UITextFieldDelegate {
    //UI
    var dismissButton: UIButton?
    var titleLabel: UILabel?
    private var budgetTextLabelView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()
    private lazy var budgetTextLabel: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.backgroundColor = .systemYellow
        textField.placeholder = "0"
        textField.text = userinputBudgetValue
        textField.keyboardType = .numberPad
        textField.textColor = .purple
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .done
        textField.font = UIFont.systemFont(ofSize: 36)
        return textField
    }()
    
    private lazy var remainBudgetLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .systemYellow
        label.textColor = .purple
        label.font = UIFont.systemFont(ofSize: 36)
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        return label
    }()
    
    private lazy var budgetTitleLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.text = "Budget this month"
        label.font = UIFont.systemFont(ofSize: 36)
        label.textColor = .white
        return label
    }()
    
    private lazy var remainBudgetTitleLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.text = "Remain budget"
        label.font = UIFont.systemFont(ofSize: 36)
        label.textColor = .white
        return label
    }()
    
    //number pad setting
    private lazy var doneToolBar: UIToolbar = {
        let bar = UIToolbar()
        bar.barStyle = .blackTranslucent
        bar.barTintColor = .lightGray
        return bar
    }()
    private lazy var flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    private lazy var barButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(userDidEndEditing))
    private lazy var items = [UIBarButtonItem]()
    
    //properties
    private var monthFormat: DateFormatter = {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MMM"
        return format
    }()
    
    private var monthString: String = ""
    private var costPerMonth: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let calendar = FSCalendar()
        if let today = calendar.today {
            monthString = monthFormat.string(from: today)
        }
        let monthBudgetEventPerMonth = budgetContentDecodeData.filter({return $0.dateString.contains(monthString)})
        costPerMonth = monthBudgetEventPerMonth.map({$0.costValueInt}).reduce(0, +)
        userRemainCostPerMonth = (Int(userinputBudgetValue) ?? 0) - costPerMonth
        remainBudgetLabel.text = String(userRemainCostPerMonth)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        userinputBudgetValue = textField.text ?? ""
        userRemainCostPerMonth = (Int(userinputBudgetValue) ?? 0) - costPerMonth
        print(userRemainCostPerMonth)
        remainBudgetLabel.text = String(userRemainCostPerMonth)
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
        
        self.view.addSubview(budgetTextLabelView)
        //set up number pad toolbar
        self.budgetTextLabelView.addSubview(self.budgetTextLabel)
        self.view.addSubview(self.budgetTitleLabel)
        self.items.append(flexSpace)
        self.items.append(barButton)
        self.doneToolBar.items = items
        self.doneToolBar.sizeToFit()
        self.budgetTextLabel.inputAccessoryView = self.doneToolBar
        
        
        self.budgetTextLabelView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(150)
            make.width.equalTo(300)
            make.height.equalTo(80)
        }
        
        self.budgetTextLabel.snp.makeConstraints { (make) in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        
        self.budgetTitleLabel.snp.makeConstraints { (make) in
            make.leading.height.equalTo(self.budgetTextLabelView)
            make.bottom.equalTo(self.budgetTextLabelView.snp.top)
        }
        
        
        self.view.addSubview(self.remainBudgetLabel)
        self.view.addSubview(self.remainBudgetTitleLabel)
        
        self.remainBudgetLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.budgetTextLabel.snp.bottom).offset(150)
            make.width.height.equalTo(self.budgetTextLabel)
            make.centerX.equalToSuperview()
        }
        
        self.remainBudgetTitleLabel.snp.makeConstraints { (make) in
            make.leading.height.equalTo(self.remainBudgetLabel)
            make.bottom.equalTo(self.remainBudgetLabel.snp.top)
        }
        
        
    
    }
}

//MARK: Event
extension SettingViewController {
    @objc func dismissButtonTapped(_ sender: UIButton) {
        presentingViewController!.dismiss(animated: true, completion: nil)
    }
    
    @objc func userDidEndEditing(_ sender: UIBarButtonItem) -> Bool {
        self.budgetTextLabel.endEditing(true)
        return false
    }
}
