//
//  SettingViewController.swift
//  CalendarBudget
//
//  Created by ERAY on 2020/12/6.
//

import UIKit

class SettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    /*
     lazy: 需要用到時，才生出來
     */
    
    //computed property (didSet)
//    private lazy var tableView: UITableView = {
//        let tableView = UITableView()
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.backgroundColor = .systemYellow
//        return tableView
//    }()
    
    var eatAmout = 200
    var transportationAmount = 100
    
    var totalMoney: Int {
        get {
            return eatAmout + transportationAmount
        }
        set {
            
        }
    }
    
    private var tableView: UITableView {
        get {
            let tableView = UITableView()
            tableView.delegate = self
            tableView.dataSource = self
            tableView.backgroundColor = .systemYellow
            return tableView
        }
        set {
            self.tableView.separatorStyle = .none
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.view.backgroundColor = .groupTableViewBackground
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("Setting vc will appear")
        //get tableview
//        self.tableView.separatorStyle = .none

        //set tableview
//        self.tableView = UITableView()
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//MARK: UITableViewDataSource
extension SettingViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
}

//MARK: Private
extension SettingViewController {
    private func setupUI() {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .systemYellow
        self.tableView = tableView
        
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
//            make.top.bottom.leading.trailing.equalToSuperview()
            make.edges.equalToSuperview().inset(16)
        }
        let textField = UITextField()
    }
}
