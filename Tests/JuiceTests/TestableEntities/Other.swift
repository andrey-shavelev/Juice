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
    var egg: Egg!
    
    required init() {
    }
}

class Egg: Injectable {
    unowned var chicken: Chicken!
    
    required init() {
    }
}

class LazyChicken: InjectableWithParameter {
    var egg: Lazy<LazyEgg>
    
    required init(_ egg: Lazy<LazyEgg>) {
        self.egg = egg
    }
}

class LazyEgg: InjectableWithParameter {
    unowned var chicken: LazyChicken
    
    required init(_ chicken: LazyChicken) {
        self.chicken = chicken
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

