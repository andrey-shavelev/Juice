//
// Copyright © 2019 Juice Project. All rights reserved.
//

import XCTest
import Juice

final class CurrentScopeTests: XCTestCase {

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
        let injectable = try container?.resolve(CustomInjectableThatHoldsReferenceToScope.self, withArguments: ignoredParameter)
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
        let injectable = try container!.resolve(CustomInjectableThatHoldsReferenceToScope.self, withArguments: ignoredParameter)
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
        let strongReference = try container!.resolve(CustomInjectableThatHoldsReferenceToScope.self, withArguments: ignoredParameter)
        container = nil

        XCTAssertThrowsError(try strongReference.scope.resolve(Apple.self))
    }
}

class CustomInjectableThatHoldsReferenceToScope: InjectableWithParameter {
    let scope: CurrentScope
    required init(_ scope: CurrentScope) throws {
        self.scope = scope
    }
}
