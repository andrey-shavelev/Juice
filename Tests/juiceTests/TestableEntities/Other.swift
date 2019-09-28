//
// Copyright © 2019 Juice Project. All rights reserved.
//

import juice

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
