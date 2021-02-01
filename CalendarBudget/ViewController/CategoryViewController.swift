//
//  CategoryViewController.swift
//  CalendarBudget
//
//  Created by ERAY on 2021/1/26.
//

import UIKit

@objc protocol CategoryVCDelegate: class {
    @objc func userDidSelectCategoryRowNum(row: Int)
    
}

class CategoryViewController: UIViewController {
    
    public static let defaultCategoryIndex = 0
    
    var categoryVCDelegate: CategoryVCDelegate?
    
    var userDidSelectCategoyClosure: ((Int)->())?
    
    public var userIndex: Int = CategoryViewController.defaultCategoryIndex
    
    lazy var categoryTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: CategoryTableViewCell.identifier)
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let closure = self.userDidSelectCategoyClosure { closure(userIndex) }
        
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
        return budgetTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.identifier, for: indexPath) as? CategoryTableViewCell else {
            return CategoryTableViewCell(style: .subtitle, reuseIdentifier: CategoryTableViewCell.identifier)
        }
        cell.config(row: indexPath.row)
        
        if userIndex == indexPath.row {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //UI logic
        self.userIndex = indexPath.row
        tableView.reloadData()
        
        //model logic
        if let closure = self.userDidSelectCategoyClosure {
            closure(self.userIndex)
        }
        self.categoryVCDelegate?.userDidSelectCategoryRowNum(row: self.userIndex)
    }
    
    
}
