//
//  AddNoteEventTableViewCell.swift
//  CalendarBudget
//
//  Created by ERAY on 2021/1/23.
//

import UIKit

enum AddNoteEventTableViewCellType {
    case textfield
    case datePicker
    case repeatValue
}

class AddNoteEventTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    //bomi
    var descriptionEndEditingClosure: ((String)->())?
    var userPickDateClosure: ((String, String)->())?
    private var slotView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    //repeat
    private var repeatTitleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    //date picker
    var userPickDate: String?
    var userPickTime: String?
    var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MMM-dd"
        return formatter
        
    }()
    var timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()

    //eray
    public static var identifier: String = "AddNoteEventTableViewCell"
    
    public static var descriptionIdentifier: String = "AddNoteEventTableViewDescriptionCell"
    public static var dateIdentifier: String = "AddNoteEventTableViewDateCell"
    public static var repeatIdentifier: String = "AddNoteEventTableViewRepeatCell"
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
    
    lazy var userDatePicker: UIDatePicker = {
        let userDatePicker = UIDatePicker(frame: CGRect.zero)
        userDatePicker.datePickerMode = .dateAndTime
        if #available(iOS 13.4, *) {
            userDatePicker.preferredDatePickerStyle = .compact
            userDatePicker.sizeToFit()
        } else {
            // Fallback on earlier versions
        }
        userDatePicker.minuteInterval = 15
        userDatePicker.date = NSDate() as Date // 預設值：現在
        let userDateFormatter = DateFormatter()
        userDateFormatter.dateFormat = "yyyy-MMM-dd HH:mm"
        let fromDateTime = userDateFormatter.date(from: "2021-Jan-01 00:00")
        userDatePicker.minimumDate = fromDateTime
        let endDateTime = userDateFormatter.date(from: "2024-Dec-01 18:00")
        userDatePicker.maximumDate = endDateTime
        userDatePicker.addTarget(self, action: #selector(userDatePickerValueChanged), for: .valueChanged)
        return userDatePicker
    }()
    
    private var descriptionUserInputText: String = ""
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == descriptionInputTextField {
            descriptionUserInputText = textField.text ?? ""
            if let closure = self.descriptionEndEditingClosure {
                closure(descriptionUserInputText)
            }
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
        return true
    }
    
    init(repeatTitle: String, style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.repeatTitleLabel.text = repeatTitle
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func config(type: AddNoteEventTableViewCellType) {
        switch type {
        case .textfield:
            self.slotView.addSubview(self.descriptionInputTextField)
            self.descriptionInputTextField.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
                make.height.equalTo(44)
            }
            return
            
        case .datePicker:
            self.slotView.addSubview(self.userDatePicker)
            self.userDatePicker.snp.makeConstraints { (make) in
                make.leading.top.bottom.equalToSuperview()
                make.height.equalTo(44)
            }
            self.sendPickerValue(from: self.userDatePicker)
            return
            
        case .repeatValue:
            
            self.accessoryType = .disclosureIndicator
            
            self.repeatTitleLabel.text = "Never"
            
            self.slotView.addSubview(self.repeatTitleLabel)
            self.repeatTitleLabel.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
                make.height.equalTo(44)
            }
//            self.textLabel?.text = "Never"
        }
    }
}

//MARK: Private
extension AddNoteEventTableViewCell {
    
    private func setupUI() {
        self.backgroundColor = UIColor(red: 216/255, green: 223/255, blue: 221/255, alpha: 1)
        self.contentView.addSubview(self.slotView)
        
        self.slotView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview().inset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
}
//MARK:- Event
extension AddNoteEventTableViewCell {
    
    @objc func userDatePickerValueChanged(datePicker: UIDatePicker) {
        self.sendPickerValue(from: datePicker)
    }
    
    private func sendPickerValue(from datePicker: UIDatePicker) {
        userPickDate = dateFormatter.string(from: datePicker.date)
        userPickTime = timeFormatter.string(from: datePicker.date)
        if let closure = self.userPickDateClosure {
            closure(userPickDate ?? "", userPickTime ?? "")
        }
    }
    
}
