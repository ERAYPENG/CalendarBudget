//
//  CalendarViewController.swift
//  CalendarBudget
//
//  Created by ERAY on 2021/1/18.
//

import UIKit
import FSCalendar
import SnapKit
import Firebase

class CalendarViewController: BaseViewController, FSCalendarDataSource, FSCalendarDelegate {
    let userDefault = UserDefaults()
    var executeClosureFromCalendarVC: ((String)->())?
    var userSelectDate: String = ""
    var calendarVCDate: String = "" {
        didSet {
            if let closure = self.executeClosureFromCalendarVC {
                closure(calendarVCDate)
            }
        }
    }
    
    var birthday: String = ""
    var calendarMonth: String = ""
    var calendar: FSCalendar!
    let dateFormatter = DateFormatter()
    var birthdayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMdd"
        return formatter
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateFormat = "yyyy-MMM-dd"
        let calendar = FSCalendar()
        calendar.dataSource = self
        calendar.delegate = self
        calendar.backgroundColor = .hex("cbc0a5")
        calendar.scope = .month
        
//        calendar.appearance.headerTitleFont = UIFont(name: "System-Bold", size: 18)
        calendar.appearance.headerTitleFont = UIFont.boldSystemFont(ofSize: 18)
//        calendar.appearance.weekdayFont = UIFont(name: "System-Bold", size: 17)
        calendar.appearance.weekdayFont = UIFont.boldSystemFont(ofSize: 17)
        
        calendar.appearance.titleFont = UIFont(name: "Futura-Medium", size: 16)
        
        calendar.appearance.weekdayTextColor = .hex("9f3849")
        calendar.appearance.headerTitleColor = .hex("9f3849")
        
        calendar.appearance.titleDefaultColor = .hex("667e95")
        
        calendar.appearance.titlePlaceholderColor = .hex("e1e5e8")
        
        //Today
        calendar.appearance.todayColor = .hex("1576d7")
        calendar.appearance.eventDefaultColor = .hex("fd7f59")
        
        calendar.appearance.titleTodayColor = .hex("e1e5e8")
        
        //Select
        calendar.appearance.selectionColor = .hex("fd7f59")

        if let today = calendar.today {
            calendarVCDate = dateFormatter.string(from: today)
        }
        
        
        

        self.view.addSubview(calendar)
        
        self.calendar = calendar
        
        calendar.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.trailing.equalToSuperview()
            make.height.equalToSuperview()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getUserBirthday()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        calendarVCDate = dateFormatter.string(from: date)
        MainViewController().noteTableView.reloadData()
        MainViewController().budgetTableView.reloadData()
        dateFormatter.dateFormat = "yyyy-MMM-dd"
        calendarVCDate = dateFormatter.string(from: date)
        
    }
    

    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let dateString = dateFormatter.string(from: date)
        if noteContentDecodeData.contains(where: {$0.dateString == dateString}) {
            return 1
        } else {
            return 0
        }
    }
    
    
    
    
}

struct User {
    let userName: String
    let birthday: String
    let email: String
}


extension CalendarViewController: FSCalendarDelegateAppearance {
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        let dateString = birthdayFormatter.string(from: date)
        self.birthday = userDefault.value(forKey: "birthday") as! String
        
        let year = birthday.index(birthday.startIndex, offsetBy: 4)
        let birthdayWithoutYear = String(birthday.suffix(from: year))
        
        if dateString == birthdayWithoutYear {
            return .red
        } else {
            return nil
        }
    }
}

extension CalendarViewController {
    
    public func getUserBirthday() {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("ProfileSetting").child(uid)
        
        FirebaseManager.shared.getDataSnapshot(ref: ref) { (result) in
            switch result {
            
            case .success(let snapShot):
                
                guard let userData = snapShot.value as? [String: Any] else {return}
                
                guard let birthday = userData["birthday"] as? String,
                      let userName = userData["userName"] as? String,
                      let email = userData["email"] as? String
                else { return }
                
                let user = User(userName: userName, birthday: birthday, email: email)
                
//                self.birthday = user.birthday
                
                self.userDefault.setValue(user.birthday, forKey: "birthday")
            case .error(_):
                
                break
            }
        }
    }
}

