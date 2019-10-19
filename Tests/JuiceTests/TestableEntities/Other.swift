//
// Copyright © 2019 Juice Project. All rights reserved.
//

import Juice

class Yin: InjectableWithParameter {
    let yang: Yang
    required init(_ yang: Yang) {
        self.yang = yang
    }
}

class Yang: InjectableWithParameter {
    let yin: Yin
    required init(_ yin: Yin) {
        self.yin = yin
    }
}

class Chicken: Injectable {
    unowned var egg: Egg!
    
    required init() {
    }
}

class Egg: Injectable {
    var chicken: Chicken!
    
    required init() {
    }
}

class JuiceMachine: InjectableWithParameter {
    let container: Container

    required init(_ scope: CurrentScope) throws {
        container = try scope.createChildContainer { builder in
            builder
                .register(injectable: FreshJuice.self)
                .instancePerDependency()
                .as(Juice.self)
        }
    }

    func makeJuice() -> Juice? {
        do {
            return try container.resolve(Juice.self)
        }
        catch {
            return nil
        }
    }
}

struct Tuna: Injectable {
    
}

struct Cucumber: Injectable {
    
}

struct Mayo: Injectable {
    
}

struct Omelette: Injectable {
    
}
