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
    lazy var noteContent = [AddNoteEventContent]()
    var calendarVC: UIViewController!
//    let calendarVC = CalendarViewController()
//    var calendarVC: UIViewCself.view.addSubview(calendarView)ontroller!
    lazy var eventLabel: UILabel = {
        let eventLabel = UILabel()
        return eventLabel
    }()
    
    var dateStringFromCalendarVC: String?

    fileprivate weak var yellowBlock: UIView!
    fileprivate var fillBlankView: UIView = UIView()
    fileprivate let imageNames = ["noteIcon","budgetIcon"]
    fileprivate var numberOfItems = 2
    fileprivate var noteSectionTitle = ["To do"]
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
        return pagerView
    }()
    
    lazy var pageControl: FSPageControl = {
        let pageControl = FSPageControl()
        pageControl.numberOfPages = imageNames.count
        pageControl.contentHorizontalAlignment = .right
        pageControl.contentInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        pageControl.currentPage = 1
        return pageControl
    }()
    
    lazy var noteTableView: UITableView = {
        let noteTableView = UITableView()
        noteTableView.backgroundColor = .groupTableViewBackground
        noteTableView.dataSource = self
        noteTableView.delegate = self
        noteTableView.register(NoteEventTableViewCell.self, forCellReuseIdentifier: NoteEventTableViewCell.identifier)
        noteTableView.register(TestCell.self, forCellReuseIdentifier: TestCell.identifier)
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



        fillBlankView.backgroundColor = UIColor(red: 246/255, green: 216/255, blue: 23/255, alpha: 1)
        view.addSubview(fillBlankView)
        
        let yellowBlock = UIView()
        yellowBlock.backgroundColor = UIColor.groupTableViewBackground
        yellowBlock.translatesAutoresizingMaskIntoConstraints = false
        self.yellowBlock = yellowBlock
        
        
        
        
        calendarVC = CalendarViewController()
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
            make.height.equalTo(200)
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
        noteContent = decodeData.filter({return $0.dateString == dateStringFromCalendarVC})
        print(dateStringFromCalendarVC)
        print(noteContent)
        
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

extension MainViewController: FSPagerViewDelegate,FSPagerViewDataSource{
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
            return 1
        }
        return Int()
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        if indexPath.section == 0 {
//
//            //if noteContent is 0
//            if noteContent.count == 0 {
//                let cell = UITableViewCell()
//                cell.textLabel?.text = "Add something..."
//                cell.textLabel?.textColor = .lightGray
//                cell.backgroundColor = .groupTableViewBackground
////                eventTimeLabel.isHidden = true
//                return cell
//            }
//
//            //deque reuse
//            guard let
//                    cell = tableView.dequeueReusableCell(withIdentifier: NoteEventTableViewCell.identifier)  as? NoteEventTableViewCell
//            else {
//                //init
//                let noteCell = NoteEventTableViewCell(style: .subtitle, reuseIdentifier: NoteEventTableViewCell.identifier)
//
//                noteCell.config(model: noteContent[indexPath.row])
//
//                return noteCell
//            }
//            //如果有 reuse cell
//            cell.config(model: noteContent[indexPath.row])
//
//        } else if indexPath.section == 1 {
//
//            //deque reuse
//            guard let
//                    cell = tableView.dequeueReusableCell(withIdentifier: TestCell.identifier)  as? TestCell
//            else {
//                //init
//                let testCell = TestCell(style: .subtitle, reuseIdentifier: TestCell.identifier)
//                testCell.config(model: "111")
//
//                return testCell
//            }
//            //如果有 reuse cell
//            cell.config(model: "111")
//
//        } else {
//            return UITableViewCell()
//        }
//
//        return UITableViewCell()
        
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
                    noteCell.config(model: noteContent[indexPath.row])
                    return noteCell
                }
                cell.config(model: noteContent[indexPath.row])
                
//                let cell = tableView.dequeueReusableCell(withIdentifier: "CustomNote", for: indexPath)
////                cell.config(model: noteContent[indexPath.row])
//                let eventTimeLabel = UILabel()
//                cell.textLabel?.text = noteContent[indexPath.row].description
//                print(indexPath.row)
//                cell.backgroundColor = .groupTableViewBackground
//                cell.textLabel?.textColor = .black
//                eventTimeLabel.text = noteContent[indexPath.row].timeString
//                eventTimeLabel.textColor = .black
//                eventTimeLabel.backgroundColor = .groupTableViewBackground
//                cell.contentView.addSubview(eventTimeLabel)
//                
//                eventTimeLabel.snp.makeConstraints { (make) in
//                    make.trailing.equalToSuperview().offset(-20)
//                    make.centerY.equalToSuperview()
//                }
                
                return cell

            }
            
            
        } else if tableView == budgetTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CustomBudget", for: indexPath)
            
            cell.textLabel?.text = "Add something..."
            cell.textLabel?.textColor = .lightGray
            cell.backgroundColor = .groupTableViewBackground
            return cell
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
        self.present(budgetVC, animated: true, completion: nil)
    }

    
    @objc func action(sender: UIBarButtonItem) {
        print("button settled")
    }
    
}


