//
//  AddNoteEventViewController.swift
//  CalendarBudget
//
//  Created by ERAY on 2020/12/21.
//

import UIKit
import SnapKit


class AddNoteEventViewController: UIViewController, RepeatViewControllerDelegate, UITextFieldDelegate {
    struct AddNoteEventContent: Codable {
        var descriptionString: String
        var dateString: String
        var timeString: String
        var repeatValueString: String
        

        
        
    }

    private var repeatValueFromRepeatViewController = "Never"
    var repeatViewControllerRowNumber: Int?
    func repeatViewControllerUserIndexRow(row: Int) {
        repeatViewControllerRowNumber = row
    }
    let userDelault = UserDefaults()
    var userPickDate: String?
    var userPickTime: String?
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
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == descriptionInputTextField {
            descriptionUserInputText = textField.text
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func repeatViewControllerDidSelectRow(title: String) {
        
        repeatValueFromRepeatViewController = title
    }
    
    let dateFormatter = DateFormatter()
    let timeFormatter = DateFormatter()
    
    
    lazy var userDatePicker: UIDatePicker = {
        let userDatePicker = UIDatePicker(frame: CGRect.zero)
        userDatePicker.datePickerMode = .dateAndTime
        if #available(iOS 13.4, *) {
            userDatePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        userDatePicker.minuteInterval = 15
        userDatePicker.date = NSDate() as Date
        let userDateFormatter = DateFormatter()
        userDateFormatter.dateFormat = "yyyy-MMM-dd HH:mm"
        let fromDateTime = userDateFormatter.date(from: "2020-Dec-01 18:00")
        userDatePicker.minimumDate = fromDateTime
        let endDateTime = userDateFormatter.date(from: "2024-Dec-01 18:00")
        userDatePicker.maximumDate = endDateTime
        userDatePicker.addTarget(self, action: #selector(datePickerChanged), for: .valueChanged)
        
        return userDatePicker
    }()
    
    
    let addNoteEventTitle = ["Description","Date","Repeat"]
    
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
        dateFormatter.dateFormat = "yyyy-MMM-dd"
        timeFormatter.dateFormat = "HH:mm"
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
            if repeatValueFromRepeatViewController == "Never" {
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
            
            cell.addSubview(userDatePicker)
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

//MARK:- Events
extension AddNoteEventViewController{
    @objc func noteDismiss(sender: UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func datePickerChanged(datePicker:UIDatePicker){
        

        let userPickDate = dateFormatter.string(from: datePicker.date)
        let userPickTime = timeFormatter.string(from: datePicker.date)
        self.userPickDate = userPickDate
        self.userPickTime = userPickTime
    }
    
    @objc func saveEvent(sender: UIButton){
        addNoteEventTableView.reloadData()
        
//        print(descriptionUserInputText)
        
        if let descriptionUserInputText = descriptionUserInputText {
            userDelault.setValue(descriptionUserInputText, forKey: "description")
            print(descriptionUserInputText)
            if let userPickDate = userPickDate, let userPickTime = userPickTime,  repeatValueFromRepeatViewController != "Never" {
                    print(userPickDate)
                    print(userPickTime)
                    print(repeatValueFromRepeatViewController)
                let event: [AddNoteEventContent] = [
                    AddNoteEventContent(descriptionString: descriptionUserInputText, dateString: userPickDate, timeString: userPickTime, repeatValueString: repeatValueFromRepeatViewController)
                ]
                UserDefaults.standard.set(try? PropertyListEncoder().encode(event), forKey: "newEvent")
                    self.dismiss(animated: true, completion: nil)
            } else if userPickDate == nil, repeatValueFromRepeatViewController != "Never" {
                let userPickDefaultDate = dateFormatter.string(from: userDatePicker.date)
                let userPickDefaultTime = timeFormatter.string(from: userDatePicker.date)
                print(userPickDefaultDate)
                print(userPickDefaultTime)
                print(repeatValueFromRepeatViewController)
                let event: [AddNoteEventContent] = [
                    AddNoteEventContent(descriptionString: descriptionUserInputText, dateString: userPickDefaultDate, timeString: userPickDefaultTime, repeatValueString: repeatValueFromRepeatViewController)
                ]
                UserDefaults.standard.set(try? PropertyListEncoder().encode(event), forKey: "newEvent")
                self.dismiss(animated: true, completion: nil)
            } else if let userPickDate = userPickDate, let userPickTime = userPickTime, repeatValueFromRepeatViewController == "Never" {
                print(userPickDate)
                print(userPickTime)
                print(repeatValueFromRepeatViewController)
                let event = AddNoteEventContent(descriptionString: descriptionUserInputText, dateString: userPickDate, timeString: userPickTime, repeatValueString: repeatValueFromRepeatViewController)
                userDelault.setValue(event, forKey: "newEvent")
                self.dismiss(animated: true, completion: nil)
            } else if userPickDate == nil && repeatValueFromRepeatViewController == "Never" {
                let userPickDefaultDate = dateFormatter.string(from: userDatePicker.date)
                let userPickDefaultTime = timeFormatter.string(from: userDatePicker.date)
                print(userPickDefaultDate)
                print(userPickDefaultTime)
                print(repeatValueFromRepeatViewController)
                let event: [AddNoteEventContent] = [
                    AddNoteEventContent(descriptionString: descriptionUserInputText, dateString: userPickDefaultDate, timeString: userPickDefaultTime, repeatValueString: repeatValueFromRepeatViewController)
                ]
                UserDefaults.standard.set(try? PropertyListEncoder().encode(event), forKey: "newEvent")
                self.dismiss(animated: true, completion: nil)
            }
        } else if descriptionUserInputText == nil {
            let addEventAlart = UIAlertController(title: "Oops!", message: "Enter something in Description", preferredStyle: .alert)
            let okAction = UIAlertAction(
                title: "OK", style: .default, handler: nil
            )
            addEventAlart.addAction(okAction)
            self.present(addEventAlart, animated: true, completion: nil)
            
        }
        
        
        
    }
    

}


