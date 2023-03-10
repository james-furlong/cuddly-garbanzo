//
//  Injector.swift
//  Dexcom Monitor
//
//  Created by James on 30/12/2022.
//

import Foundation

enum Injector {}
enum Network {}

private let defaultEnvironment: Environment = {
    var environment: TargetEnvironment = TargetEnvironment.staging
    if Bundle.appTarget == "Staging" {
        let defaultEnv = TargetEnvironment.staging
        let targetInt: Int = UserDefaults.standard.integer(forKey: Constants.Application.targetKey.rawValue)
        environment = TargetEnvironment(rawValue: (targetInt != 0 ? targetInt : defaultEnv.rawValue))
            .defaulting(to: defaultEnv)
    }

    return environment.createEnvironment()
}()

// MARK: - Injectable Types for Environment and App

extension Injector {
    static var testRunningOverride: Bool = {
        (ProcessInfo.processInfo.environment["XCInjectBundleInto"] != nil)
    }()
    static var isRunningTests: Bool {
        return (
            testRunningOverride &&
            (ProcessInfo.processInfo.environment["XCInjectBundleInto"] != nil)
        )
    }
    
    static var target: TargetEnvironment = defaultEnvironment.target {
        didSet {
            func configure(environment: Environment) {
                Injector.session = environment.session
                Injector.version = environment.version

                Injector.apiClient = environment.apiClient
                Injector.auth = environment.auth
            }

            // Cache the environment change
            UserDefaults.standard.set(
                Injector.target.rawValue,
                forKey: Constants.Application.targetKey.rawValue
            )

            // Configure the environment
            configure(environment: Injector.target.createEnvironment())
        }
    }

    // Note: The below may differ per environment, at the very least each environment should
    // have it's own instance
    static var httpProtocol: String = defaultEnvironment.httpProtocol
    static var session: URLSession = defaultEnvironment.session
    static var baseUrl: String = defaultEnvironment.baseUrl
    static var version: String = defaultEnvironment.version

    static var apiClient: ApiClientType = defaultEnvironment.apiClient
    static var auth: AuthClient = defaultEnvironment.auth
    
    static var cache: CacheClient = CacheClient()
    static var log: Logger = Logger()
}

