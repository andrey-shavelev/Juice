//
// Copyright © 2019 Juice Project. All rights reserved.
//

enum DynamicInstanceKind {
    case perDependency
    case perScope(key: ScopeKey)
}
