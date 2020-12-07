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
        
//        self.window = UIWindow(frame: UIScreen.main.bounds)
        let vc = CalendarViewController() //vc 是 CalendarViewController 實體(instance)
//        let mainView = ViewController(nibName: "ViewController", bundle: nil) //ViewController = Name of your controller
//        nav1.viewControllers = [mainView]
        let nav = UINavigationController(rootViewController: vc)
        self.window?.rootViewController = nav
//        self.window?.makeKeyAndVisible()
        
        
        
        
        return true
    }



}

