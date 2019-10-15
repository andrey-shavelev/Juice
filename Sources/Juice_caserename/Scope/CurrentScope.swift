//
// Copyright © 2019 Juice Project. All rights reserved.
//

/// A scope containing a set of dependencies for a component being created.
///
/// At runtime `CurrentScope` is represented by a wrapper-type over a `Container` that might hold additional arguments.
/// Any component could access `CurrentScope` from its init() method.
/// Please note, that your component may also keeping a reference to `CurrentScope` to, for example, resolve dependencies at a later stage.
/// However, `CurrentScope` itself keeps a weak reference to the container.
/// That means that if by any mistake your component has a longer lifetime than its container,
/// `CurrentScope` might become invalid and resolve method will throw an error.
/// If your component by design lives longer then the container, you need to check the
/// `isValid` property of `CurrentScope` to determine if it still valid.
///
public protocol CurrentScope: Scope {
    /// Shows if Scope is still valid and could be used to resolve dependencies.
    ///
    /// `CurrentScope` keeps a weak reference to underling container and
    /// may become invalid if container gets deallocated.
    ///
    var isValid: Bool { get }

    /// Creates a child `Container`.
    ///
    /// - Returns: an empty child `Container`.
    ///
    func createChildContainer() throws -> Container

    /// Creates a named child `Container`.
    ///
    /// - Parameter name: The name for a new container.
    /// - Returns: an empty child `Container` with `name`.
    ///
    func createChildContainer(name: String?) throws -> Container
    
    /// Creates a child `Container`.
    ///
    /// - Parameter buildFunc: The closure to registers additional components.
    /// - Returns: A child `Container`.
    ///
    func createChildContainer(_ buildFunc: (ContainerBuilder) -> Void) throws -> Container
    
    /// Creates a child `Container`.
    ///
    /// - Parameter name: The  name for a new container.
    /// - Parameter buildFunc: The closure to registers additional components.
    /// - Returns: A child `Container`.
    ///
    func createChildContainer(name: String?, _ buildFunc: (ContainerBuilder) -> Void) throws -> Container
}
