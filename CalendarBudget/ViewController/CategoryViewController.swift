//
//  CategoryViewController.swift
//  CalendarBudget
//
//  Created by ERAY on 2021/1/26.
//

import UIKit

@objc protocol CategoryVCDelegate: class {
    @objc func userDidSelectCategoryValue(value: String)
    @objc func userDidSelectCategoryRowNum(row: Int)
    
}

class CategoryViewController: UIViewController {
    var categoryVCDelegate: CategoryVCDelegate?
    var userIndex: Int?
    lazy var categoryTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: CategoryTableViewCell.identifier)
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    var budgetTitle = ["Food", "Clothing", "Housing", "Transportation", "Education", "Entertainment"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .groupTableViewBackground
        self.view.addSubview(self.categoryTableView)
        
        
        self.categoryTableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        }
    }
    

}

//MARK:- UITabelView
extension CategoryViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return budgetTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.identifier, for: indexPath) as? CategoryTableViewCell else {
            return CategoryTableViewCell(style: .subtitle, reuseIdentifier: CategoryTableViewCell.identifier)
        }
        cell.config(row: indexPath.row)
        if userIndex == nil {
            if indexPath.row == 0 {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        } else {
            if userIndex == indexPath.row {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.userIndex = indexPath.row
        tableView.reloadData()
        let str = budgetTitle[self.userIndex ?? 0]
        self.categoryVCDelegate?.userDidSelectCategoryValue(value: str)
        self.categoryVCDelegate?.userDidSelectCategoryRowNum(row: indexPath.row)
        
    }
    
    
}
