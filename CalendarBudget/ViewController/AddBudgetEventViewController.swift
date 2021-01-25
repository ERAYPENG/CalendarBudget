//
//  AddBudgetEventViewController.swift
//  CalendarBudget
//
//  Created by ERAY on 2020/12/23.
//

import UIKit

class AddBudgetEventViewController: UIViewController {

    var addBudgetEventTitle = ["Category", "Cost"]
    lazy var addBudgetEventTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AddBudgetEventTableViewCell.self, forCellReuseIdentifier: AddBudgetEventTableViewCell.identifier)
        return tableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLoad()
        self.view.backgroundColor = .groupTableViewBackground
        self.view.addSubview(addBudgetEventTableView)
        
        addBudgetEventTableView.snp.makeConstraints { (make) in
            //y
            make.top.equalToSuperview().offset(70)
            make.bottom.equalToSuperview()
            //x
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            
        }
        
        

        
        
//MARK:- AutoLayout
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("add budget view appear")
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AddBudgetEventTableViewCell.identifier) as? AddBudgetEventTableViewCell else {
            let budgetCell = AddBudgetEventTableViewCell(style: .subtitle, reuseIdentifier: AddBudgetEventTableViewCell.identifier)
            return budgetCell
        }
        if indexPath.section == 0 {
            cell.config(type: .category)
        } else if indexPath.section == 1 {
            cell.config(type: .cost)
        }
        
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
}

//MARK:- Events
extension AddBudgetEventViewController{
    @objc func budgetDismiss(sender: UIButton){
        self.dismiss(animated: true, completion: nil)
    }
}
