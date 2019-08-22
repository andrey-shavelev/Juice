//
//  File.swift
//  blazeTests
//
//  Created by Andrey Shavelev on 06/06/2019.
//

import Foundation
import blaze

class FirstDependency: Injectable {
    required init() {
    }
}

class SecondDependency: Injectable {
    required init() {
    }
}

class ThirdDependency: Injectable {
    required init() {
    }
}

class FourthDependency: Injectable {
    required init() {
    }
}

class FithDependency: Injectable {
    required init() {
    }
}

class SixthDependency: Injectable {
    required init() {
    }
}

class ServiceWithThreeParameters: InjectableWithThreeParameters {

    let firstDependency: FirstDependency
    let secondDependency: SecondDependency
    let thirdDependency: ThirdDependency

    required init(_ firstParameter: FirstDependency,
                  _ secondParameter: SecondDependency,
                  _ thirdParameter: ThirdDependency) {
        self.firstDependency = firstParameter
        self.secondDependency = secondParameter
        self.thirdDependency = thirdParameter
    }
}

class ServiceWithFourParameters: InjectableWithFourParameters {

    let firstDependency: FirstDependency
    let secondDependency: SecondDependency
    let thirdDependency: ThirdDependency
    let fourthDependency: FourthDependency

    required init(_ firstParameter: FirstDependency,
                  _ secondParameter: SecondDependency,
                  _ thirdParameter: ThirdDependency,
                  _ fourthParameter: FourthDependency) {
        self.firstDependency = firstParameter
        self.secondDependency = secondParameter
        self.thirdDependency = thirdParameter
        self.fourthDependency = fourthParameter
    }
}

class ServiceWithFiveParameters: InjectableWithFiveParameters {
    let firstDependency: FirstDependency
    let secondDependency: SecondDependency
    let thirdDependency: ThirdDependency
    let fourthDependency: FourthDependency
    let fithDependency: FithDependency

    required init(_ firstParameter: FirstDependency,
                  _ secondParameter: SecondDependency,
                  _ thirdParameter: ThirdDependency,
                  _ fourthParameter: FourthDependency,
                  _ fithParameter: FithDependency) {
        self.firstDependency = firstParameter
        self.secondDependency = secondParameter
        self.thirdDependency = thirdParameter
        self.fourthDependency = fourthParameter
        self.fithDependency = fithParameter
    }
}

class ServiceWithCustomParameters: CustomInjectable {
    let firstDependency: FirstDependency
    let secondDependency: SecondDependency
    let thirdDependency: ThirdDependency
    let fourthDependency: FourthDependency
    let fithDependency: FithDependency
    let sixthDependency: SixthDependency

    required init(receiveDependenciesFrom scope: Scope) throws {
        firstDependency = try scope.resolve(FirstDependency.self)
        secondDependency = try scope.resolve(SecondDependency.self)
        thirdDependency = try scope.resolve(ThirdDependency.self)
        fourthDependency = try scope.resolve(FourthDependency.self)
        fithDependency = try scope.resolve(FithDependency.self)
        sixthDependency = try scope.resolve(SixthDependency.self)
    }
}

class CustomInjectableThatHoldsReferenceToScope: CustomInjectable {

    let scope: Scope

    required init(receiveDependenciesFrom scope: Scope) throws {
        self.scope = scope
    }
}
