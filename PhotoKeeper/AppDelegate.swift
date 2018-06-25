//
//  AppDelegate.swift
//  PhotoKeeper
//
//  Created by Devin Argenta on 5/3/18.
//  Copyright © 2018 Devin Argenta. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication,
            didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        let win = UIWindow()
        win.frame = UIScreen.main.bounds
        let layout = UICollectionViewFlowLayout()
        let pgvc = PhotoGridViewController(collectionViewLayout: layout)
        let nav = UINavigationController(rootViewController: pgvc)
        win.rootViewController = nav
        win.makeKeyAndVisible()
        window = win

        return true
    }
}
