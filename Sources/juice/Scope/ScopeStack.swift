//
// Copyright © 2019 Juice Project. All rights reserved.
//

class ScopeStack {
    
    private static var stack = [Scope]()
    
    class var top: Scope? {
        get {
            stack.last
        }
    }
    
    class func push(_ currentScope: Scope) {
        stack.append(currentScope)
    }
    
    class func pop() {
        stack.removeLast()
    }
    
}
