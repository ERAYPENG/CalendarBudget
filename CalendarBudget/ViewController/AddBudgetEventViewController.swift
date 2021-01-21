//
//  AddBudgetEventViewController.swift
//  CalendarBudget
//
//  Created by ERAY on 2020/12/23.
//

import UIKit

class AddBudgetEventViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLoad()
        self.view.backgroundColor = .groupTableViewBackground
        let finishButton = UIButton(frame: CGRect.zero)
        finishButton.backgroundColor = .groupTableViewBackground
        finishButton.setTitle("Finish", for: .normal)
        finishButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        finishButton.setTitleColor(.systemBlue, for: .normal)
        finishButton.addTarget(self, action: #selector(budgetDismiss), for: .touchUpInside)
        view.addSubview(finishButton)
        
        
//MARK:- AutoLayout
        finishButton.snp.makeConstraints { (make) in
            make.trailing.equalTo(self.view)
            make.top.equalTo(self.view).offset(10)
            make.width.equalTo(100)
            make.height.equalTo(50)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("add budget view appear")
    }

    

}
//MARK:- Events
extension AddBudgetEventViewController{
    @objc func budgetDismiss(sender: UIButton){
        self.dismiss(animated: true, completion: nil)
    }
}
