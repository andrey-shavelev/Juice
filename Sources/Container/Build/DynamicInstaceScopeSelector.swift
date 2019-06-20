//
//  ServiceScopeSelector.swift
//  blaze
//
//  Created by Andrey Shavelev on 17/06/2019.
//

import Foundation

public struct DynamicInstaceScopeSelector<Type> {
    let builder: ContainerBuilder
    let serviceRegistration: DynamicInstanceRegistration
    
    internal init(
        serviceRegistration: DynamicInstanceRegistration,
        builder: ContainerBuilder) {
        self.serviceRegistration = serviceRegistration
        self.builder = builder
    }
    
    @discardableResult
    public func singleInstance() -> DynamicInstanceRegistrationBuilder<Type> {
        serviceRegistration.serviceKind = .container
        return DynamicInstanceRegistrationBuilder(serviceRegistration: serviceRegistration, builder: builder)
    }
    
    @discardableResult
    func instancePerDependency() -> DynamicInstanceRegistrationBuilder<Type> {
        serviceRegistration.serviceKind = .dependency
        return DynamicInstanceRegistrationBuilder(serviceRegistration: serviceRegistration, builder: builder)
    }
}
