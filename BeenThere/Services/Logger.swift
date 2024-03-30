//
//  Logger.swift
//  BeenThere
//
//  Created by Egor Iskrenkov on 28/8/23.
//

import Foundation
import os.log

class Logger {

    static let shared = Logger()

    var prefix: String?

    init(prefix: String? = nil) {
        self.prefix = prefix
    }

    func debug(_ message: String) {
        log(level: .debug, message: message)
    }

    func info(_ message: String) {
        log(level: .info, message: message)
    }

    func error(_ message: String, _ error: Error? = nil) {
        var fullMessage = message

        if let error = error {
            fullMessage += "\nError Message: \(String(describing: error))"
            fullMessage += "\nLocalized Description: \(error.localizedDescription)"
        }

        log(level: .error, message: fullMessage)
    }

    func log(level: OSLogType, message: String) {
        var fullMessage: String

        if let prefix = self.prefix {
            fullMessage = "[\(prefix)] \(message)"
        } else {
            fullMessage = message
        }

        os_log("%@", type: level, fullMessage)
    }

}
