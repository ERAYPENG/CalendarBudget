//
//  selectDateView.swift
//  CalendarBudget
//
//  Created by ERAY on 2020/12/5.
//

import UIKit

class selectDateView: UIViewController {

    override func viewDidLoad() {
        view.backgroundColor = .groupTableViewBackground
        super.viewDidLoad()
        let finishButton = UIButton()
        finishButton.setTitle("DONE", for: .normal)
        finishButton.titleLabel?.font = .systemFont(ofSize: 14)
        finishButton.setTitleColor(.blue, for: .normal)
        finishButton.backgroundColor = .groupTableViewBackground
        finishButton.frame = CGRect(x: 1.0, y: 1.0, width: 300.0, height: 500.0)
        finishButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        self.view.addSubview(finishButton)
        
        finishButton.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(-10)
            make.width.height.equalTo(100)
        }
        
        
//        finish.setTitle("Finish", for: .selected)
        

        // Do any additional setup after loading the view.
    }
    
    
    
    @objc func dismiss(_ sender:UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
