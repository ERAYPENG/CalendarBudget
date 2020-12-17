//
//  AppDelegate.swift
//  CalendarBudget
//
//  Created by ERAY on 2020/12/1.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let vc = CalendarViewController()
        let nav = UINavigationController(rootViewController: vc)
        nav.navigationBar.barTintColor = .gray
        self.window?.rootViewController = nav
        
        
        
        
        return true
    }



}

