//
//  ViewController.swift
//  CalendarBudget
//
//  Created by ERAY on 2020/12/1.
//

import UIKit
import FSCalendar
import SnapKit

class ViewController: UIViewController,FSCalendarDataSource,FSCalendarDelegate {
    fileprivate weak var calendar: FSCalendar!
    var formatter = DateFormatter()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        navBar.backgroundColor = .gray
        view.addSubview(navBar)
        navBar.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(50)
        }
        let settingButton = UIBarButtonItem.init(barButtonSystemItem: .camera, target: self, action: #selector(self.action(sender:)))
        self.navigationItem.rightBarButtonItem = settingButton
               
        
        
        
        let calendar = FSCalendar(frame: CGRect(x: 0, y: 0, width: self.view.frame.maxX, height: 300))
        calendar.dataSource = self
        calendar.delegate = self
        calendar.scope = .month
        view.addSubview(calendar)
        calendar.backgroundColor = UIColor(red: 246/255, green: 216/255, blue: 23/255, alpha: 1)
        calendar.appearance.titleFont = UIFont.systemFont(ofSize: 17.0)
        calendar.appearance.headerTitleFont = UIFont.boldSystemFont(ofSize: 20.0)
        calendar.appearance.weekdayFont = UIFont.boldSystemFont(ofSize: 16.0)
        
        calendar.appearance.todayColor = .systemRed
        calendar.appearance.titleTodayColor = .black
        calendar.appearance.titleDefaultColor = .red
        self.calendar = calendar
        calendar.translatesAutoresizingMaskIntoConstraints = false
        calendar.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *){
                make.leading.equalToSuperview()
//                make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
                make.top.equalTo(navBar.safeAreaLayoutGuide.snp.bottom)
                make.trailing.equalToSuperview()
                make.bottom.equalToSuperview()
            }}

        
        
        
}

    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        formatter.dateFormat = "dd-MMM-yyy"
        print("\(formatter.string(from: date))")
        let v1 = selectDateView()
        self.present(v1, animated: true) {
            print("success")
        }
    }
    @objc func action(sender: UIBarButtonItem) {
        print("button settled")
    }
}
