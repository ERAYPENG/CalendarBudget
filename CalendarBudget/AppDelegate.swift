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
        
        let vc = CalendarViewController() //vc 是 CalendarViewController 實體(instance)
        let nav = UINavigationController(rootViewController: vc)
        self.window?.rootViewController = nav
        
        
        
        
        return true
    }



}

