//
//  SettingViewController.swift
//  CalendarBudget
//
//  Created by ERAY on 2020/12/6.
//

import UIKit
import GuillotineMenu

class SettingViewController: UIViewController, GuillotineMenu {
    var dismissButton: UIButton?
    var titleLabel: UILabel?
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("Setting vc will appear")
    }
    
    private func menuButtonTapped(_ sender: UIButton) {
        presentingViewController!.dismiss(animated: true, completion: nil)
    }
    
    private func closeMenu(_ sender: UIButton) {
        presentingViewController!.dismiss(animated: true, completion: nil)
    }
}
//MARK: Private
extension SettingViewController {
    private func setupUI() {
        self.view.backgroundColor = .gray
        dismissButton = {
            let button = UIButton(frame: .zero)
            button.setImage(UIImage(named: "cogwheel"), for: .normal)
            button.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
            return button
        }()
        
        titleLabel = {
            let label = UILabel()
            return label
        }()
    
    }
}

//MARK: Event
extension SettingViewController {
    @objc func dismissButtonTapped(_ sender: UIButton) {
        presentingViewController!.dismiss(animated: true, completion: nil)
    }
}
