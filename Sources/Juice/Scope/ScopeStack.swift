//
// Copyright © 2019 Juice Project. All rights reserved.
//

import Foundation

class ScopeStack {
    
    private static var stack = [Scope]()
    private static var globalScope: (Scope, UUID)?
    
    class var top: Scope? {
        get {
            stack.last ?? globalScope?.0
        }
    }
    
    class func setGlobalScope(_ scope: Scope) -> UUID {
        let uuid = UUID()
        globalScope = (scope, uuid)
        return uuid
    }
    
    class func resignGlobalScope(withUuid uuid: UUID) {
        if globalScope?.1 == uuid {
            globalScope = nil
        }
    }
    
    class func push(_ scope: Scope) {
        stack.append(scope)
    }
    
    class func pop() {
        stack.removeLast()
    }
}

