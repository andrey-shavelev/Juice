//
// Copyright © 2019 Juice Project. All rights reserved.
//

protocol FactoryProtocol {    
    static func createInstance(_ scope: Scope) -> FactoryProtocol
}

// MARK: Qithout parameters

/// Simplifies creation of multiple components
///
/// For example:
///
///     class Robot: InjectableWith2Parameters {
///         let leftArm: Arm
///         let rightArm: Arm
///         let leftLeg: Leg
///         let rightLeg: Leg
///
///         required init(_ armsFactory: Factory<Arm>,
///                       _ legFactory: Factory<Leg>) throws {
///
///             self.leftArm = try armsFactory.create()
///             self.rightArm = try armsFactory.create()
///             self.leftLeg = try legFactory.create()
///             self.rightLeg = try legFactory.create()
///         }
///     }
///
public class Factory<Service>: FactoryProtocol {
    let scope: Scope

    private init(_ scope: Scope) {
        self.scope = scope
    }

    public func create() throws -> Service {
        return try scope.resolve(Service.self)
    }
    
    static func createInstance(_ scope: Scope) -> FactoryProtocol {
        return Factory<Service>(scope)
    }
}

// MARK: One parameter

/// Simplifies creation of multiple components with parameter
///
/// For example:
///
///     class Robot: InjectableWith2Parameters {
///         let leftArm: Arm
///         let rightArm: Arm
///         let leftLeg: Leg
///         let rightLeg: Leg
///
///         required init(_ armsFactory: Factory1<Side, Arm>,
///                       _ legFactory: Factory1<Side, Leg>) throws {
///
///             self.leftArm = try armsFactory.create(.left)
///             self.rightArm = try armsFactory.create(.right)
///             self.leftLeg = try legFactory.create(.left)
///             self.rightLeg = try legFactory.create(.right)}
///         }
///
public class FactoryWithParameter<Parameter, Service> : FactoryProtocol {
    let scope: Scope

    private init(_ scope: Scope) {
        self.scope = scope
    }

    public func create(_ parameter: Parameter) throws -> Service {
        return try scope.resolve(Service.self,
                                 withArguments: Argument<Parameter>(parameter))
    }
    
    static func createInstance(_ scope: Scope) -> FactoryProtocol {
        return FactoryWithParameter<Parameter, Service>(scope)
    }
}

public typealias Factory1 = FactoryWithParameter

// MARK: Two parameters

/// Simplifies creation of multiple components with parameters
///
/// For example:
///
///     class Robot: InjectableWith2Parameters {
///         let leftArm: Arm
///         let rightArm: Arm
///         let leftLeg: Leg
///         let rightLeg: Leg
///
///         required init(_ armsFactory: FactoryWithParameter<Side, Arm>,
///                       _ legFactory: FactoryWithParameter<Side, Leg>) throws {
///
///             self.leftArm = try armsFactory.create(.left)
///             self.rightArm = try armsFactory.create(.right)
///             self.leftLeg = try legFactory.create(.left)
///             self.rightLeg = try legFactory.create(.right)}
///         }
///
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
    
    static func createInstance(_ scope: Scope) -> FactoryProtocol {
        return FactoryWithTwoParameters<Parameter1, Parameter2, Service>(scope)
    }
}

public typealias FactoryWith2Parameters = FactoryWithTwoParameters
public typealias Factory2 = FactoryWithTwoParameters

// MARK: Three parameters

/// Simplifies creation of multiple components with parameters
///
/// For example:
///
///     class Robot: InjectableWith2Parameters {
///         let leftArm: Arm
///         let rightArm: Arm
///         let leftLeg: Leg
///         let rightLeg: Leg
///
///         required init(_ armsFactory: Factory1<Side, Arm>,
///                       _ legFactory: Factory1<Side, Leg>) throws {
///
///             self.leftArm = try armsFactory.create(.left)
///             self.rightArm = try armsFactory.create(.right)
///             self.leftLeg = try legFactory.create(.left)
///             self.rightLeg = try legFactory.create(.right)}
///         }
///
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
    
    static func createInstance(_ scope: Scope) -> FactoryProtocol {
        return FactoryWithThreeParameters<Parameter1, Parameter2, Parameter3, Service>(scope)
    }
}

public typealias FactoryWith3Parameters = FactoryWithThreeParameters
public typealias Factory3 = FactoryWithThreeParameters

// MARK: Four parameters

/// Simplifies creation of multiple components with parameters
///
/// For example:
///
///     class Robot: InjectableWith2Parameters {
///         let leftArm: Arm
///         let rightArm: Arm
///         let leftLeg: Leg
///         let rightLeg: Leg
///
///         required init(_ armsFactory: Factory1<Side, Arm>,
///                       _ legFactory: Factory1<Side, Leg>) throws {
///
///             self.leftArm = try armsFactory.create(.left)
///             self.rightArm = try armsFactory.create(.right)
///             self.leftLeg = try legFactory.create(.left)
///             self.rightLeg = try legFactory.create(.right)}
///         }
///
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
    
    static func createInstance(_ scope: Scope) -> FactoryProtocol {
        return FactoryWithFourParameters<Parameter1, Parameter2, Parameter3, Parameter4, Service>(scope)
    }
}

public typealias FactoryWith4Parameters = FactoryWithFourParameters
public typealias Factory4 = FactoryWithFourParameters
