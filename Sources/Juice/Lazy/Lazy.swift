//
// Copyright © 2019 Juice Project. All rights reserved.
//

public struct Lazy<T> : LazyProtocol {
    static func createInstance(_ scope: CurrentScope) -> LazyProtocol {
        Lazy<T>(scope)
    }
    
    let currentScope: CurrentScope
    
    private init(_ currentScope: CurrentScope) {
        self.currentScope = currentScope
    }
    
    public lazy var value : T = {
        try! self.currentScope.resolve(T.self)
    }()
}

protocol LazyProtocol {
    static func createInstance(_ scope: CurrentScope) -> LazyProtocol
}
