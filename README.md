# Juice

`Juice` is a Swift dependency injection container. It is in active development, but already has most basic features needed to spice an app with inversion of control.

# Quick start

##  Creating a container

Container builder has a simple fluent syntax. Components are registered one by one with all options specified explicitly.

```swift
let container = try Container { builder in
    builder.register(injectable: FreshJuice.self)
            .instancePerDependency()
            .as(Juice.self)
    builder.register(injectable: Orange.self)
            .instancePerDependency()
            .as(Fruit.self)
            .asSelf()
}
```

Where `FreshJuice` and `Orange` are defined as:

```swift
class FreshJuice: InjectableWithParameter, Juice {
    let fruit: Fruit

    required init(_ fruit: Fruit) {
        self.fruit = fruit
    }
}
class Orange: Fruit, Injectable {
    required init() {
    }
}
```

## Resolving a service

```swift
let orangeJuice = try container.resolve(Juice.self)
```

Or optional:
```swift
let compot = try container.resolveOptional(Compot.self)
let tea = try container.resolve(Tea?.self)
```

### Resolving with parameters

You can pass additional parameters to a component:
```swift
let appleJuice = try container.resolve(Juice.self, withParameters: Parameter<Fruit>(Apple.self))
```

## Property injection

Property injection is supported using writeable key paths:

```swift
let container = try Container { builder in
    builder.register(injectable: Pear.self)
            .singleInstance()
            .as(Fruit.self)
    builder.register(injectable: Ginger.self)
            .singleInstance()
            .as(Spice.self)
    builder.register(injectable: Jam.self)
            .singleInstance()
            .asSelf()
            .injectDependency(into: \.fruit)
            .injectDependency(into: \.spice)
}
```

## Child containers

```swift
let container = try Container {
    $0.register(injectable: Orange.self)
            .instancePerDependency()
            .as(Fruit.self)
    $0.register(injectable: FreshJuice.self)
            .instancePerDependency()
            .asSelf()
}
let childContainer = try container.createChildContainer {
    $0.register(injectable: Apple.self)
            .instancePerDependency()
            .as(Fruit.self)
}

let appleJuice = try childContainer.resolve(FreshJuice.self)
```

Child containers inherit all registrations from parent.

## Thread Safety

Not implemented yet. See Roadmap. For now, all access to a container from multiple threads must be synchronized by calling code.

## Modules

See roadmap.

# More Details

## Container build

```swift
let container = try Container { builder in 
	// Put your registrations here
}
```

Container initializer throws a CotainerError  when it encounters an error in registrations. 

## Component and services

_Component_ is a type resgistered in container when it is build. Whereas _service_ is a type that is later resolved from container as a dependency. One _Component_ may provide several services. For example: 

```swift
let container = try Container { builder in
    builder.register(injectable: FreshJuice.self)
            .instancePerDependency()
            .as(Juice.self)
    builder.register(injectable: Orange.self)
            .instancePerDependency()
            .as(Fruit.self)
            .asSelf()
}
```
Here, `FreshJuice` and `Orange` are components, while `Juice` and `Fruit` are services that they provide. 

At the moment you can not register more than one component by the same service in one contianer. However, you can override service registration using child container.

### Injectable

The simplest way to tell Juice how to create an instance of component at a runtime is to conform it to the `Injectable` protocol.

```swift
builder.register(injectable: Orange.self)
```

Injectable protocol is defined like this:

```swift
public protocol Injectable {
    init()
}
```

It has only one member: a required parameterless `init()`. There are also several InjectableWithParameter protocols. When you need to receive dependencies in `init()` , You pick one of them, depending on how many parameters you need.

```swift
public protocol InjectableWithParameter {
    associatedtype ParameterType
    init(_ parameter: ParameterType)
}
// or
public protocol InjectableWithTwoParameters {
    associatedtype FirstParameterType
    associatedtype SecondParameterType

    init(_ firstParameter: FirstParameterType, _ secondParameter: SecondParameterType)
}
public typealias InjectableWith2Parameters = InjectableWithTwoParameters
```

Alternatively, or when component has many dependencies, you can inject `CurrentScope` and resolve everything from it manually:

```swift
class TeaBlend: InjectableWithParameter {
    let tea: Tea
    let fruit: Fruit
    let berry: Berry
    let flower: Flower
    let herb: Herb
    let spice: Spice

    required init(_ scope: CurrentScope) throws {
        self.tea = try scope.resolve(Tea.self)
        self.fruit = try scope.resolve(Fruit.self)
        self.berry = try scope.resolve(Berry.self)
        self.flower = try scope.resolve(Flower.self)
        self.herb = try scope.resolve(Herb.self)
        self.spice = try scope.resolve(Spice.self)
    }
}
```

