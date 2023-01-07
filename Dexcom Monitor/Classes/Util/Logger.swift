//
//  Logger.swift
//  Dexcom Monitor
//
//  Created by James on 30/12/2022.
//

import UIKit

// Wrap the print() function within a DEBUG flag to ensure that any print statements are only called when
// in DEBUG mode
func print(_ object: Any) {
    #if DEBUG
    Swift.print(object)
    #endif
}

/// This is the logger that should be used for any logging throughout the application. Any errors will be sent through to Crashlytics as a
/// non-fatal error
class Logger {
    enum LogLevel: Int, Comparable {
        case none
        case errors             // Errors only
        case errorsAndWarnings  // Warnings and errors
        case debug              // Debug, Warnings and errors
        case verbose            // Everything
        
        static func < (lhs: LogLevel, rhs: LogLevel) -> Bool {
            return (lhs.rawValue < rhs.rawValue)
        }
    }
    
    private enum NonFatalError: Error, LocalizedError {
        case value(String)
        
        var errorDescription: String? {
            switch self {
                case .value(let message): return message
            }
        }
    }
    
    var logLevel: LogLevel = .errorsAndWarnings
    
    // MARK: - Public Methods
    
    /// Logs an error to the console and sends the error message through to Crashlytics as a non-fatal error
    func error(_ object: Any, filePath: String = #file, line: Int = #line, funcName: String = #function) {
        
        // Note: This error won't be sent to Crashlytics until the app is next launched
//        Crashlytics.crashlytics()
//            .record(
//                error: NSError(
//                    domain: "\(object)",
//                    code: 0,
//                    userInfo: [
//                        "filePath": filePath,
//                        "line": line,
//                        "functionName": funcName,
//                        "AppVersion": UpdateManager.currentAppVersion.toString(),
//                        "OS": UIDevice.current.systemVersion,
//                        "Device": UIDevice.modelName
//                    ]
//                )
//            )
        
        guard logLevel >= LogLevel.errors else { return }
        print("‼️ ERROR: \(object)\n\(functionCallInfo(filePath: filePath, line: line, funcName: funcName))")
    }
    
    func warning(_ object: Any, filePath: String = #file, line: Int = #line, funcName: String = #function) {
        guard !Injector.isRunningTests else { return }
        guard logLevel >= LogLevel.errorsAndWarnings else { return }
        print("⚠️ WARNING: \(object)\n\(functionCallInfo(filePath: filePath, line: line, funcName: funcName))")
    }
    
    func debug(_ object: Any) {
        guard !Injector.isRunningTests else { return }
        guard logLevel >= LogLevel.debug else { return }
        print("🦠 DEBUG: \(object)")
    }
    
    func verbose(_ object: Any, filename: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
        guard !Injector.isRunningTests else { return }
        guard logLevel >= LogLevel.verbose else { return }
        print("🔬 VERBOSE: \(object)")
    }
    
    // MARK: - Internal Methods
    
    private func functionCallInfo(filePath: String, line: Int, funcName: String) -> String {
        let components = filePath.components(separatedBy: "/")
        return "[\(Date())] \(components.last ?? ""), line \(line), \(funcName)"
    }
}
