//
//  NetworkReachabilityProvider.swift
//  Covid19Tracker
//
//  Created by Chaithra Thalpanaje Shrikrishna on 18/08/21.
//

import Foundation
import Alamofire

protocol NetworkReachabilityProvider {

    /// Whether the network is currently reachable.
    var isReachable: Bool { get }

    /// Called when isReachable changes.
    var listener: ((Bool) -> Void)? { get set }

    func startListening()

}

class NetworkReachability: NetworkReachabilityProvider {

    private let manager = NetworkReachabilityManager()

    var isReachable: Bool {
        return manager?.isReachable ?? true
    }

    var listener: ((Bool) -> Void)?

    init() {
        manager?.listener = { [weak self] _ in
            guard let `self` = self else { return }
            self.listener?(self.isReachable)
        }
    }

    func startListening() {
        manager?.startListening()
    }

}
