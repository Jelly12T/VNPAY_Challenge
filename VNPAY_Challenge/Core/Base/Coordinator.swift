//
//  Coordinator.swift
//  VNPAY_Challenge
//
//  Created by lê thạch on 23/02/2024.
//

import Foundation

public protocol CoordinatorEvent {
}

open class Coordinator: NSObject {
    private(set) var started: Bool = false
    private(set) var children: [Coordinator] = []
    private(set) weak var parent: Coordinator?

    open func start() {
        if self.started {
            return
        }

        self.started = true
    }

    open func stop(completion: (() -> Void)? = nil) {
        if !self.started {
            return
        }

        self.stopAllChildren()
        self.started = false
        self.parent?.childDidStop(self)
        self.parent?.removeChild(self)
        completion?()
    }

    open func handle(event: CoordinatorEvent) -> Bool {
        return false
    }

    public func send(event: CoordinatorEvent) {
        if !self.handle(event: event) {
            self.parent?.send(event: event)
        }
    }

    public func addChild(_ coordinator: Coordinator) {
        coordinator.parent = self
        self.children.append(coordinator)
    }

    public func removeChild(_ coordinator: Coordinator) {
        coordinator.parent = nil
        let index = self.children.firstIndex { obj in
            return obj == coordinator
        }

        if index != nil {
            self.children.remove(at: index!)
        }
    }

    public func stopAllChildren() {
        self.children.forEach { child in
            child.stop()
        }
    }

    open func childDidStop(_ child: Coordinator) {

    }
}
