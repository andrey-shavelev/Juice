//
// Copyright © 2019 Juice Project. All rights reserved.
//

/// Container for a lazy dependency.
///
/// An instance of a service is resolved only when
/// `getValue` method is called for the first time.
///
/// - Note: Keeps reference to `CurrentScope` of the component until instance of the service is resolved.
/// After that, reference to `CurrentScope` is released.
///
public class Lazy<T> : LazyProtocol {
    static func createInstance(_ scope: CurrentScope) -> LazyProtocol {
        Lazy<T>(scope)
    }
    
    var state: State
    
    private init(_ currentScope: CurrentScope) {
        self.state = .uninitialized(currentScope: currentScope)
    }

    /// Returns the instance of the service `T`.
    ///
    /// Instance is resolved from `CurrentScope` that is released afterwards.
    ///
    public func getValue() throws -> T {        
        switch self.state {
        case .uninitialized(let currentScope):
            let value = try currentScope.resolve(T.self)
            self.state = .initialized(value: value)
            return value
        case .initialized(let value):
            return value
        }
    }
    
    enum State {
        case uninitialized(currentScope: CurrentScope)
        case initialized(value: T)
    }
}

protocol LazyProtocol {
    static func createInstance(_ scope: CurrentScope) -> LazyProtocol
}
