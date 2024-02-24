//
//  MonitorNetwork.swift
//  VNPAY_Challenge
//
//  Created by lê thạch on 24/02/2024.
//

import UIKit
import Network

class MonitorNetwork {
    static let shared = MonitorNetwork()

    private var turnOnNetwork = false

    func isConnectedNetwork() -> Bool {
        return turnOnNetwork
    }

    func configMonitorNetwork() {
        let monitorNetwork = NWPathMonitor()
        monitorNetwork.pathUpdateHandler = { path in
            let previousState = self.turnOnNetwork

            if path.status == .satisfied {
                self.turnOnNetwork = true
            } else {
                self.turnOnNetwork = false
            }

            if previousState != self.turnOnNetwork {
                NotificationCenter.default.post(name: Notification.Name.didChangeConnectNetworkActivity, object: nil)
            }
        }

        monitorNetwork.start(queue: .main)
    }
}

extension Notification.Name {
    public static let didChangeConnectNetworkActivity = Notification.Name("didChangeConnectNetworkActivity")
}
