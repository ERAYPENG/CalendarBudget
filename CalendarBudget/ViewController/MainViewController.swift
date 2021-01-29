//
//  MainViewController.swift
//  CalendarBudget
//
//  Created by ERAY on 2020/12/1.
//

import UIKit
import SnapKit
import FSPagerView

class MainViewController: UIViewController {
    var executeClosure: (()->())?
    lazy var noteContent = [AddNoteEventContent]()
    lazy var budgetContent = [AddBudgetEventContent]()
    private var foodContent = [AddBudgetEventContent]()
    private var clothingContent = [AddBudgetEventContent]()
    private var housingContent = [AddBudgetEventContent]()
    private var transportationContent = [AddBudgetEventContent]()
    private var educationContent = [AddBudgetEventContent]()
    private var entertainmentContent = [AddBudgetEventContent]()
    let calendarVC = CalendarViewController()
    let pagerViewVC = PagerViewViewController()
    lazy var eventLabel: UILabel = {
        let eventLabel = UILabel()
        return eventLabel
    }()
    
    
    public var foodEventUserInputTest: String = ""
    public var clothingEventUserInputTest: String = ""
    public var housingEventUserInputTest: String = ""
    public var trnsportationEventUserInputTest: String = ""
    public var foodCostUserInputTest: String = ""
    public var clothingCostUserInputTest: String = ""
    public var housingCostUserInputTest: String = ""
    public var trnsportationCostUserInputTest: String = ""
    

    fileprivate weak var yellowBlock: UIView!
    fileprivate var fillBlankView: UIView = UIView()
    fileprivate var noteSectionTitle = ["To do"]
    fileprivate var budgetSectionTitle = ["Food", "Clothing", "Housing", "Transportation", "Education", "Entertainment"]
    fileprivate var addEventDescription: String?
    fileprivate var addBudgetEventDate: String = ""
    fileprivate var addEventTime: String?
    let dateFormatter = DateFormatter()
    let timeFormatter = DateFormatter()
    
    lazy var noteTableView: UITableView = {
        let noteTableView = UITableView()
        noteTableView.backgroundColor = .groupTableViewBackground
        noteTableView.dataSource = self
        noteTableView.delegate = self
        noteTableView.register(NoteEventTableViewCell.self, forCellReuseIdentifier: NoteEventTableViewCell.identifier)
        return noteTableView
    }()
    
    lazy var budgetTableView: UITableView = {
        let budgetTableView = UITableView()
        budgetTableView.backgroundColor = .groupTableViewBackground
        budgetTableView.dataSource = self
        budgetTableView.delegate = self
        budgetTableView.register(BudgetTableViewCell.self, forCellReuseIdentifier: BudgetTableViewCell.identifier)
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
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("calendar vc will appear")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("calendar vc did load")
        
        self.calendarVC.executeClosureFromCalendarVC = { (str) in
            self.addBudgetEventDate = str
            self.reloadAllTableViews()
        }
        
        self.setupUI()

        fillBlankView.backgroundColor = UIColor(red: 246/255, green: 216/255, blue: 23/255, alpha: 1)
        view.addSubview(fillBlankView)
        
        let yellowBlock = UIView()
        yellowBlock.backgroundColor = UIColor.groupTableViewBackground
        yellowBlock.translatesAutoresizingMaskIntoConstraints = false
        self.yellowBlock = yellowBlock
        
        
        let pagerView = pagerViewVC.pagerView
        let pageControl = pagerViewVC.pageControl
        
        pagerViewVC.executeClosure = { (index) in
            switch pageControl.currentPage {
            case 0:
                self.noteTableView.isHidden = false
                self.addNoteButton.isHidden = false
                self.budgetTableView.isHidden = true
                self.addBudgetButton.isHidden = true
                
            case 1:
                self.budgetTableView.isHidden = false
                self.addBudgetButton.isHidden = false
                self.noteTableView.isHidden = true
                self.addNoteButton.isHidden = true
            default:
                print("something wrong")
            }
        }
        
        addChild(calendarVC)
        view.addSubview(calendarVC.view)

        view.addSubview(yellowBlock)
        self.view.addSubview(pagerView)
        self.view.addSubview(pageControl)
        view.addSubview(addNoteButton)
        view.addSubview(addBudgetButton)
        view.addSubview(noteTableView)
        view.addSubview(budgetTableView)
        budgetTableView.isHidden = true
        addBudgetButton.isHidden = true

        
//MARK:- AutoLayout
//        calendarView.snp.makeConstraints { (make) in
//            make.leading.equalToSuperview()
//            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
//            make.trailing.equalToSuperview()
//            make.height.equalTo(self.view).dividedBy(3)
//        }
        
        calendarVC.view.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.trailing.equalToSuperview()
            make.height.equalTo(self.view).dividedBy(3)
        }
        
