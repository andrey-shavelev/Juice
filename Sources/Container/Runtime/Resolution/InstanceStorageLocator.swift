//
//  InstanceStorageLocator.swift
//  blaze
//
//  Created by Andrey Shavelev on 18/07/2019.
//

protocol InstanceStorageLocator {
    func findStorage(matchingKey key: ScopeKey) -> InstanceStorage?
}
