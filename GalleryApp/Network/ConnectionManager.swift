//
//  ConnectionManager.swift
//  GalleryApp
//
//  Created by Ivan Fabri on 06/03/2023.
//

import Foundation

public class ConnectionManager {
    public static let shared = ConnectionManager()
    private var reachability: Reachability?
    
    public func observeReachability() {
        do {
            self.reachability = try Reachability()
            try self.reachability?.startNotifier()
        }
        catch(let error) {
            print("Error occured while starting reachability notifications : \(error.localizedDescription)")
        }
    }
    public func stopObservingReachability() {
        reachability?.stopNotifier()
    }
}
