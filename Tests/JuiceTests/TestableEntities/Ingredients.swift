//
// Copyright © 2019 Juice Project. All rights reserved.
//

import Juice

protocol Fruit {
}

protocol Berry {
}

protocol Spice {
}

protocol Drink {
}

protocol Water {
}

protocol Sweetener {
}

protocol Tea {
}

protocol Flower {
}

protocol Herb {
}

protocol Juice: Drink {
    var fruit: Fruit { get }
}

protocol Smoothie: Drink {
    var fruit: Fruit { get }
    var berry: Berry { get }
    var juice: Juice { get }
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

class Lemon: Fruit, Injectable {
    required init() {
    }
}

class Lime: Fruit, Injectable {
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

struct Sugar: Sweetener, Injectable {
}

struct SodaWater: Water, Injectable {
}

struct Ice: Injectable {
}

struct Mint: Herb, Injectable {
}

struct Lotus: Flower, Injectable {
}

struct Pu_er: Tea, Injectable {
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

