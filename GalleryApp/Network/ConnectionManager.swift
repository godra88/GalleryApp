//
//  ConnectionManager.swift
//  GalleryApp
//
//  Created by Ivan Fabri on 06/03/2023.
//

import Foundation

class ConnectionManager {
    
    static let sharedInstance = ConnectionManager()
    private var reachability : Reachability?
    
    func observeReachability() {
        do {
            self.reachability = try Reachability()
            try self.reachability?.startNotifier()
        }
        catch(let error) {
            print("Error occured while starting reachability notifications : \(error.localizedDescription)")
        }
    }
    func stopObservingReachability() {
        reachability?.stopNotifier()
    }
}
