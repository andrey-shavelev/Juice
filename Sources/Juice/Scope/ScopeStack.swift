//
// Copyright © 2019 Juice Project. All rights reserved.
//

class ScopeStack {
    
    private static var stack = [Scope]()
    private static var globalScope: Scope?
    
    class var top: Scope? {
        get {
            stack.last ?? globalScope
        }
    }
    
    class func setGlobalScope(_ scope: Scope) {
        globalScope = scope
    }
    
    class func push(_ scope: Scope) {
        stack.append(scope)
    }
    
    class func pop() {
        stack.removeLast()
    }
}
