//
//  CalendarViewController.swift
//  CalendarBudget
//
//  Created by ERAY on 2020/12/1.
//

import UIKit
import FSCalendar
import SnapKit

class CalendarViewController: UIViewController,FSCalendarDataSource,FSCalendarDelegate {
    
    fileprivate weak var calendar: FSCalendar!
    
    var formatter = DateFormatter()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("calendar vc will appear")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("calendar vc did load")
        self.setupUI()
        let calendar = FSCalendar(frame: CGRect(x: 0, y: 0, width: self.view.frame.maxX, height: 300))
        calendar.dataSource = self
        calendar.delegate = self
        calendar.backgroundColor = UIColor(red: 246/255, green: 216/255, blue: 23/255, alpha: 1)
        calendar.scope = .month
        calendar.appearance.titleFont = UIFont.systemFont(ofSize: 17.0)
        calendar.appearance.headerTitleFont = UIFont.boldSystemFont(ofSize: 20.0)
        calendar.appearance.weekdayFont = UIFont.boldSystemFont(ofSize: 16.0)
        
        calendar.appearance.todayColor = .systemRed
        calendar.appearance.titleTodayColor = .black
        calendar.appearance.titleDefaultColor = .red

        view.addSubview(calendar)
                self.calendar = calendar
        calendar.translatesAutoresizingMaskIntoConstraints = false
            }
    
    override func viewDidLayoutSubviews() {
        calendar.snp.makeConstraints { (make) in

                make.leading.equalToSuperview()
                make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
                make.trailing.equalToSuperview()
                make.bottom.equalToSuperview()
        }

    }
    
//    func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
//        return "This is Title"
//    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        formatter.dateFormat = "dd-MMM-yyy"
        print("\(formatter.string(from: date))")
        let v1 = selectDateView()
        self.present(v1, animated: true) {
            print("success")
        }
    }
    
    
}

//MARK: Private

extension CalendarViewController {
    private func setupUI() {
        let settingButton = UIButton()
        settingButton.setImage(UIImage(named: "cogwheel"), for:.normal)
        settingButton.addTarget(self, action: #selector(settingButtonDidTouchUpInside(sender:)), for: .touchUpInside)
        let rightBarButton = UIBarButtonItem(customView: settingButton)
        let currWidth = rightBarButton.customView?.widthAnchor.constraint(equalToConstant: 24)
            currWidth?.isActive = true
        let currHeight = rightBarButton.customView?.heightAnchor.constraint(equalToConstant: 24)
            currHeight?.isActive = true
        navigationItem.rightBarButtonItem = rightBarButton
        

        
        
    }
    
    @objc private func recortUserButton(){
        print("record user button")
    }
    
}
//MARK: Events
extension CalendarViewController {
    

    
    @objc func settingButtonDidTouchUpInside(sender: UIButton) {
        let settingVC = SettingViewController()
        self.navigationController?.pushViewController(settingVC, animated: true)
    }
    
    @objc func action(sender: UIBarButtonItem) {
        print("button settled")
    }
    
}

//MARK: TableViewDelegate

