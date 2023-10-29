//
//  SenderError.swift
//  Isolation
//
//  Created by Sergey Vinogradov on 25.10.23.
//

public
enum SenderError: Error {
    case proxyUnavailable
}

extension SenderError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .proxyUnavailable:
            return "Proxy UnAvailable"
        }
    }
}

public
protocol ErrorDelegate {
    func onSenderError(_ error: SenderError)
}

public
protocol ErrorDelegateProtocol {
    var errorDelegate: ErrorDelegate? { get set }
}