Please note, that your component may keeping a reference to `CurrentScope` to, for example, resolve dependencies at a later stage. However, CurrentScope itself keeps a weak reference to the container. That means that if by any mistake your component has a longer lifetime than Container, CurrentScope will become invalid and resolve method will throw an error. If your component by design lives longer then the container, you may check the isValid property of CurrentScope to determine if it still valid.

### Property injection

Property injection is another way to get dependencies from _Container_. You can even use solely property injection without bothering to conform to InjectableWithParameters protocol. The disadvantage of such approach is that you need to change component registration every time a new dependency is added. Also all properties used for dependency injection must be var optional or implicitly unwrapped optional.

```swift
let container = try Container { builder in
    builder.register(injectable: Pear.self)
            .singleInstance()
            .asSelf()
            .as(Fruit.self)
    builder.register(injectable: Jam.self)
            .singleInstance()
            .asSelf()
            .injectDependency(into: \.fruit)
            .injectOptionalDependency(into: \.spice)
}

class Pear: Fruit, Injectable {
    required init() {
    }
}

class Jam: Injectable {
    var fruit: Fruit!
    var spice: Spice?

    required init() {
    }
}
```

_Container_ resolves and injects values to properties immediately after `init()` method  finishes. The instance will not be accessible to other parts of you program until then.

### Registering a component factory

In cases when conformance to Injectable protocol is not possible or not desired, you can register a factory that will be used to create instances of component.

```swift
let container = try Container { builder in
    builder.register(factory: {
        Cocktail(fruitJuice: try $0.resolve(Juice.self), 
			lime: Lime(), 
			sweetener: Sugar(), 
			water: SodaWater())})
            .singleInstance()
            .asSelf()
}

class Cocktail {
    let fruitJuice: Juice
    let lime: Lime
    let sweetener: Sweetener
    let water: Water

    required init(fruitJuice: Juice,
                  lime: Lime,
                  sweetener: Sweetener,
                  water: Water) {
        self.fruitJuice = fruitJuice
        self.lime = lime
        self.sweetener = sweetener
        self.water = water
    }
}
```

### External instances

You can register an external instance, i.e. an instance that was created before the _Container_ build and possibly has a longer lifetime than _Container_. When registering such instance, you may optionally tell container to take ownership and keep a strong reference to it.

```swift
let apple = Apple()
        
let container = try Container { builder in
    builder.register(instance: apple)
            .ownedByContainer()
            .asSelf()
```

## Component lifetime

When registering a component that will be created by container, you need to specify its lifetime:
1. _Instance per dependency_ - _Container_ always creates a new instance of such component when it needs to inject dependency and does not keep any reference to it.
2. Single instance. Only one instance is created per _Container_. The same instance is also shared with child containers.
3. Instance per container. Similar to single instance, but each child container will create its own instance of this component.
4. Instance per named container. Same as previous, but component are only created within containers with matching name.

## Resolving component with parameters

Parameters passed to `resolve` method are matched buy exact type and always override container registrations.

```swift
let appleJuice = try container.resolve(Juice.self, withParameters: Parameter<Fruit>(Apple.self))
```

Please note also that unused or not matched parameters are simply ignored.

## Child Containers

Child containers are an efficient way to manage the lifetime of your components. When creating one, you may use a builder closure to register additional components, or override some of derrived from parent container.

### Creating a child container from within a component.

To create a child container from your component, simply inject a `CurrentScope` and call `createChildContainer` method. Please note, that resolve parameters that might be part of a `CurrentScope` are not inherited buy `ChildContainer`.
Parent container does not keep reference to ichild. Calling code is fully responsible for managing its lifetime.

# Contribution

All contributors are wellcome. Just make sure your code is covered with test.

# Fail-fast

_Juice_ follows [Fail-fast](https://en.wikipedia.org/wiki/Fail-fast)principle and it throws an `ContainerError` as soon as it finds any mistake in registrations, or if it can not resolve requested service.

# Roadmap

1. Thread safety.
2. Defer resolution of dependencies with Defered\<T\>.
3. Implement AutoFactory\<T\> that will simplify creating multiple child components from container.
4. Add Modules.
5. Aloow multiple components implementing the same service.
6. Dynamic registrations.

# License

This project is licensed under MIT License.