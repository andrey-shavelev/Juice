//
// Copyright © 2019 Juice Project. All rights reserved.
//

/// Container for a lazy dependency.
///
/// Actual service is resolved only when `getValue` is called first time.
///
/// - Note: Captures `CurrentScope` of component and keeps it until value is resolved.
/// After that, reference to `CurrentScope` is released.
///
public class Lazy<T> : LazyProtocol {
    static func createInstance(_ scope: CurrentScope) -> LazyProtocol {
        Lazy<T>(scope)
    }
    
    var state: LazyState<T>
    
    private init(_ currentScope: CurrentScope) {
        self.state = .uninitialized(currentScope: currentScope)
    }

    /// Returns the instance of service.
    ///
    /// Value is resolved from `CurrentScope`that is released afterwards.
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
}

enum LazyState<T> {
    case uninitialized(currentScope: CurrentScope)
    case initialized(value: T)
}

protocol LazyProtocol {
    static func createInstance(_ scope: CurrentScope) -> LazyProtocol
}
