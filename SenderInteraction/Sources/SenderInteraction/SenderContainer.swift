//
//  Sender.swift
//  XPCExample
//
//  Created by Sergey Vinogradov on 19.10.23.
//

import Foundation

// SPM
import DaemonInteraction

// Frameworks
//import XPCInteraction

public final
class SenderContainer {
    let sender: Sender
    let errodDelegate: ErrorDelegate?
    
    public
    init(errodDelegate: ErrorDelegate?) {
        self.sender = Sender(serviceName: "com.perimeter81.Daemon")
        self.errodDelegate = errodDelegate
        
        initialize()
    }
    
    var proxy: Any? {
        sender.proxy
    }
    
    func initialize() {
        if let delegate = self as? SenderDelegateProtocol {
            sender.delegate = delegate
        }
    }
}
 
class ExampleSender: SenderDelegateProtocol {
    func connectionWillStart() {
        print("perform: connectionWillStart")
    }
    
    func connectionWillStop() {
        print("perform: connectionWillStop")
    }
}

// MARK: Interaction_OneWay
extension SenderContainer {
    public
    func sendPerformSome() {
        
        // In getting proxy object we can separate it by protocols
        // Can be useful for optional
        guard let proxy = self.proxy as? Interaction_OneWay else {
            errodDelegate?.onSenderError(.proxyUnavailable)
            
            return
        }
        
        // Here we can select only one method for proxy - from Interaction_OneWay protocol
        proxy.performSome()
    }
}

// MARK: Interaction_OneWayWithParameter
extension SenderContainer {
    
    // Not a require but better to use proxy's method name with prefix. Bad example on the next row
    @discardableResult public
    func sendAString(string: String) -> Bool {
        guard let proxy = self.proxy as? Interaction_OneWayWithParameter else {
            print("Proxy object isn't valid")
            
            errodDelegate?.onSenderError(.proxyUnavailable)
            
            return false
        }
        
        proxy.performWithString(string: string)
        
        return true
    }
    
    public
    func sendPerformWithInt(value: Int) {
        guard let proxy = self.proxy as? Interaction_OneWayWithParameter else {
            errodDelegate?.onSenderError(.proxyUnavailable)
            
            return
        }
        
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
extension SenderContainer {
    public
    func sendPerformWith(string: String, flag: Bool, completion: @escaping (String) -> Void) {
        guard let proxy = self.proxy as? DaemonProtocol else {
            errodDelegate?.onSenderError(.proxyUnavailable)
            
            return
        }
        
        proxy.performWith(string: string, flag: flag) { stringFromListener in
            print("We can proudly print result from listener \(stringFromListener)")
            
            completion(stringFromListener)
        }
    }
    
    // Any reply should being received inside completions, not directly
    // Origin of error like: An uncaught exception was raised
    // [NSXPCConnection sendInvocation]: Return type of methods sent over this proxy must be 'void' or 'NSProgress *'
    public
    func sendPerformWith(flag: Bool) {
        guard let proxy = self.proxy as? DaemonProtocol else {
            errodDelegate?.onSenderError(.proxyUnavailable)
            
            return
        }
        
        let result = proxy.performWith(flag: true)
        // Never can happen
        print("Result of sync return: \(result)")
    }
}
