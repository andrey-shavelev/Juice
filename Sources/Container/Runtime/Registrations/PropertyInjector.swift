//
//  PropertyInjector.swift
//  blaze
//
//  Created by Andrey Shavelev on 08/06/2019.
//

protocol PropertyInjector {
    func inject(into instance: Any, resolveFrom scope: Scope) throws
}

struct TypedPropertyInjector<Type, Value>: PropertyInjector {

    let propertyPath: WritableKeyPath<Type, Value?>

    init(_ propertyPath: WritableKeyPath<Type, Value?>) {
        self.propertyPath = propertyPath
    }

    func inject(into instance: Any, resolveFrom scope: Scope) throws {
        var typedInstance = instance as! Type
        typedInstance[keyPath: propertyPath] = try scope.resolve(Value.self)
    }
}
