//
// Created by Andrey Shavelev on 03/09/2019.
//
import blaze

protocol Juice: Drink {
    var fruit: Fruit { get }
}

protocol Smoothie: Drink{
}

class Apple: Fruit, Injectable {
    required init() {
    }
}

class Orange: Fruit, Injectable {
    required init() {
    }
}

class Banana: Fruit, Injectable {
    required init() {
    }
}

class Pear: Fruit, Injectable {
    required init() {
    }
}

class Raspberry: Berry, Injectable {
    required init() {
    }
}

class Blueberry: Berry, Injectable {
    required init() {
    }
}

class Strawberry: Berry, Injectable {
    required init() {
    }
}

struct Vanilla: Spice, Injectable {
}

struct Cinnamon: Spice, Injectable {
}

struct Cloves: Spice, Injectable {
}

struct Ginger: Spice, Injectable {
}

class Chocolate: InjectableWithParameter {
    enum Kind {
        case milk
        case dark
        case white
    }

    let kind: Kind

    required init(_ kind: Kind) {
        self.kind = kind
    }
}