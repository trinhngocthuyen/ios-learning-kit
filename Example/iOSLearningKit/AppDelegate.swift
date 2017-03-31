//
//  AppDelegate.swift
//  iOSLearningKit
//
//  Created by Thuyen Trinh on 03/31/2017.
//  Copyright (c) 2017 Thuyen Trinh. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let homeViewModel = HomeViewModel(apiClient: HNApiClient())
        window?.rootViewController = UINavigationController(rootViewController: HomeViewController(viewModel: homeViewModel))
        window?.makeKeyAndVisible()
        return true
    }
}

