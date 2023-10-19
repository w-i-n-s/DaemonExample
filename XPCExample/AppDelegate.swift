//
//  AppDelegate.swift
//  XPCExample
//
//  Created by Sergey Vinogradov on 18.10.23.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet var window: NSWindow!


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        Sender.shared.sendPerformSome()
        Sender.shared.sendAString(string: " -= Greetings! =-")

        print("try not implemented, expect crush")
        Sender.shared.sendPerformWithInt(value: 42)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }


}

