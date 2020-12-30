//
//  AddNoteEventViewController.swift
//  CalendarBudget
//
//  Created by ERAY on 2020/12/21.
//

import UIKit
import SnapKit




class AddNoteEventViewController: UIViewController, RepeatViewControllerDelegate, UITextFieldDelegate {
    private var repeatValueFromRepeatViewController: String?
    var repeatViewControllerRowNumber: Int?
    let userDelault = UserDefaults()
    lazy var descriptionInputTextField: UITextField = {
        let descriptionInputTextField = UITextField()
        descriptionInputTextField.delegate = self
        descriptionInputTextField.clearButtonMode = .whileEditing
        descriptionInputTextField.keyboardType = .default
        descriptionInputTextField.returnKeyType = .done
        descriptionInputTextField.backgroundColor = .clear
        descriptionInputTextField.placeholder = "Enter text here"
        
        return descriptionInputTextField
    }()
    var descriptionUserInputText: String?
    func repeatViewControllerDidSelectRow(title: String) {
        
        repeatValueFromRepeatViewController = title
    }
    
    func repeatViewControllerUserIndexRow(row: Int) {
        repeatViewControllerRowNumber = row
    }
    
    let addNoteEventTitle = ["Description","Date","Repeat"]
    let dateLabel: UILabel? = nil
    lazy var addNoteEventTableView: UITableView = {
        let addNoteEventTableView = UITableView()
        addNoteEventTableView.backgroundColor = .groupTableViewBackground
        addNoteEventTableView.delegate = self
        addNoteEventTableView.dataSource = self
        addNoteEventTableView.register(UITableViewCell.self, forCellReuseIdentifier: "addNoteCell")
        addNoteEventTableView.isScrollEnabled = true
        addNoteEventTableView.tableFooterView = UIView()
        return addNoteEventTableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .groupTableViewBackground
        let finishButton = UIButton(frame: CGRect.zero)
        finishButton.backgroundColor = .groupTableViewBackground
        finishButton.setTitle("Cancel", for: .normal)
        finishButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        finishButton.setTitleColor(.systemBlue, for: .normal)
        finishButton.addTarget(self, action: #selector(noteDismiss), for: .touchUpInside)
        
        let saveButton = UIButton()
        saveButton.backgroundColor = .gray
        saveButton.setTitle("Save", for: .normal)
        saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.layer.cornerRadius = 20
        saveButton.layer.borderColor = UIColor.lightGray.cgColor
        saveButton.layer.borderWidth = 5.0
        saveButton.addTarget(self, action: #selector(saveEvent), for: .touchUpInside)
        
        view.addSubview(finishButton)
        view.addSubview(addNoteEventTableView)
        view.addSubview(saveButton)
        
        
        
        

        
        
        
        
//MARK:- AutoLayout
        finishButton.snp.makeConstraints { (make) in
            make.trailing.equalTo(self.view)
            make.top.equalTo(self.view).offset(10)
            make.width.equalTo(100)
            make.height.equalTo(50)
        }
        addNoteEventTableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(70)
            make.width.equalToSuperview()
            make.bottom.equalToSuperview().dividedBy(2)
        }
        saveButton.snp.makeConstraints { (make) in
            make.top.equalTo(addNoteEventTableView.snp.bottom)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().dividedBy(2)
            make.height.equalTo(60)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        let repeatRowIndexPath = NSIndexPath(row: 0, section: 2)
        if let cell = addNoteEventTableView.cellForRow(at: repeatRowIndexPath as IndexPath) {
            if repeatValueFromRepeatViewController == nil {
                cell.textLabel?.text = "Never"
            } else {
                cell.textLabel?.text = repeatValueFromRepeatViewController
                
            }
            
        }

        print("add note view appear")
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        
        print("add note view disappear")
    }
    

    

}
//MARK:- UITableView
extension AddNoteEventViewController:UITableViewDataSource, UITableViewDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == descriptionInputTextField {
            descriptionUserInputText = textField.text
        }
        
        print(descriptionUserInputText)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return addNoteEventTitle.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView.init(frame: CGRect.zero)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addNoteCell", for: indexPath)
        cell.backgroundColor = UIColor(red: 216/255, green: 223/255, blue: 221/255, alpha: 1)
        if indexPath.section == 0{
            

            
            cell.addSubview(self.descriptionInputTextField)
            
            descriptionInputTextField.snp.makeConstraints { (make) in
                make.leading.equalToSuperview().offset(20)
                make.trailing.equalToSuperview()
                make.top.equalTo(cell.snp.top).offset(5)
                make.bottom.equalTo(cell.snp.bottom).offset(-5)
            }
        } else if indexPath.section == 1 {
            let dateLabel = UILabel(frame: CGRect.zero)
            dateLabel.backgroundColor = .clear
            dateLabel.textAlignment = .center
            dateLabel.textColor = .black
            let userDatePicker = UIDatePicker(frame: CGRect.zero)
            userDatePicker.datePickerMode = .dateAndTime
            userDatePicker.minuteInterval = 15
            userDatePicker.date = NSDate() as Date
            let userDateFormatter = DateFormatter()
            userDateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            let fromDateTime = userDateFormatter.date(from: "2020-12-01 18:00")
            userDatePicker.minimumDate = fromDateTime
            let endDateTime = userDateFormatter.date(from: "2024-12-01 18:00")
            userDatePicker.maximumDate = endDateTime
            userDatePicker.addTarget(self, action: #selector(datePickerChanged), for: .valueChanged)
            
//            dateLabel.text = userDateFormatter.string(from: userDatePicker.date)
            
            

            cell.addSubview(userDatePicker)
            cell.addSubview(dateLabel)
            
            dateLabel.snp.makeConstraints { (make) in
                make.leading.equalToSuperview().offset(20)
                make.top.equalTo(cell.snp.top).offset(5)
                make.bottom.equalTo(cell.snp.bottom).offset(-5)
            }
            userDatePicker.snp.makeConstraints { (make) in
                make.leading.equalToSuperview().offset(20)
                make.top.equalTo(cell.snp.top).offset(5)
                make.bottom.equalTo(cell.snp.bottom).offset(-5)
            }

        } else if indexPath.section == 2 {
            cell.accessoryType = .disclosureIndicator

            cell.textLabel?.text = "Never"
            
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
     
        } else if indexPath.section == 1 {
            
        } else if indexPath.section == 2 {
            let repeatVC = RepeatViewController()
            repeatVC.repeatViewDelegate = self
            repeatVC.userSelectIndex = repeatViewControllerRowNumber
            self.navigationController?.pushViewController(repeatVC, animated: true)
        }
    }

    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return addNoteEventTitle[section]
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let noteHeaderLabel = UILabel()
        noteHeaderLabel.font = UIFont.systemFont(ofSize: 30)
        noteHeaderLabel.text = self.tableView(addNoteEventTableView, titleForHeaderInSection: section)
        
        let noteHeaderView = UIView()
        noteHeaderView.backgroundColor = UIColor(red: 230/255, green: 218/255, blue: 196/255, alpha: 1)
        noteHeaderView.addSubview(noteHeaderLabel)
        noteHeaderLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(noteHeaderView).offset(20)
            make.height.equalTo(noteHeaderView)
            
        }
        return noteHeaderView
    }
    
    
    
    
}

//MARK:- Send Value From RepeatView

//MARK:- Events
extension AddNoteEventViewController{
    @objc func noteDismiss(sender: UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func datePickerChanged(datePicker:UIDatePicker){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"

        let userPickDate = formatter.string(from: datePicker.date)
    }
    
    @objc func saveEvent(sender: UIButton){
        addNoteEventTableView.reloadData()
        userDelault.setValue(descriptionUserInputText, forKey: "description text")
//        print(descriptionUserInputText)
        print(descriptionUserInputText)
        
        self.dismiss(animated: true, completion: nil)
    }
    

}


