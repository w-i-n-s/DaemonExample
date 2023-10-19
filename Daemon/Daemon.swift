//
//  Daemon.swift
//  Daemon
//
//  Created by Sergey Vinogradov on 18.10.23.
//

import Foundation

// MARK: - Actually the Listener
@objc
class Daemon:
    NSObject, // because of objc
    DaemonProtocol {
    
    func performSome() {
        print("Perform something on a listener side")
    }
    
    func performWithString(string: String) {
        print("Receive \(string) from sender")
    }
    
    func performWithDict(dict: Dictionary<String, Any>) {
        print("Receive \(dict.keys) and \(dict.values)")
    }
    
    func performWith(string: String, flag: Bool, completion: @escaping (String) -> Void) {
        completion("\(string) + \(flag ? "yes" : "no")")
    }
}

// We have to avoid move parts of approach as much as we can
extension Daemon {
    func version(completion: @escaping (String) -> Void) {
        completion("0.0.1")
    }
}
