//
//  ResolutionScopeTests.swift
//  blazeTests
//
//  Created by Andrey Shavelev on 29/06/2019.
//

import XCTest
import blaze

final class ResolutionScopeTests: XCTestCase {

    func testResolutionScopeHoldsWeakReferenceToMainScope() throws {
        var container: Container? = try Container { builder in
            builder.register(injectable: CustomInjectableThatHoldsReferenceToScope.self)
                    .instancePerDependency()
                    .asSelf()
        }

        let injectable = try container?.resolve(CustomInjectableThatHoldsReferenceToScope.self)
        weak var weakContainerReference = container
        container = nil

        XCTAssertNotNil(injectable)
        XCTAssertNil(weakContainerReference)
    }

    func testResolutionScopeBecomesInvalidAfterMainScopeIsDeallocated() throws {
        var container: Container? = try Container { builder in
            builder.register(injectable: CustomInjectableThatHoldsReferenceToScope.self)
                    .instancePerDependency()
                    .asSelf()
        }

        let strongReference = try container!.resolve(CustomInjectableThatHoldsReferenceToScope.self)
        container = nil

        XCTAssertFalse(strongReference.scope.isValid)
    }

    func testParametrizedResolutionScopeHoldsWeakReferenceToMainScope() throws {
        var container: Container? = try Container { builder in
            builder.register(injectable: CustomInjectableThatHoldsReferenceToScope.self)
                    .instancePerDependency()
                    .asSelf()
        }

        let ignoredParameter = 42
        let injectable = try container?.resolve(CustomInjectableThatHoldsReferenceToScope.self, withParameters: ignoredParameter)
        weak var weakContainerReference = container
        container = nil

        XCTAssertNotNil(injectable)
        XCTAssertNil(weakContainerReference)
    }

    func testParametrizedResolutionScopeBecomesInvalidAfterMainScopeIsDeallocated() throws {
        var container: Container? = try Container { builder in
            builder.register(injectable: CustomInjectableThatHoldsReferenceToScope.self)
                    .instancePerDependency()
                    .asSelf()
        }

        let ignoredParameter = 42
        let injectable = try container!.resolve(CustomInjectableThatHoldsReferenceToScope.self, withParameters: ignoredParameter)
        container = nil

        XCTAssertFalse(injectable.scope.isValid)
    }

    func testInvalidResolutionScopeThrowsErrorWhenResolvingDependency() throws {
        var container: Container? = try Container { builder in
            builder.register(injectable: Apple.self)
                    .instancePerDependency()
                    .asSelf()

            builder.register(injectable: CustomInjectableThatHoldsReferenceToScope.self)
                    .instancePerDependency()
                    .asSelf()
        }

        let strongReference = try container!.resolve(CustomInjectableThatHoldsReferenceToScope.self)
        container = nil

        XCTAssertThrowsError(try strongReference.scope.resolve(Apple.self))
    }

    func testInvalidParametrizedResolutionScopeThrowsErrorWhenResolvingDependency() throws {
        var container: Container? = try Container { builder in
            builder.register(injectable: Apple.self)
                    .instancePerDependency()
                    .asSelf()

            builder.register(injectable: CustomInjectableThatHoldsReferenceToScope.self)
                    .instancePerDependency()
                    .asSelf()
        }

        let ignoredParameter = 42
        let strongReference = try container!.resolve(CustomInjectableThatHoldsReferenceToScope.self, withParameters: ignoredParameter)
        container = nil

        XCTAssertThrowsError(try strongReference.scope.resolve(Apple.self))
    }
}

class CustomInjectableThatHoldsReferenceToScope: CustomInjectable {
    let scope: Scope
    required init(inScope scope: Scope) throws {
        self.scope = scope
    }
}
