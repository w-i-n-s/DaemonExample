import Foundation

// MARK: - Sender protocol

// Parent class have connection initialized on `init` and invalidated on `deinit`
public
protocol SenderDelegateProtocol {
    /// Perform right before the connection start
    /// - Should being overrided
    func connectionWillStart()
    
    /// Perform right before the connection stop working
    /// - Should being overrided
    func connectionWillStop()
}

extension SenderDelegateProtocol {
    public
    func connectionWillStart() {
        fatalError("Must Override")
    }
    
    public
    func connectionWillStop() {
        fatalError("Must Override")
    }
}

// MARK: - Sender class

open
class Sender {//: SenderProtocol {
    
    let connection: NSXPCConnection
    
    public
    var delegate: SenderDelegateProtocol?
    
    private
    init(connection: NSXPCConnection) {
        self.connection = connection
        self.connection.remoteObjectInterface = NSXPCInterface(with: DaemonProtocol.self)
        self.connection.interruptionHandler = {
            print("interruptionHandler")
        }
        
        self.connection.invalidationHandler = {
            print("invalidationHandler")
        }
        
        self.connectionStart()
    }

    public convenience
    init(serviceName: String) {
        self.init(connection: NSXPCConnection(serviceName: serviceName))
    }
    
    public convenience
    init(machServiceName: String) {
        self.init(connection: NSXPCConnection(machServiceName: machServiceName))
    }
    
    public var proxy: Any? {
        connection.remoteObjectProxy
    }
    
    public static
    func makeInstance(serviceName: String) -> Sender {
        Sender(serviceName: serviceName)
    }
    
    public static
    func makeInstance(machServiceName: String) -> Sender {
        Sender(machServiceName: machServiceName)
    }
    
    private func connectionStart() {
        delegate?.connectionWillStart()
        
        connection.resume()
    }
    
    private func connectionStop() {
        delegate?.connectionWillStop()
        
        connection.invalidate()
    }
    
    deinit {
        connectionStop()
    }
    
    
}
