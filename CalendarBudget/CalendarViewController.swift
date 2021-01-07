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
    lazy var eventLabel: UILabel = {
        let eventLabel = UILabel()
        return eventLabel
    }()
    
    fileprivate weak var calendar: FSCalendar!
    fileprivate weak var yellowBlock: UIView!
    fileprivate var fillBlankView: UIView = UIView()
    fileprivate let imageNames = ["noteIcon","budgetIcon"]
    fileprivate var numberOfItems = 2
    fileprivate var budgetSectionTitle = ["Food", "Clothing", "Housing", "Transportation", "Education", "Entertainment"]
    fileprivate var addEventDescription: String?
    fileprivate var addEventDate: String?
    fileprivate var addEventTime: String?
    fileprivate var addEventRepeatValue: String?
    let dateFormatter = DateFormatter()
    let timeFormatter = DateFormatter()
    lazy var pagerView: FSPagerView = {
        let pagerView = FSPagerView()
        pagerView.dataSource = self
        pagerView.delegate = self
        pagerView.isInfinite = false
        pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "Cell")
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
        noteTableView.backgroundColor = .groupTableViewBackground
        noteTableView.dataSource = self
        noteTableView.delegate = self
        noteTableView.register(UITableViewCell.self, forCellReuseIdentifier: "CustomNote")
        return noteTableView
    }()
    
    lazy var budgetTableView: UITableView = {
        let budgetTableView = UITableView()
        budgetTableView.backgroundColor = .groupTableViewBackground
        budgetTableView.dataSource = self
        budgetTableView.delegate = self
        budgetTableView.register(UITableViewCell.self, forCellReuseIdentifier: "CustomBudget")
        return budgetTableView
    }()
    
    let addButtonView = UIImage(named: "addButton")
    lazy var addNoteButton: UIButton = {
        let addNoteButton = UIButton()
        addNoteButton.setImage(addButtonView, for: .normal)
        addNoteButton.addTarget(self, action: #selector(addNoteEvent), for: .touchUpInside)
        return addNoteButton
    }()
    
    lazy var addBudgetButton: UIButton = {
        let addBudgetButton = UIButton()
        addBudgetButton.setImage(addButtonView, for: .normal)
        addBudgetButton.addTarget(self, action: #selector(addBudgetEvent), for: .touchUpInside)
        return addBudgetButton
    }()
    
    
//    var formatter = DateFormatter()
    
    
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
        view.addSubview(addNoteButton)
        view.addSubview(addBudgetButton)
        view.addSubview(noteTableView)
        view.addSubview(budgetTableView)
        budgetTableView.isHidden = true
        addBudgetButton.isHidden = true
        

//        if let addEventContent = UserDefaults.standard.value(forKey: "description") as? String {
//            addEventDescription = addEventContent
//        }
//
//        if let addEventDateContent = UserDefaults.standard.value(forKey: "date") as? String {
//            addEventDate = addEventDateContent
//        }
//
//        if let addEventTimeContent = UserDefaults.standard.value(forKey: "time") as? String {
//            addEventTime = addEventTimeContent
//        }
//
//        if let addEventRepeatValueContent = UserDefaults.standard.value(forKey: "repeatValue") as? String {
//            addEventRepeatValue = addEventRepeatValueContent
//        }
        

        
//MARK:- AutoLayout
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
        addNoteButton.snp.makeConstraints { (make) in
            make.top.equalTo(calendar.snp.bottom).offset(-10)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(60)
        }
        addBudgetButton.snp.makeConstraints { (make) in
            make.top.equalTo(calendar.snp.bottom).offset(-10)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(60)
        }

        noteTableView.snp.makeConstraints { (make) in
            make.top.equalTo(yellowBlock.snp.top)
            make.width.equalToSuperview()
            make.bottom.equalTo(pagerView.snp.top)
        }
        budgetTableView.snp.makeConstraints { (make) in
            make.top.equalTo(yellowBlock.snp.top)
            make.width.equalToSuperview()
            make.bottom.equalTo(pagerView.snp.top)
        }
}
    
    
    override func viewDidLayoutSubviews() {
        self.applyCurvedPath(givenView: yellowBlock,curvedPercent: 0.2)
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        dateFormatter.dateFormat = "yyyy-MMM-dd"
//        let calenderUserPickDate = dateFormatter.string(from: date)
//        if calenderUserPickDate == addEventDate {
//
//        }
        print("\(dateFormatter.string(from: date))")
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
//            UIColor.red.setFill()
            
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

extension CalendarViewController: FSPagerViewDelegate,FSPagerViewDataSource{
    //MARK:- FSPagerView Datasource
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return numberOfItems
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "Cell", at: index)
        cell.imageView?.image = UIImage(named: self.imageNames[index])
        cell.imageView?.backgroundColor = .clear
        cell.imageView?.contentMode = .scaleAspectFill
        cell.imageView?.clipsToBounds = true
        if index == 0{
            cell.textLabel?.text = "Note"
        }else if index == 1{
            cell.textLabel?.text = "Budget"
        }
        cell.textLabel?.textColor = .black
        cell.textLabel?.font = UIFont.systemFont(ofSize: 30)
        cell.textLabel?.backgroundColor = .clear
        cell.textLabel?.superview?.backgroundColor = .clear
        cell.imageView?.snp.makeConstraints({ (make) in
            make.center.equalToSuperview()
            make.height.width.equalTo(80)
        })
        cell.textLabel?.snp.makeConstraints({ (make) in
            make.centerX.equalToSuperview()
            
        })

        
        return cell
    }
    // MARK:- FSPagerView Delegate
    func pagerView(_ pagerView: FSPagerView, willDisplay cell: FSPagerViewCell, forItemAt index: Int) {
        
        pageControl.currentPage = index
      
        

    }
    
    func pagerView(_ pagerView: FSPagerView, shouldSelectItemAt index: Int) -> Bool {
        return false
    }
    
   
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        pageControl.currentPage = targetIndex
        switch pageControl.currentPage {
        case 0:
            noteTableView.isHidden = false
            addNoteButton.isHidden = false
            budgetTableView.isHidden = true
            addBudgetButton.isHidden = true
            
        case 1:
            budgetTableView.isHidden = false
            addBudgetButton.isHidden = false
            noteTableView.isHidden = true
            addNoteButton.isHidden = true
        default:
            print("something wrong")
        }
    }
    
    
    func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView) {
        pageControl.currentPage = pagerView.currentIndex
    }
    
    
}

