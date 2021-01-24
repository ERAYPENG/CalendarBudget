////
////  PagerViewViewController.swift
////  CalendarBudget
////
////  Created by ERAY on 2021/1/20.
////
//
import UIKit
import FSPagerView

class PagerViewViewController: UIViewController {
    var executeClosure: ((Int)->())?
    lazy var pagerView: FSPagerView = {
        let pagerView = FSPagerView()
        pagerView.dataSource = self
        pagerView.delegate = self
        pagerView.isInfinite = false
        pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "Cell")
        pagerView.transformer = FSPagerViewTransformer(type: .ferrisWheel)
        return pagerView
    }()
    fileprivate var numberOfItems = 2
    fileprivate let imageNames = ["noteIcon","budgetIcon"]
    lazy var pageControl: FSPageControl = {
        let pageControl = FSPageControl()
        pageControl.numberOfPages = imageNames.count
        pageControl.contentHorizontalAlignment = .right
        pageControl.contentInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        pageControl.currentPage = 1
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
        if let closure = self.executeClosure {
            closure(targetIndex)
        }
        
    }
    
    
    func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView) {
        pageControl.currentPage = pagerView.currentIndex
    }
    
    
}
