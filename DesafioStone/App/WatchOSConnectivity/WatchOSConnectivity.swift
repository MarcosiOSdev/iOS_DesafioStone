//
//  WatchOSConnectivity.swift
//  DesafioStone
//
//  Created by Marcos Felipe Souza on 04/02/20.
//  Copyright © 2020 Marcos Felipe Souza. All rights reserved.
//

import Foundation
import WatchConnectivity


class WatchOSConnectivity: NSObject, WCSessionDelegate {
        
    var wcSession : WCSession! = nil
    
    private override init() {
        super.init()
        wcSession = WCSession.default
        wcSession.delegate = self
        wcSession.activate()
    }
    static let sharing = WatchOSConnectivity()
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?)")
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("sessionDidBecomeInactive")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("sessionDidBecomeInactive")
    }
    
    
}