//MARK:- UITableView
extension CalendarViewController: UITableViewDataSource, UITableViewDelegate{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        switch tableView {
        case noteTableView:
            return 1
        case budgetTableView:
            return budgetSectionTitle.count
        default:
            fatalError("Invalid Table")
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == noteTableView{
            return 1
        }else if tableView == budgetTableView{
            return 1
        }
        return Int()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == noteTableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CustomNote", for: indexPath)

            cell.textLabel?.text = "Add something..."
            cell.textLabel?.alpha = 0.3
            cell.backgroundColor = .groupTableViewBackground
            return cell
        }else if tableView == budgetTableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CustomBudget", for: indexPath)
            cell.textLabel?.text = "Add something..."
            cell.textLabel?.alpha = 0.3
            cell.backgroundColor = .groupTableViewBackground
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView == noteTableView{
            return "To do"
        }else if tableView == budgetTableView{
            return budgetSectionTitle[section]
        }
        return String()
    }
    
    
}


//MARK:- Events
extension CalendarViewController {
    

    
    @objc func settingButtonDidTouchUpInside(sender: UIButton) {
        let settingVC = SettingViewController()
        self.navigationController?.pushViewController(settingVC, animated: true)
    }
    
    @objc func addNoteEvent(sender: UIButton){
        let noteVC = AddNoteEventViewController()
        let addNoteNav = UINavigationController(rootViewController: noteVC)
        self.present(addNoteNav, animated: true, completion: nil)
        

    }
    @objc func addBudgetEvent(sender: UIButton){
        let budgetVC = AddBudgetEventViewController()
        self.present(budgetVC, animated: true, completion: nil)
    }

    
    @objc func action(sender: UIBarButtonItem) {
        print("button settled")
    }
    
}


