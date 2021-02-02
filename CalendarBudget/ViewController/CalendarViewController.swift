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
    var executeClosureFromCalendarVC: ((String)->())?
    var userSelectDate: String = ""
    var calendarVCDate: String = "" {
        didSet {
            if let closure = self.executeClosureFromCalendarVC {
                closure(calendarVCDate)
            }
        }
    }
    var calendar: FSCalendar!
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
        calendar.appearance.eventDefaultColor = .black
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

