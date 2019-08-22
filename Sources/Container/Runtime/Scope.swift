//
//  Scope.swift
//  blaze
//
//  Created by Andrey Shavelev on 19/06/2019.
//

public protocol Scope {
    func resolve<Service>(_ serviceType: Service.Type) throws -> Service
    func resolve<Service>(_ serviceType: Service.Type, withParameters parameters: [Any]) throws -> Service

    var isValid: Bool { get }
}

public extension Scope {
    func resolve<Service>(_ serviceType: Service.Type, withParameters parameters: Any...) throws -> Service {
        return try resolve(serviceType, withParameters: parameters)
    }
}
