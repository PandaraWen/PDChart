//
//  AppDelegate.swift
//  PDChartDemo
//
//  Created by Pandara on 14-7-15.
//  Copyright (c) 2014年 Pandara. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var mainViewController: MainViewController?
    var navigationController: UINavigationController?
    

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        // Override point for customization after application launch.
        self.window!.backgroundColor = UIColor.whiteColor()
        
        self.navigationController = UINavigationController()
        self.mainViewController = MainViewController(nibName: "MainViewController", bundle: nil)
        self.navigationController!.pushViewController(self.mainViewController!, animated: false)
        self.window!.rootViewController = self.navigationController
        
        self.window!.makeKeyAndVisible()
        return true
    }
}

