//
//  AppDelegate.swift
//  CalendarBudget
//
//  Created by ERAY on 2020/12/1.
//

import UIKit
import GuillotineMenu
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var addNoteWindow:UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        if let _ = Auth.auth().currentUser {
            
            let vc = MainViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.navigationBar.barTintColor = .gray
            self.window?.rootViewController = nav

        } else {
        
            let vc = LoginViewController()
            let nav = UINavigationController(rootViewController: vc)
            self.window?.rootViewController = nav
            
        }
        
//        let addNoteVC = addNoteEventViewController()
//        let addNoteNav = UINavigationController(rootViewController: addNoteVC)
//        addNoteNav.navigationBar.barTintColor = .gray
//        self.addNoteWindow?.rootViewController = addNoteVC

        return true
    }



}

