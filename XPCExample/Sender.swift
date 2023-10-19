//
//  Sender.swift
//  XPCExample
//
//  Created by Sergey Vinogradov on 19.10.23.
//

import Foundation

class Sender {
    static let shared = Sender()
    
    private let connection: NSXPCConnection
    
    private init() {
        let connectionToService = NSXPCConnection(serviceName: "com.perimeter81.Daemon")
        connectionToService.remoteObjectInterface = NSXPCInterface(with: DaemonProtocol.self)
        connectionToService.resume()
        
        connection = connectionToService
    }
    
    deinit {
        connection.invalidate()
    }
}

// MARK: Interaction_OneWay
extension Sender {
    func sendPerformSome() {
        
        // In getting proxy object we can separate it by protocols
        // Can be useful for optional
        guard let proxy = connection.remoteObjectProxy as? Interaction_OneWay else { return }
        
        // Here we can select only one method for proxy - from Interaction_OneWay protocol
        proxy.performSome()
    }
}

// MARK: Interaction_OneWayWithParameter
extension Sender {
    private
    var proxy: Interaction_OneWayWithParameter? {
        connection.remoteObjectProxy as? Interaction_OneWayWithParameter
    }
    
    // Not a require but better to use proxy's method name with prefix. Bad example on the next row
    @discardableResult
    func sendAString(string: String) -> Bool {
        guard let proxy else {
            print("Proxy object isn't valid")
            
            return false
        }
        
        proxy.performWithString(string: string)
        
        return true
    }
    
    func sendPerformWithInt(value: Int) {
        guard let proxy else { return }
        
        // This isn't implemented in listener. But we can try to perform...
        // Exception: -[DaemonXPC.DaemonXPC performWithIntWithValue:]: unrecognized selector sent to instance
        
        // We can't handle it here - it will happen on listener's side
        proxy.performWithInt?(value: value)
        
        /*
        // Will not help
        do {
            try proxy.performWithInt?(value: value)
        } catch {
            print("Oops, not implemented: \(error)")
        }
        */
    }
}

// MARK: Interaction_WithCompletion
extension Sender {
    func sendPerformWith(string: String, flag: Bool) {
        guard let proxy = connection.remoteObjectProxy as? DaemonProtocol else { return }
        
        proxy.performWith(string: string, flag: flag) { stringFromListener in
            print("We can proudly print result from listener \(stringFromListener)")
        }
    }
}
