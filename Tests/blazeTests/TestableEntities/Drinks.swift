//
// Created by Andrey Shavelev on 03/09/2019.
//

import blaze

class FreshJuice: InjectableWithParameter, Juice {
    let fruit: Fruit

    required init(_ fruit: Fruit) {
        self.fruit = fruit
    }
}

class Compote: InjectableWithTwoParameters {
    let fruit: Fruit
    let spice: Spice

    required init(_ fruit: Fruit, _ spice: Spice) {
        self.spice = spice
        self.fruit = fruit
    }
}

class Jam: Injectable {
    var fruit: Fruit!
    var spice: Spice?

    required init() {
    }
}

class FreshMorningSmoothie: InjectableWithThreeParameters, Smoothie {
    let fruit: Fruit
    let berry: Berry
    let juice: Juice

    required init(_ fruit: Fruit, _ berry: Berry, _ juice: Juice) {
        self.fruit = fruit
        self.berry = berry
        self.juice = juice
    }
}

class HomeMadeJuice: CustomInjectable {
    let fruit: Fruit
    required init(receiveDependenciesFrom scope: Scope) throws {
        fruit = try scope.resolve(Fruit.self)
    }
}