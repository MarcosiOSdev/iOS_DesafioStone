//
//  AppDelegate.swift
//  DesafioStone
//
//  Created by Marcos Felipe Souza on 24/07/19.
//  Copyright © 2019 Marcos Felipe Souza. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var connectivityWatchOS: WatchOSConnectivity?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        self.connectivityWatchOS = WatchOSConnectivity.sharing
        
        let appCoordinator = AppCoordinator(window: self.window!)
        appCoordinator.transition(to: Scene.facts, type: .root)
        
        return true
    }
}

