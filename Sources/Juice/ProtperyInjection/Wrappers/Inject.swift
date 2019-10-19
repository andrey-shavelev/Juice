//
// Copyright © 2019 Juice Project. All rights reserved.
//

@propertyWrapper
public struct Inject<Service> {
    
    let service: Service
    
    public init() {
        let currentScope = ScopeStack.top!
        self.service = try! currentScope.resolve(Service.self)
    }
    
    public var wrappedValue: Service {
        get {
            self.service
        }
    }
}
