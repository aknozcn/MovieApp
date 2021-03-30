//
//  LogIt.swift
//  MovieApp
//
//  Created by sh3ll on 7.03.2021.
//

import Foundation

class Logger {

    static func LogIt(_ msg: String, _ logType: LogType) {
        
        print("\(logType.rawValue) [\(msg)]")
        
    }
}
