//
// Copyright © 2019 Juice Project. All rights reserved.
//

protocol FactoryProtocol {    
    static func createInstance(_ scope: Scope) -> Any
}

public class Factory<Service>: FactoryProtocol {
    let scope: Scope

    private init(_ scope: Scope) {
        self.scope = scope
    }

    public func create() throws -> Service {
        return try scope.resolve(Service.self)
    }
    
    static func createInstance(_ scope: Scope) -> Any {
        return Factory<Service>(scope)
    }
}

public class FactoryWithParameter<Parameter, Service> : FactoryProtocol {
    let scope: Scope

    private init(_ scope: Scope) {
        self.scope = scope
    }

    public func create(_ parameter: Parameter) throws -> Service {
        return try scope.resolve(Service.self,
                                 withArguments: Argument<Parameter>(parameter))
    }
    
    static func createInstance(_ scope: Scope) -> Any {
        return FactoryWithParameter<Parameter, Service>(scope)
    }
}

public class FactoryWithTwoParameters<Parameter1, Parameter2, Service> : FactoryProtocol {
    let scope: Scope

    private init(_ scope: Scope) {
        self.scope = scope
    }

    public func create(_ parameter1: Parameter1,
                       _ parameter2: Parameter2) throws -> Service {
        return try scope.resolve(Service.self,
                                 withArguments: Argument<Parameter1>(parameter1),
            Argument<Parameter2>(parameter2))
    }
    
    static func createInstance(_ scope: Scope) -> Any {
        return FactoryWithTwoParameters<Parameter1, Parameter2, Service>(scope)
    }
}

public typealias FactoryWith2Parameters = FactoryWithTwoParameters

public class FactoryWithThreeParameters<Parameter1, Parameter2, Parameter3, Service> : FactoryProtocol {
    let scope: Scope

    private init(_ scope: Scope) {
        self.scope = scope
    }

    public func create(_ parameter1: Parameter1,
                       _ parameter2: Parameter2,
                       _ parameter3: Parameter3) throws -> Service {
        return try scope.resolve(Service.self,
                                 withArguments:
            Argument<Parameter1>(parameter1),
            Argument<Parameter2>(parameter2),
            Argument<Parameter3>(parameter3))
    }
    
    static func createInstance(_ scope: Scope) -> Any {
        return FactoryWithThreeParameters<Parameter1, Parameter2, Parameter3, Service>(scope)
    }
}

public typealias FactoryWith3Parameters = FactoryWithThreeParameters

public class FactoryWithFourParameters<Parameter1, Parameter2, Parameter3, Parameter4, Service> : FactoryProtocol {
    let scope: Scope

    private init(_ scope: Scope) {
        self.scope = scope
    }

    public func create(_ parameter1: Parameter1,
                       _ parameter2: Parameter2,
                       _ parameter3: Parameter3,
                       _ parameter4: Parameter4) throws -> Service {
        return try scope.resolve(Service.self,
                                 withArguments:
            Argument<Parameter1>(parameter1),
            Argument<Parameter2>(parameter2),
            Argument<Parameter3>(parameter3),
            Argument<Parameter4>(parameter4))
    }
    
    static func createInstance(_ scope: Scope) -> Any {
        return FactoryWithFourParameters<Parameter1, Parameter2, Parameter3, Parameter4, Service>(scope)
    }
}

public typealias FactoryWith4Parameters = FactoryWithFourParameters
