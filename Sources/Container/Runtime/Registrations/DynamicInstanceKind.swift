//
//  InstanceKind.swift
//  blaze
//
//  Created by Andrey Shavelev on 14/06/2019.
//

enum DynamicInstanceKind {
    case `default`
    case perDependency
    case perScope(key: ScopeKey)
}
