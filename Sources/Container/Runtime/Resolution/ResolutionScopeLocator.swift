//
//  ResolutionScopeLocator.swift
//  blaze
//
//  Created by Andrey Shavelev on 18/07/2019.
//

protocol ResolutionScopeLocator {
    func findScope(matchingKey key: ScopeKey) -> Scope?
}
