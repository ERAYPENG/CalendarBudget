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
    var calendarVCDate: String = "" {
        didSet {
            print(calendarVCDate)

            if let closure = self.executeClosureFromCalendarVC {
                print("OK")
                closure(calendarVCDate)
            } else {
                print("ERROR")
            }
        }
    }
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

        MainViewController().noteTableView.reloadData()

        dateFormatter.dateFormat = "yyyy-MMM-dd"
        calendarVCDate = dateFormatter.string(from: date)
        
    }
    


}

