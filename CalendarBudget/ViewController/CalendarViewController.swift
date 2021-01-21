//
//  CalendarViewController.swift
//  CalendarBudget
//
//  Created by ERAY on 2021/1/18.
//

import UIKit
import FSCalendar
import SnapKit



class CalendarViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate {
    public var executeClosure: ((String)->(String))?
    var dateStringFromCalendarVC: String = ""
    fileprivate weak var calendar: FSCalendar!
    let dateFormatter = DateFormatter()
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateFormat = "yyyy-MMM-dd"
        let calendar = FSCalendar()
        calendar.dataSource = self
        calendar.delegate = self
        calendar.backgroundColor = UIColor(red: 246/255, green: 216/255, blue: 23/255, alpha: 1)
        calendar.scope = .month
        calendar.appearance.titleFont = UIFont.systemFont(ofSize: 20.0)
        calendar.appearance.headerTitleFont = UIFont.boldSystemFont(ofSize: 16.0)
        calendar.appearance.weekdayFont = UIFont.boldSystemFont(ofSize: 20.0)
        calendar.appearance.todayColor = .systemRed
        calendar.appearance.titleTodayColor = .black
        calendar.appearance.titleDefaultColor = .red
        if let today = calendar.today {
            dateStringFromCalendarVC = dateFormatter.string(from: today)
            if let closure = executeClosure {
                print("OK")
                if let today = calendar.today {
                    dateStringFromCalendarVC = dateFormatter.string(from: today)
                    closure(dateStringFromCalendarVC)
                }
            }
        }
        print(dateStringFromCalendarVC)
        if let closure = executeClosure {
            print("OK")
            if let today = calendar.today {
                dateStringFromCalendarVC = dateFormatter.string(from: today)
                closure(dateStringFromCalendarVC)
            }
//            closure(dateStringFromCalendarVC)
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
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
//        self.noteTableView.reloadData()
        MainViewController().noteTableView.reloadData()

        dateFormatter.dateFormat = "yyyy-MMM-dd"
        let selectDate = dateFormatter.string(from: date)
        print(selectDate)
        dateStringFromCalendarVC = dateFormatter.string(from: date)
        
//        self.reloadAllTableViews()
//        if dateStringFromCalendarVC == decodeData[0].dateString {
//
//            print("decode success")
//        }
        
//        self.calendar = calendar
        
    }
    


}
