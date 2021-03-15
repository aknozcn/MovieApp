//
//  LogIt.swift
//  MovieApp
//
//  Created by sh3ll on 7.03.2021.
//

import Foundation

class Logger {

    static func LogIt(_ msg: String, _ logType: LogType) {

        switch logType {
        case .succcess:
            print("\(logType.rawValue) [\(msg)]")
        case .warning:
            print("\(logType.rawValue) [\(msg)]")
        case .error:
            print("\(logType.rawValue) [\(msg)]")
        case .action:
            print("\(logType.rawValue) [\(msg)]")
        }
    }
}
