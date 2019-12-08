//
// Copyright © 2019 Juice Project. All rights reserved.
//

/// Contains registrations for a group of components
///
public protocol Module {
    /// Registers services in `containerBuilder`
    ///
    func registerServices(into builder: ContainerBuilder)
}
