//
//  RegisterViewController.swift
//  CalendarBudget
//
//  Created by ERAY on 2021/3/6.
//

import UIKit
import Firebase
import SnapKit

class RegisterViewController: BaseViewController {
    let userDefault = UserDefaults()
    var userNameTextfieldView = LoginTextfieldView(placeholder: "User Name")
    var birthdayTextfieldView = LoginTextfieldView(placeholder: "Birthday")
    var accountTextfieldView = LoginTextfieldView(placeholder: "Email")
    var pwTextfieldView = LoginTextfieldView(placeholder: "Password")
    
    private var userName: String {
        get {
            return self.userNameTextfieldView.textfield.text ?? ""
        }
    }

    private var birthday: String {
        get {
            return self.birthdayTextfieldView.textfield.text ?? ""
        }
    }
    
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
    
    lazy var registerButton: UIButton = {
        let button = UIButton(type: .system)
        let color: UIColor = .hex("7c8f9c")
        button.titleLabel?.font = UIFont(name: "Menlo-Bold", size: 18)
        button.tintColor = color
        button.setTitle("Register", for: .normal)
        button.addTarget(self, action: #selector(registerButtonDidTouchUpInside), for: .touchUpInside)
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.layer.borderWidth = 3
        button.layer.borderColor = color.cgColor
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        self.title = "Register"
        let buttonColor: UIColor = .hex("b4c2cc")
        let titlecolor: UIColor = .hex("90a3b0")
        UINavigationBar.appearance().barTintColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = buttonColor
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : titlecolor]
    }
    
    private func setupView() {
        self.view.backgroundColor = .white
        
        self.view.addSubview(registerButton)
        self.view.addSubview(accountTextfieldView)
        self.view.addSubview(pwTextfieldView)
        self.view.addSubview(userNameTextfieldView)
        self.view.addSubview(birthdayTextfieldView)
        
        let offset = -15
        let height = 50
        
        registerButton.snp.makeConstraints({ (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(150)
            make.width.equalTo(150)
            make.height.equalTo(50)
        })
        
        self.pwTextfieldView.snp.makeConstraints { (make) in
            make.bottom.equalTo(registerButton.snp.top).offset(offset - 20)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(height)
        }
        
        self.accountTextfieldView.snp.makeConstraints { (make) in
            make.bottom.equalTo(pwTextfieldView.snp.top).offset(offset)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(height)
        }
        
        self.birthdayTextfieldView.snp.makeConstraints { (make) in
            make.bottom.equalTo(accountTextfieldView.snp.top).offset(offset)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(height)
        }
        
        self.userNameTextfieldView.snp.makeConstraints { (make) in
            make.bottom.equalTo(birthdayTextfieldView.snp.top).offset(offset)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(height)
        }
    }
}

extension RegisterViewController {
    
    @objc func registerButtonDidTouchUpInside() {
        self.register()
    }
    
    private func register() {
        loadingIndicator.start()
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            
            self.loadingIndicator.stop()
            
            if error != nil {
                self.showErrorAlert(error: error, myErrorMsg: nil)
                return
            }
            
            guard let currentUser = Auth.auth().currentUser else { return }

            let uid = currentUser.uid
            
            let ref = Database.database().reference().child("ProfileSetting")
            
            let value: [String: Any] = [ "userName": self.userName,
                                         "birthday": self.birthday,
                                         "email": self.email
            ]
//            let calendarVC = CalendarViewController()
//            calendarVC.getUserBirthday()
            self.userDefault.setValue(self.birthday, forKey: "birthday")
            FirebaseManager.shared.updateData(value: value, ref: ref, childNode: uid) { err in
                if err != nil {
                    self.showErrorAlert(error: err, myErrorMsg: nil)
                    return
                } else {
                   
                }

            }   
            let MainVC = MainViewController()
            let nav = UINavigationController(rootViewController: MainVC)
            nav.navigationBar.barTintColor = .gray
            UIApplication.shared.keyWindow?.rootViewController = nav
        }
    }
}
