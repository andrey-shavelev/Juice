//
//  Scope.swift
//  blaze
//
//  Created by Andrey Shavelev on 19/06/2019.
//

public protocol Scope {
    func resolve<TInstance>(_ serviceType: TInstance.Type) throws -> TInstance
}
