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
    required init(inScope scope: Scope) throws {
        fruit = try scope.resolve(Fruit.self)
    }
}

class Cocktail: InjectableWithFourParameters {
    let fruitJuice: Juice
    let lime: Lime
    let sweetener: Sweetener
    let water: Water

    required init(_ fruitJuice: Juice,
                  _ lime: Lime,
                  _ sweetener: Sweetener,
                  _ water: Water) {
        self.fruitJuice = fruitJuice
        self.lime = lime
        self.sweetener = sweetener
        self.water = water
    }
}

class IcyLemonade: InjectableWithFiveParameters {
    let fruitJuice: Juice
    let lemon: Lemon
    let sweetener: Sweetener
    let water: Water
    let ice: Ice

    required init(_ fruitJuice: Juice,
                  _ lemon: Lemon,
                  _ sweetener: Sweetener,
                  _ water: Water,
                  _ ice: Ice) {
        self.fruitJuice = fruitJuice
        self.lemon = lemon
        self.sweetener = sweetener
        self.water = water
        self.ice = ice
    }
}

class TeaBlend: CustomInjectable {
    let tea: Tea
    let fruit: Fruit
    let berry: Berry
    let flower: Flower
    let herb: Herb
    let spice: Spice

    required init(inScope scope: Scope) throws {
        self.tea = try scope.resolve(Tea.self)
        self.fruit = try scope.resolve(Fruit.self)
        self.berry = try scope.resolve(Berry.self)
        self.flower = try scope.resolve(Flower.self)
        self.herb = try scope.resolve(Herb.self)
        self.spice = try scope.resolve(Spice.self)
    }
}