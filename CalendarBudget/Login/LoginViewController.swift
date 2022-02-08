//
//  LoginViewController.swift
//  CalendarBudget
//
//  Created by ERAY on 2021/3/6.
//

import UIKit
import Firebase
import SnapKit

class LoginViewController: BaseViewController {
    let userDefault = UserDefaults()
    var accountTextfieldView = LoginTextfieldView(placeholder: "Account")
    var pwTextfieldView = LoginTextfieldView(placeholder: "Password")
    
    private var email: String {
        get {
            return self.accountTextfieldView.textfield.text ?? ""
        }
    }
    
    private var password: String {
        get {
            return self.pwTextfieldView.textfield.text ?? ""
        }
    }
    
    lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont(name: "Menlo-Bold", size: 18)
        button.tintColor = .hex("454545")
        button.setTitle("Login", for: .normal)
        button.addTarget(self, action: #selector(loginButtonDidTouchUpInside), for: .touchUpInside)
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.layer.borderWidth = 3
        button.layer.borderColor = UIColor.hex("454545").cgColor
        return button
    }()
    
    lazy var registerButton: UIButton = {
        let button = UIButton(type: .system)
        var attrs:[NSAttributedString.Key: Any] = [
            .font : UIFont(name: "Menlo", size: 16) ?? .systemFont(ofSize: 16),
            .foregroundColor : UIColor.hex("b4c2cc"),
            .underlineStyle : NSUnderlineStyle.single.rawValue]
        let attributeString = NSMutableAttributedString(string: "Register here",
                                                        attributes: attrs)
        button.setAttributedTitle(attributeString, for: .normal)
        button.addTarget(self, action: #selector(registerButtonDidTouchUpInside), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = ""
        self.view.backgroundColor = .white
        
        self.view.addSubview(loginButton)
        self.view.addSubview(registerButton)
        self.view.addSubview(pwTextfieldView)
        self.view.addSubview(accountTextfieldView)
        
        self.loginButton.snp.makeConstraints({ (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(100)
            make.width.equalTo(130)
            make.height.equalTo(50)
        })
        
        self.registerButton.snp.makeConstraints({ (make) in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-8)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
        })
        
        pwTextfieldView.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.loginButton.snp.top).offset(-30)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(50)
        }
        
        accountTextfieldView.snp.makeConstraints { (make) in
            make.bottom.equalTo(pwTextfieldView.snp.top).offset(-30)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(50)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        loadingIndicator.stop()
    }
}

extension LoginViewController {
    
    @objc func loginButtonDidTouchUpInside() {
        self.login()
    }
    
    private func login() {
        
        loadingIndicator.start()
        
        //POST method
        Auth.auth().signIn(withEmail: email, password: password, completion: { (_, error) in
            
            self.loadingIndicator.stop()
            if error != nil {
                self.showErrorAlert(error: error, myErrorMsg: nil)
                return
            }
            let calendarVC = CalendarViewController()
            calendarVC.getUserBirthday()
            let vc = MainViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.navigationBar.barTintColor = .gray
            UIApplication.shared.keyWindow?.rootViewController = nav

            
//            sender.isLoading = false
//            self.loadingIndicator.stop()
//
//            if error != nil {
//                self.showErrorAlert(error: error, myErrorMsg: nil)
//                return
//            }
//
//            // successfully login
//            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
//
//                let vc = self.createViewControllerFromStoryboard(name: Config.Storyboard.product, identifier: Config.Controller.Product.nav)
//
//                appDelegate.window?.rootViewController = vc
//
//            }
        })
    }
    
    @objc func registerButtonDidTouchUpInside() {
        self.navigationController?.pushViewController(RegisterViewController(), animated: true)
    }
}
