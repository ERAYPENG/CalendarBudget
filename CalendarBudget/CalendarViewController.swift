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
//    fileprivate weak var pagerView: FSPagerView!
//    fileprivate weak var pageControl: FSPageControl!
    fileprivate let imageNames = ["noteIcon","budgetIcon"]
    fileprivate var numberOfItems = 2
    
    lazy var pagerView: FSPagerView = {
        let pagerView = FSPagerView()
        pagerView.dataSource = self
        pagerView.delegate = self
//        pagerView.automaticSlidingInterval = 1
        pagerView.isInfinite = false
        pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "Cell")
//        pagerView.itemSize = FSPagerView.automaticSize
        pagerView.transformer = FSPagerViewTransformer(type: .ferrisWheel)
        print("pagerview set")
        return pagerView
    }()
    
    lazy var pageControl: FSPageControl = {
        let pageControl = FSPageControl()
        pageControl.numberOfPages = imageNames.count
        pageControl.contentHorizontalAlignment = .right
        pageControl.contentInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        pageControl.currentPage = 1
        print("pagecontrol set")
        return pageControl
    }()
    
    lazy var noteTableView: UITableView = {
        let noteTableView = UITableView()
        return noteTableView
    }()
    
    
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
        
        
        
        

        
        self.view.addSubview(pagerView)
        self.view.addSubview(pageControl)
        
        let addButtonView = UIImage(named: "addButton")
        let addButton = UIButton()
        addButton.setImage(addButtonView, for: .normal)
        view.addSubview(addButton)
//        let pageControl = FSPageControl()
//        self.view.addSubview(pageControl)
        
        


      

        
        
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
        pagerView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(200)
        }
        pageControl.snp.makeConstraints { (make) in
            make.width.equalTo(80)
            make.height.equalTo(30)
            make.bottom.equalTo(pagerView.snp.bottom).offset(0)
            make.centerX.equalTo(pagerView)
        }
        addButton.snp.makeConstraints { (make) in
            make.top.equalTo(calendar.snp.bottom)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(60)
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

extension CalendarViewController:FSPagerViewDelegate,FSPagerViewDataSource{
    //MARK:- FSPagerView Datasource
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return numberOfItems
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "Cell", at: index)
        cell.imageView?.image = UIImage(named: self.imageNames[index])
        cell.imageView?.backgroundColor = .clear
        cell.imageView?.contentMode = .redraw
        cell.imageView?.clipsToBounds = true
//        cell.textLabel?.text = index.description+index.description
        cell.imageView?.snp.makeConstraints({ (make) in
            make.center.equalToSuperview()
            make.height.width.equalTo(80)
        })

        
        return cell
    }
    // MARK:- FSPagerView Delegate
    func pagerView(_ pagerView: FSPagerView, willDisplay cell: FSPagerViewCell, forItemAt index: Int) {
        pageControl.currentPage = index
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
        pagerView.scrollToItem(at: index, animated: true)
    }
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        pageControl.currentPage = targetIndex
    }
    
    
    func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView) {
        pageControl.currentPage = pagerView.currentIndex
    }
}

//MARK:- UITableView
extension CalendarViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
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

