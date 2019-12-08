//
// Copyright © 2019 Juice Project. All rights reserved.
//

protocol FactoryProtocol {    
    static func createInstance(_ scope: Scope) -> FactoryProtocol
}

// MARK: Without parameters

/// Resolves multiple instances of the same service from the `CurrentScope`
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
/// - Note: For single-instance and instance-per-container services always returns the same instance.
/// - Note: Keeps reference to `CurrentScope` of the component.
///
public class Factory<Service>: FactoryProtocol {
    let scope: Scope

    private init(_ scope: Scope) {
        self.scope = scope
    }

    public func create() throws -> Service {
        try scope.resolve(Service.self)
    }
    
    static func createInstance(_ scope: Scope) -> FactoryProtocol {
        Factory<Service>(scope)
    }
}

// MARK: One parameter

/// Resolves multiple instances of the same service from the `CurrentScope`
///
/// Allows to pass one parameter of type `Parameter` each time the service is resolved.
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
/// - Note: For single-instance and instance-per-container services always returns the same instance.
/// - Note: Keeps reference to `CurrentScope` of the component.
///
public class FactoryWithParameter<Parameter, Service> : FactoryProtocol {
    let scope: Scope

    private init(_ scope: Scope) {
        self.scope = scope
    }

    public func create(_ parameter: Parameter) throws -> Service {
        try scope.resolve(Service.self,
                                 withArguments: Argument<Parameter>(parameter))
    }
    
    static func createInstance(_ scope: Scope) -> FactoryProtocol {
        FactoryWithParameter<Parameter, Service>(scope)
    }
}

public typealias Factory1 = FactoryWithParameter

// MARK: Two parameters

/// Resolves multiple instances of the same service from the `CurrentScope`
///
/// Allows to pass parameters of type `Parameter1` and `Parameter2` each time the service is resolved.
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
/// - Note: For single-instance and instance-per-container services always returns the same instance.
/// - Note: Keeps reference to `CurrentScope` of the component.
///
public class FactoryWithTwoParameters<Parameter1, Parameter2, Service> : FactoryProtocol {
    let scope: Scope

    private init(_ scope: Scope) {
        self.scope = scope
    }

    public func create(_ parameter1: Parameter1,
                       _ parameter2: Parameter2) throws -> Service {
        try scope.resolve(Service.self,
                                 withArguments: Argument<Parameter1>(parameter1),
            Argument<Parameter2>(parameter2))
    }
    
    static func createInstance(_ scope: Scope) -> FactoryProtocol {
        FactoryWithTwoParameters<Parameter1, Parameter2, Service>(scope)
    }
}

public typealias FactoryWith2Parameters = FactoryWithTwoParameters
public typealias Factory2 = FactoryWithTwoParameters

// MARK: Three parameters

/// Resolves multiple instances of the same service from the `CurrentScope`
///
/// Allows to pass parameters of type `Parameter1`, `Parameter2` and `Parameter3` each time the service is resolved.
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
/// - Note: For single-instance and instance-per-container services always returns the same instance.
/// - Note: Keeps reference to `CurrentScope` of the component.
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
        FactoryWithThreeParameters<Parameter1, Parameter2, Parameter3, Service>(scope)
    }
}

public typealias FactoryWith3Parameters = FactoryWithThreeParameters
public typealias Factory3 = FactoryWithThreeParameters

// MARK: Four parameters

/// Resolves multiple instances of the same service from the `CurrentScope`
///
/// Allows to pass parameters of type `Parameter1`, `Parameter2`,
/// `Parameter3` and `Parameter4` each time the service is resolved.
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
/// - Note: For single-instance and instance-per-container services always returns the same instance.
/// - Note: Keeps reference to `CurrentScope` of the component.
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
