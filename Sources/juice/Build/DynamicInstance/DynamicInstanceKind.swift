//
// Copyright © 2019 Andrey Shavelev. All rights reserved.
//

enum DynamicInstanceKind {
    case perDependency
    case perScope(key: ScopeKey)
}
