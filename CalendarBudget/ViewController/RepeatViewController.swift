//
//  RepeatViewController.swift
//  CalendarBudget
//
//  Created by ERAY on 2020/12/25.
//

import UIKit

@objc protocol RepeatViewControllerDelegate: class {
    @objc func repeatViewControllerDidSelectRow(title: String)
    @objc func repeatViewControllerUserIndexRow(row: Int)
}

class RepeatViewController: UIViewController {
    
    var repeatViewDelegate: RepeatViewControllerDelegate?
    let repeatRowTitle = ["Never","Every week","Every two weeks","Every month","Every two months","Every three months","Once half a year","Once a year"]
    var userSelectIndex: Int?
    private var rowDefaultSelected: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .groupTableViewBackground
        let repeatTableView = UITableView()
        repeatTableView.dataSource = self
        repeatTableView.delegate = self
        repeatTableView.backgroundColor = .groupTableViewBackground
        repeatTableView.register(UITableViewCell.self, forCellReuseIdentifier: "repeatCell")
        
        view.addSubview(repeatTableView)
        
        
        repeatTableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("repeat view appear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("repeat view disapper")
    }
    


}

extension RepeatViewController: UITableViewDataSource,UITableViewDelegate  {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repeatRowTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "repeatCell", for: indexPath)
        cell.textLabel?.text = repeatRowTitle[indexPath.row]
        cell.textLabel?.textColor = .hex("454545")
        cell.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight(rawValue: 0.5))
        if userSelectIndex == nil {
            if indexPath.row == 0 {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        } else {
            if indexPath.row == userSelectIndex {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        }
        
        
        
        return cell
    }
    

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.userSelectIndex = indexPath.row
        self.repeatViewDelegate?.repeatViewControllerDidSelectRow(title: repeatRowTitle[indexPath.row])
        self.repeatViewDelegate?.repeatViewControllerUserIndexRow(row: indexPath.row)
        tableView.reloadData()
    }
    
    
    
}

//MARK:- Events

