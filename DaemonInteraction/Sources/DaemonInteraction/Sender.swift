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
class Sender {
    
    let connection: NSXPCConnection
    
    public
    var delegate: SenderDelegateProtocol?
    
    private
    /// Initialization of the Sender instance
    /// - Parameters:
    ///   - connection: connection instance
    ///   - connectionProtocol: protocol which connection will use to interact with a listener
    init(connection: NSXPCConnection, connectionProtocol: Protocol) {
        self.connection = connection
        self.connection.remoteObjectInterface = NSXPCInterface(with: connectionProtocol.self)
        self.connection.interruptionHandler = {
            print("interruptionHandler")
        }
        
        self.connection.invalidationHandler = {
            print("invalidationHandler")
        }
        
        self.connectionStart()
    }
    
    /// Initialization of the Sender instance with pre-defined DaemonProtocol
    /// - Parameter serviceName: the service name for create connection
    public convenience
    init(serviceName: String) {
        self.init(connection: NSXPCConnection(serviceName: serviceName),
                  connectionProtocol: DaemonProtocol.self)
    }
    
    /// Initialization of the Sender instance with concrete Protocol
    /// - Parameters:
    ///   - serviceName: the service name for create connection
    ///   - connectionProtocol: protocol which connection will use to interact with a listener
    public convenience
    init(serviceName: String, connectionProtocol: Protocol) {
        self.init(connection: NSXPCConnection(serviceName: serviceName),
                  connectionProtocol: connectionProtocol)
    }
    
    /// Initialization of the Sender instance with pre-defined DaemonProtocol
    /// - Parameter machServiceName: the match service name for create connection
    public convenience
    init(machServiceName: String) {
        self.init(connection: NSXPCConnection(machServiceName: machServiceName),
                  connectionProtocol: DaemonProtocol.self)
    }
    
    /// Initialization of the Sender instance with concrete Protocol
    /// - Parameters:
    ///   - machServiceName: the match service name for create connection
    ///   - connectionProtocol: protocol which connection will use to interact with a listener
    public convenience
    init(machServiceName: String, connectionProtocol: Protocol) {
        self.init(connection: NSXPCConnection(machServiceName: machServiceName),
                  connectionProtocol: connectionProtocol)
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