        fillBlankView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(calendarVC.view.snp.bottom)
            make.bottom.equalTo(yellowBlock.snp.top)
        }
        
        yellowBlock.snp.makeConstraints { (make) in
            make.top.equalTo(calendarVC.view.safeAreaLayoutGuide.snp.bottom).offset(50)
            make.height.equalTo(calendarVC.view).dividedBy(2)
            make.width.equalToSuperview()
        }
        pagerView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(180)
        }
        pageControl.snp.makeConstraints { (make) in
            make.width.equalTo(80)
            make.height.equalTo(30)
            make.bottom.equalTo(pagerView.snp.bottom).offset(0)
            make.centerX.equalTo(pagerView)
        }
        addNoteButton.snp.makeConstraints { (make) in
            make.top.equalTo(calendarVC.view.snp.bottom).offset(-10)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(60)
        }
        addBudgetButton.snp.makeConstraints { (make) in
            make.top.equalTo(calendarVC.view.snp.bottom).offset(-10)
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
//            make.top.equalTo(calendar.snp.bottom)
            make.width.equalToSuperview()
            make.bottom.equalTo(pagerView.snp.top)
        }
}
//    //Dowcasting
//    //1.檢查 instance type
//    let a: Any? = "1"
//    //2.optional
//    let b: String? = nil
//
    override func viewDidLayoutSubviews() {
        self.applyCurvedPath(givenView: yellowBlock,curvedPercent: 0.2)
//        //1.檢查 instance type
//        if
//            let bObject = self.a as? String {
//            print(bObject)
//        }
//
//        guard
//            let a1Object = self.a as? String
//        else {
//            //fail downcasting
//            return
//        }
//        print(a1Object)
//
//        //2.optional
//        if let bObject = b { // b != nil 進 block, b == nil 不進 block
//            print(bObject)
//        }
//
//        guard
//            let a2Object = self.b
//        else {
//            //b == nil
//            return
//        }
//        // b != nil
//        print(a2Object)
    }
    
        
    private func reloadAllTableViews() {
        noteContent = noteContentDecodeData.filter({return $0.dateString == calendarVC.calendarVCDate})
        budgetContent = budgetContentDecodeData.filter({return $0.dateString == calendarVC.calendarVCDate})
        
        foodContent = budgetContent.filter({return $0.categoryValueString == budgetSectionTitle[0]})
        clothingContent = budgetContent.filter({return $0.categoryValueString == budgetSectionTitle[1]})
        housingContent = budgetContent.filter({return $0.categoryValueString == budgetSectionTitle[2]})
        transportationContent = budgetContent.filter({return $0.categoryValueString == budgetSectionTitle[3]})
        educationContent = budgetContent.filter({return $0.categoryValueString == budgetSectionTitle[4]})
        entertainmentContent = budgetContent.filter({return $0.categoryValueString == budgetSectionTitle[5]})

        self.noteTableView.reloadData()
        self.budgetTableView.reloadData()
    }
    
}

//MARK: Private

extension MainViewController {
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

//MARK:- UITableView
extension MainViewController: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        switch tableView {
        case noteTableView:
            return noteSectionTitle.count
        case budgetTableView:
            return budgetSectionTitle.count
        default:
            fatalError("Invalid Table")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == noteTableView {
            if section == 0 {
                if noteContent.count == 0 {
                    return 1
                } else {
                    return noteContent.count
                }
            } else {
                return 1
            }
            
        } else if tableView == budgetTableView {
            return budgetContent.filter({return $0.categoryValueString == budgetSectionTitle[section]}).count
        }
        return Int()
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

        tableView.rowHeight = 44
        if tableView == noteTableView {

            if noteContent.count == 0 {
                let cell = UITableViewCell()
                cell.textLabel?.text = "Add something..."
                cell.textLabel?.textColor = .lightGray
                cell.backgroundColor = .groupTableViewBackground
//                eventTimeLabel.isHidden = true
                return cell
                                
                

            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: NoteEventTableViewCell.identifier) as? NoteEventTableViewCell else {
                    let noteCell = NoteEventTableViewCell(style: .subtitle, reuseIdentifier: NoteEventTableViewCell.identifier)
//                    noteCell.config(model: noteContent[indexPath.row])
                    return noteCell
                }
                cell.backgroundColor = .groupTableViewBackground
                cell.config(model: noteContent[indexPath.row])
                
                return cell

            }
            
            
        } else if tableView == budgetTableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BudgetTableViewCell.identifier) as? BudgetTableViewCell else {
                return BudgetTableViewCell(style: .subtitle, reuseIdentifier: BudgetTableViewCell.identifier)
            }
            switch indexPath.section {
            case 0:
                cell.config(model: foodContent[indexPath.row])
            case 1:
                cell.config(model: clothingContent[indexPath.row])
            case 2:
                cell.config(model: housingContent[indexPath.row])
            case 3:
                cell.config(model: transportationContent[indexPath.row])
            case 4:
                cell.config(model: educationContent[indexPath.row])
            case 5:
                cell.config(model: entertainmentContent[indexPath.row])
            default:
                fatalError()
            }
            
            
            cell.backgroundColor = .groupTableViewBackground
            cell.config(model: budgetContent[indexPath.row])
            
            return cell
//            cell.backgroundColor = .groupTableViewBackground
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView == noteTableView {
            return "To do"
        } else if tableView == budgetTableView {
            return budgetSectionTitle[section]
        }
        return String()
    }
    
    
}


//MARK:- Events
extension MainViewController {
    

    
    @objc func settingButtonDidTouchUpInside(sender: UIButton) {
        let settingVC = SettingViewController()
        self.navigationController?.pushViewController(settingVC, animated: true)
    }
    
    @objc func addNoteEvent(sender: UIButton){
        let noteVC = AddNoteEventViewController()
        noteVC.executeClosure = {
            self.reloadAllTableViews()
        }
        let addNoteNav = UINavigationController(rootViewController: noteVC)
        addNoteNav.modalTransitionStyle = .crossDissolve
        self.present(addNoteNav, animated: true, completion: nil)
        

    }
    @objc func addBudgetEvent(sender: UIButton){
        let budgetVC = AddBudgetEventViewController()
        budgetVC.saveBudgetEventClosure = { (str) in
            self.reloadAllTableViews()
        }
        let addBudgetNav = UINavigationController(rootViewController: budgetVC)
        addBudgetNav.modalTransitionStyle = .crossDissolve
        self.present(addBudgetNav, animated: true, completion: nil)
        budgetVC.dateString = addBudgetEventDate
    }
    
}


