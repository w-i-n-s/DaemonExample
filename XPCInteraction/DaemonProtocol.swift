//
//  DaemonProtocol.swift
//  Daemon
//
//  Created by Sergey Vinogradov on 18.10.23.
//

import Foundation

@objc public
protocol Interaction_OneWay {
    func performSome()
}

@objc public
protocol Interaction_OneWayWithParameter {
    func performWithString(string: String)
    
    @objc optional
    func performWithInt(value: Int)
    
    func performWithDict(dict: Dictionary<String, Any>)
}

// Can't return as a result of function because it's async
// In case if we just need async with completion without any return
// results then we should return dummy result like int/bool
@objc public
protocol Interaction_WithCompletion {
    func performWith(string: String, flag: Bool, completion: @escaping (String) -> Void)
    
    // Origin of uncaught exception was raised.
    // Return type of methods sent over this proxy must be 'void' or 'NSProgress *'
    func performWith(flag: Bool) -> String
}

// We can add whatever we actually want into reply's
// struct instead of enum to avoid .rawValue
public
struct ResultDictionaryKeys {
    static let error = "ResultKeyError"
    static let body = "ResultKeyBody"
}

@objc public
protocol Interaction_WithResult {
    // As soon as protocol is objc then we can return only one result, so next is not available
    // func performSomethingDifferent(value: Int, completion: @escaping (Result<String, Error>) -> Void)
    
    // Here we agree to use ResultDictionaryKeys to get all we need from listener
    func performSomethingDifferent(value: Int, completion: @escaping (Dictionary<String, Any>) -> Void)
}

// MARK: - API

/// The protocol that this service will vend as its API. This protocol will also need to be visible to the process hosting the service.
@objc public
protocol DaemonProtocol: Interaction_OneWay, Interaction_OneWayWithParameter, Interaction_WithCompletion {
    
    // Here only API high level functions
    func version(completion: @escaping (String) -> Void)
}

/*
// @objc can only be used with members of classes, @objc protocols, and concrete extensions of classes
// So, POP isn't useful here
extension DaemonProtocol {
    
    @objc
    func version(completion: @escaping (String) -> Void) {
        completion("0.0.1")
    }
}
*/
