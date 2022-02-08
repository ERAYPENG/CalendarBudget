////
////  PagerViewViewController.swift
////  CalendarBudget
////
////  Created by ERAY on 2021/1/20.
////
//
import UIKit
import FSPagerView
import Firebase

class PagerViewViewController: BaseViewController {
    var executeClosure: ((Int)->())?
    lazy var pagerView: FSPagerView = {
        let pagerView = FSPagerView()
        pagerView.dataSource = self
        pagerView.delegate = self
        pagerView.isInfinite = true
        pagerView.register(ItemPagerViewCell.self, forCellWithReuseIdentifier: "ItemPagerViewCell")
        pagerView.transformer = FSPagerViewTransformer(type: .ferrisWheel)
        return pagerView
    }()
    fileprivate var numberOfItems = 3
    fileprivate let imageNames = ["noteIcon", "budgetIcon", "logout"]
    lazy var pageControl: FSPageControl = {
        let pageControl = FSPageControl()
        pageControl.numberOfPages = imageNames.count
        pageControl.contentHorizontalAlignment = .right
        pageControl.contentInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        pageControl.currentPage = 0
        pageControl.setFillColor(.hex("667e95"), for: .selected)
        pageControl.setFillColor(.hex("e1e5e8"), for: .normal)
        return pageControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(pagerView)
        view.addSubview(pageControl)
    }
}

extension PagerViewViewController: FSPagerViewDelegate,FSPagerViewDataSource{
    //MARK:- FSPagerView Datasource
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return numberOfItems
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        
        var title: String
        if index == 0 {
            title = "Note"
        } else if index == 1 {
            title = "Budget"
        } else { title = "Logout" }
        
        guard let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "ItemPagerViewCell", at: index) as? ItemPagerViewCell else {
            let cell = ItemPagerViewCell()
            cell.config(imageName: self.imageNames[index], title: title)
            return cell
        }
        cell.config(imageName: self.imageNames[index], title: title)
        return cell
    }
    // MARK:- FSPagerView Delegate
    func pagerView(_ pagerView: FSPagerView, willDisplay cell: FSPagerViewCell, forItemAt index: Int) {
//        pageControl.currentPage = index
    }
    
    func pagerView(_ pagerView: FSPagerView, shouldSelectItemAt index: Int) -> Bool {
        if index == 2 {
            do {
                try Auth.auth().signOut()
                
                let vc = LoginViewController()
                let nav = UINavigationController(rootViewController: vc)
                UIApplication.shared.keyWindow?.rootViewController = nav
                
            } catch let logoutError {
                self.showErrorAlert(error: logoutError, myErrorMsg: nil)
            }
        }
        return false
    }
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        print("will end:\(targetIndex)")
        pageControl.currentPage = targetIndex
        if let closure = self.executeClosure {
            closure(targetIndex)
        }
        let mainVC = MainViewController()
        mainVC.budgetTableView.reloadData()
    }
}
