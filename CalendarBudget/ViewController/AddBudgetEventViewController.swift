//
//  AddBudgetEventViewController.swift
//  CalendarBudget
//
//  Created by ERAY on 2020/12/23.
//

import UIKit

class AddBudgetEventViewController: UIViewController, CategoryVCDelegate {
    func userDidSelectCategoryValue(value: String) {
        self.userDidSelectValue = value
    }
    
    func userDidSelectCategoryRowNum(row: Int) {
        self.userDidSelectRowNum = row
    }
    
    private var userDidSelectValue: String = ""
    private var userDidSelectRowNum: Int = 0
    var categoryVC = CategoryViewController()
    var addBudgetEventTitle = ["Category", "Cost"]
    lazy var addBudgetEventTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AddBudgetEventTableViewCell.self, forCellReuseIdentifier: AddBudgetEventTableViewCell.identifier)
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    lazy var saveButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .gray
        button.setTitle("Save", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 20
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 5.0
        button.addTarget(self, action: #selector(saveEvent), for: .touchUpInside)
        return button
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .groupTableViewBackground
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(budgetDismiss), for: .touchUpInside)
        return button
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .groupTableViewBackground
        self.view.addSubview(addBudgetEventTableView)
        self.view.addSubview(saveButton)
        self.view.addSubview(cancelButton)
        self.addBudgetEventTableView.snp.makeConstraints { (make) in
            //y
            make.top.equalToSuperview().offset(70)
            make.bottom.equalToSuperview()
            //x
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            
        }
        
        self.saveButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-24)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().dividedBy(2)
            make.height.equalTo(60)
        }
        
        self.cancelButton.snp.makeConstraints { (make) in
            make.trailing.equalTo(self.view)
            make.top.equalTo(self.view).offset(10)
            make.width.equalTo(100)
            make.height.equalTo(50)
        }
        

        
        
//MARK:- AutoLayout
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        print("add budget view appear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    

}

//MARK:- UITableView
extension AddBudgetEventViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return addBudgetEventTitle.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return addBudgetEventTitle[section]
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let budgetHeaderLabel = UILabel()
        budgetHeaderLabel.font = UIFont.systemFont(ofSize: 30)
        budgetHeaderLabel.text = self.tableView(addBudgetEventTableView, titleForHeaderInSection: section)
        
        let budgetHeaderView = UIView()
        budgetHeaderView.backgroundColor = UIColor(red: 230/255, green: 218/255, blue: 196/255, alpha: 1)
        budgetHeaderView.addSubview(budgetHeaderLabel)
        budgetHeaderLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(budgetHeaderView).offset(20)
            make.height.equalTo(budgetHeaderView)
            
        }
        return budgetHeaderView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AddBudgetEventTableViewCell.identifier, for: indexPath) as? AddBudgetEventTableViewCell else {
            return AddBudgetEventTableViewCell(style: .subtitle, reuseIdentifier: AddBudgetEventTableViewCell.identifier)
        }
        if indexPath.section == 0 {
            cell.config(type: AddBudgetEventTableViewCellType.category)
        } else if indexPath.section == 1 {
            cell.config(type: AddBudgetEventTableViewCellType.cost)
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.navigationController?.pushViewController(categoryVC, animated: true)
            categoryVC.categoryVCDelegate = self
            categoryVC.userIndex = userDidSelectRowNum
            
        }
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView.init(frame: CGRect.zero)
    }
}

//MARK:- Events
extension AddBudgetEventViewController{
    @objc func budgetDismiss(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func saveEvent(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
