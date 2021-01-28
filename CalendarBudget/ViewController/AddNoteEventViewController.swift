//
//  AddNoteEventViewController.swift
//  CalendarBudget
//
//  Created by ERAY on 2020/12/21.
//

import UIKit
import SnapKit

struct AddNoteEventContent: Codable {
    var dateString: String
    var timeString: String
    var description: String
    var repeatValue: String
}

struct UserDefaultsKeys {
    
    struct UserSetting {
        static let account = "user_ac"
        static let password = "user_pw"
    }
    
    struct NoteEvent {
        static let month = "NoteEvent"
    }
}

enum EventMonth {
    case Jan
    case Feb
    case Mar
    case Apr
    case May
    case Jun
    case Jul
    case Aug
    case Sep
    case Oct
    case Nov
    case Dec
    
    var userDefaultKey: String {
        
        let month: String
        switch self {
        case .Jan:
            month = "Jan"
        case .Feb:
            month = "Feb"
        default:
            month = "blah"
        }
        return "\(UserDefaultsKeys.NoteEvent.month)_\(month)"
    }
}
//用法
//EventMonth.Jan.userDefaultKey //NoteEvent_Jan
//EventMonth.Feb.userDefaultKey

let encoder = JSONEncoder()
let decoder = JSONDecoder()

var addNoteEventContents: [AddNoteEventContent] = []
var noteContentDecodeData = [AddNoteEventContent]()

class AddNoteEventViewController: UIViewController, RepeatViewControllerDelegate, UITextFieldDelegate {
    
    public var executeClosure: (()->())?

    private var repeatValueFromRepeatViewController = "Never"
    var repeatViewControllerRowNumber: Int?
    func repeatViewControllerUserIndexRow(row: Int) {
        repeatViewControllerRowNumber = row
    }
    let userDefault = UserDefaults.standard
    
    var selectedPickerDate: String = ""
    var selectedPickerTime: String = ""
    
    private var descriptionUserInputText: String = ""
    
    func repeatViewControllerDidSelectRow(title: String) {
        
        repeatValueFromRepeatViewController = title
    }
    
    lazy var userDatePickerTextField: UITextField = {
        let userDatePickerTextField = UITextField(frame: CGRect.zero)
        userDatePickerTextField.backgroundColor = .clear
        return userDatePickerTextField
    }()
    
    let fullDateFormatter = DateFormatter()
    let dateFormatter = DateFormatter()
    let timeFormatter = DateFormatter()
    
    let addNoteEventTitle = ["Description","Date","Repeat"]
    
    lazy var addNoteEventTableView: UITableView = {
        let addNoteEventTableView = UITableView()
        addNoteEventTableView.backgroundColor = .groupTableViewBackground
        addNoteEventTableView.delegate = self
        addNoteEventTableView.dataSource = self
        addNoteEventTableView.register(AddNoteEventTableViewCell.self, forCellReuseIdentifier: AddNoteEventTableViewCell.identifier)
        addNoteEventTableView.isScrollEnabled = true
        addNoteEventTableView.tableFooterView = UIView()
        return addNoteEventTableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        fullDateFormatter.dateFormat = "yyyy-MMM-dd HH:mm"
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
//        userDatePickerTextField.inputView = self.userDatePicker
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
            //y
            make.top.equalToSuperview().offset(70)
            make.bottom.equalTo(saveButton.snp.top)
            //x
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
        }
        saveButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-24)
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
        super.viewWillDisappear(true)
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
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 60
//    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView.init(frame: CGRect.zero)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AddNoteEventTableViewCell.identifier, for: indexPath) as? AddNoteEventTableViewCell else {
            return AddNoteEventTableViewCell(style: .subtitle, reuseIdentifier: AddNoteEventTableViewCell.identifier)
        }
        
        if indexPath.section == 0 {
            cell.config(type: AddNoteEventTableViewCellType.textfield)
            cell.descriptionEndEditingClosure = { (str) in
                self.descriptionUserInputText = str
            }
        } else if indexPath.section == 1 {
            cell.userPickDateClosure = { (dateStr, timeStr) in
                self.selectedPickerDate = dateStr
                self.selectedPickerTime = timeStr
            }
            cell.config(type: AddNoteEventTableViewCellType.datePicker)


        } else if indexPath.section == 2 {
            cell.config(type: AddNoteEventTableViewCellType.repeatValue)
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            becomeFirstResponder()
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
extension AddNoteEventViewController {
    
    @objc func noteDismiss(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func saveEvent(sender: UIButton) {
        
        addNoteEventTableView.reloadData()
        
        
        if descriptionUserInputText != "" {//TODO: cell refactor
            
            if repeatValueFromRepeatViewController != "Never" {
                
                let event = AddNoteEventContent(dateString: self.selectedPickerDate, timeString: self.selectedPickerTime, description: descriptionUserInputText, repeatValue: repeatValueFromRepeatViewController)
                addNoteEventContents.append(event)
                print(addNoteEventContents)
                if let jsonData = try? encoder.encode(addNoteEventContents) {
//                    let jsonString = String(data: jsonData, encoding: .utf8)
                    do {
                        noteContentDecodeData = try decoder.decode([AddNoteEventContent].self, from: jsonData)
                        print(noteContentDecodeData[0].dateString)
                    } catch {
                        print("decoded failed")
                        print("\(error)")
                    }
                }
                self.dismiss(animated: true, completion: nil)
            } else {
              
                let event = AddNoteEventContent(dateString: selectedPickerDate, timeString: selectedPickerTime, description: descriptionUserInputText, repeatValue: repeatValueFromRepeatViewController)
                addNoteEventContents.append(event)
                print(addNoteEventContents)
                if let jsonData = try? encoder.encode(addNoteEventContents) {
//                    let jsonString = String(data: jsonData, encoding: .utf8)
                    do {
                        noteContentDecodeData = try decoder.decode([AddNoteEventContent].self, from: jsonData)
                        print(noteContentDecodeData[0].dateString)
                    } catch {
                        print("decoded failed")
                        print("\(error)")
                    }
                }
                self.dismiss(animated: true, completion: nil)
            }
        } else {// descriptionUserInputText == ""
            let addEventAlart = UIAlertController(title: "Oops!", message: "Enter something in Description", preferredStyle: .alert)
            let okAction = UIAlertAction(
                title: "OK", style: .default, handler: nil
            )
            addEventAlart.addAction(okAction)
            self.present(addEventAlart, animated: true, completion: nil)
            
        }

        
        if let closure = self.executeClosure {
            closure()
        }
        
    }
    

}


