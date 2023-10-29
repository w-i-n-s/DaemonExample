//
//  AppDelegate.swift
//  XPCExample
//
//  Created by Sergey Vinogradov on 18.10.23.
//

import Cocoa
import Isolation

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet var window: NSWindow!
    lazy var container: SenderContainer? = SenderContainer(errodDelegate: self)

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        guard let container else { return }
        
        print("start >>")
              
        container.sendPerformSome()
        
        container.sendAString(string: " -= Greetings! =-")
        container.sendPerformWith(string: "True is", flag: true) { result in
            print("Received from demon: \(result)")
             // fatalError()
        }
        
        print("stop >>")
        
        print("try return result directly, expect crush")
        container.sendPerformWith(flag: false)
        
        print("try not implemented, expect crush")
        container.sendPerformWithInt(value: 42)
        
//        self.container = nil
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
}

extension AppDelegate: ErrorDelegate {
    func onSenderError(_ error: SenderError) {
        print("Can't send because of: \(error.localizedDescription)")
    }
}
