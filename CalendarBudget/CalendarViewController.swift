//
//  CalendarViewController.swift
//  CalendarBudget
//
//  Created by ERAY on 2020/12/1.
//

import UIKit
import FSCalendar
import SnapKit
import FSPagerView

class CalendarViewController: UIViewController,FSCalendarDataSource,FSCalendarDelegate {
    
    fileprivate weak var calendar: FSCalendar!
    fileprivate weak var yellowBlock: UIView!
    fileprivate var fillBlankView: UIView = UIView()
    
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
        calendar.appearance.titleFont = UIFont.systemFont(ofSize: 20.0)
        calendar.appearance.headerTitleFont = UIFont.boldSystemFont(ofSize: 16.0)
        calendar.appearance.weekdayFont = UIFont.boldSystemFont(ofSize: 20.0)
        
        calendar.appearance.todayColor = .systemRed
        calendar.appearance.titleTodayColor = .black
        calendar.appearance.titleDefaultColor = .red
        view.addSubview(calendar)
        
        fillBlankView.backgroundColor = UIColor(red: 246/255, green: 216/255, blue: 23/255, alpha: 1)
        view.addSubview(fillBlankView)

                
        
        
        
        self.calendar = calendar
        
        let yellowBlock = UIView()
        view.addSubview(yellowBlock)
        yellowBlock.backgroundColor = UIColor.groupTableViewBackground
        yellowBlock.translatesAutoresizingMaskIntoConstraints = false
        self.yellowBlock = yellowBlock
        
        
        

      

        
        
        calendar.snp.makeConstraints { (make) in

            make.leading.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.trailing.equalToSuperview()
            make.height.equalTo(self.view).dividedBy(3)
        }
        
        fillBlankView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(calendar.snp.bottom)
            make.bottom.equalTo(yellowBlock.snp.top)
        }
        
        yellowBlock.snp.makeConstraints { (make) in
            make.top.equalTo(calendar.safeAreaLayoutGuide.snp.bottom).offset(50)
            make.height.equalTo(calendar).dividedBy(2)
            make.width.equalToSuperview()
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        self.applyCurvedPath(givenView: yellowBlock,curvedPercent: 0.2)
    }
    
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
        self.view.backgroundColor = .groupTableViewBackground
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
    
    func pathCurvedForView(givenView: UIView, curvedPercent:CGFloat) ->UIBezierPath
        {
            let arrowPath = UIBezierPath()
            
            arrowPath.move(to: CGPoint(x:0, y:0))
            arrowPath.addLine(to: CGPoint(x:givenView.bounds.size.width, y:0))
            arrowPath.addQuadCurve(to: CGPoint(x:0, y:0), controlPoint: CGPoint(x:givenView.bounds.size.width/2, y:givenView.bounds.size.height*curvedPercent-givenView.bounds.size.height))
            arrowPath.addLine(to: CGPoint(x:0, y:0))
            arrowPath.close()
            UIColor.red.setFill()
            
            return arrowPath
        }

    func applyCurvedPath(givenView: UIView,curvedPercent:CGFloat) {
        guard curvedPercent <= 1 && curvedPercent >= 0 else{
            return
        }
        let shapeLayer = CAShapeLayer(layer: givenView.layer)
        shapeLayer.backgroundColor = UIColor.groupTableViewBackground.cgColor
        shapeLayer.path = self.pathCurvedForView(givenView: givenView,curvedPercent: curvedPercent).cgPath
        shapeLayer.frame = givenView.bounds
        shapeLayer.masksToBounds = false
        givenView.layer.backgroundColor = UIColor.groupTableViewBackground.cgColor
        shapeLayer.fillColor = UIColor.groupTableViewBackground.cgColor
        givenView.layer.addSublayer(shapeLayer)
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

