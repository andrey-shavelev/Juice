//
// Copyright © 2019 Juice Project. All rights reserved.
//

/// Contains registrations for a group of components
///
public protocol Module {
    /// Registers all services in `containerBuilder`
    ///
    /// - Parameter containerBuilder: A builder that this method must use to register all services
    ///
    func registerServices(into containerBuilder: ContainerBuilder)
}
