//
//  AddBudgetEventViewController.swift
//  CalendarBudget
//
//  Created by ERAY on 2020/12/23.
//

import UIKit

struct AddBudgetEventContent: Codable {
    var dateString: String
    var categoryValueString: String
    var descriptionValueString: String
    var costValueInt: Int
}
var addBudgetEventContent: [AddBudgetEventContent] = []
var budgetContentDecodeData = [AddBudgetEventContent]()
class AddBudgetEventViewController: UIViewController, CategoryVCDelegate {
    func userDidSelectCategoryRowNum(row: Int) {
        self.userDidSelectRowNum = row
    }
    var saveBudgetEventClosure: ((String)->())?
    var addBudgetEventDescriptionValue: String = ""
    var addBudgetEventCostValue: Int = 0
    private var userDidSelectRowNum: Int = 0
    let mainVC = MainViewController()
    let calenderVC = CalendarViewController()

//    lazy var categoryVC: CategoryViewController = {
//
//        return categoryVC
//    }()
    
    lazy var addBudgetEventTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AddBudgetEventTableViewCell.self, forCellReuseIdentifier: AddBudgetEventTableViewCell.identifier)
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    private var addBudgetEventTitle = ["Category", "Description", "Cost"]
    
    //cell values
    private lazy var categoryValueString: String = budgetTitles[0]
    public var dateString: String = ""
    private var costValue: Int = 0
    
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
    
    private var emptyCostAlert: UIAlertController = {
        let alert = UIAlertController(title: "Oops!", message: "Please complete all sections", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(alertAction)
        return alert
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
            cell.config(type: AddBudgetEventTableViewCellType.category, content: self.categoryValueString)
        } else if indexPath.section == 1 {
            cell.config(type: AddBudgetEventTableViewCellType.description, content: "")
            cell.userDidEndEditingDescriptionTextFieldClosure = { (str) in
                self.addBudgetEventDescriptionValue = str
            }
        } else if indexPath.section == 2 {
            cell.config(type: AddBudgetEventTableViewCellType.cost, content: "")
            cell.userDidEndEditingCostTextFieldClosure = { (int) in
                self.addBudgetEventCostValue = int
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if indexPath.row == 0 {
            let vc = CategoryViewController()
            vc.categoryVCDelegate = self
            vc.userDidSelectCategoyClosure = { (index) in
                //given default value = Food in CategoryViewController
                self.categoryValueString = budgetTitles[index]
                self.addBudgetEventTableView.reloadData()
            }
            self.navigationController?.pushViewController(vc, animated: true)
            vc.userIndex = userDidSelectRowNum
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
        addBudgetEventTableView.reloadData()
        if addBudgetEventCostValue != 0 && addBudgetEventDescriptionValue != "" {
            let event = AddBudgetEventContent(dateString: dateString, categoryValueString: categoryValueString, descriptionValueString: addBudgetEventDescriptionValue, costValueInt: addBudgetEventCostValue)
            addBudgetEventContent.append(event)
            print(addBudgetEventContent)
            if let jsonData = try? JSONEncoder().encode(addBudgetEventContent) {
                do {
                    budgetContentDecodeData = try JSONDecoder().decode([AddBudgetEventContent].self, from: jsonData)
                } catch {
                    print("decoded failed")
                    print("\(error)")
                }
            }
            if let closure = self.saveBudgetEventClosure {
                closure(dateString)
            }
            self.dismiss(animated: true, completion: nil)
        } else {
            self.present(emptyCostAlert, animated: true, completion: nil)
        }
    }
}
