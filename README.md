# Juice
Juice is a Swift dependency injection container. It is a new project, but it already has basic features needed to refresh an app with DI.

## Installing

With a swift package manager:

```swift
dependencies: [
        .package(url: "https://github.com/andrey-shavelev/Juice", from: "0.1.0")
//...
    ]
```

## Quick Start

Using Juice is simple. First, you create a Container and register all required components. Second, resolve the services you need, while Juice injects all the dependencies automatically.
Please find some code samples bellow, or skip to «More Details» section, if you prefer.

###  Creating a Container

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

class FreshJuice: InjectableWithParameter {
    let fruit: Fruit

    required init(_ fruit: Fruit) {
        self.fruit = fruit
    }
}

protocol Fruit {
}

struct Orange: Fruit, Injectable {
}
```

### Resolving a Service

```swift
let orangeJuice = try container.resolve(Juice.self)
```

#### Resolving Optional

```swift
let compot = try container.resolveOptional(Compot.self)
let tea = try container.resolve(Tea?.self)
```

#### Resolving with Arguments

```swift
let appleJuice = try container.resolve(Juice.self, withArguments: Argument<Fruit>(Apple.self))
```

### Initializer Injection

```swift
class IcyLemonade: InjectableWithFiveParameters {
    let fruitJuice: Juice
    let lemon: Lemon
    let optionalSweetener: Sweetener?
    let water: Water
    let ice: Ice

    required init(_ fruitJuice: Juice,
                  _ lemon: Lemon,
                  _ optionalSweetener: Sweetener?,
                  _ water: Water,
                  _ ice: Ice) {
        self.fruitJuice = fruitJuice
        self.lemon = lemon
        optionalSweetener = optionalSweetener
        self.water = water
        self.ice = ice
    }
}

let container = try Container { builder in
    builder.register(injectable: IcyLemonade.self)
            .singleInstance()
            .asSelf()
    ///...
}

```

### Property Injection

#### Using Writable Key Paths

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

class Jam: Injectable {
    var fruit: Fruit!
    var spice: Spice?

    required init() {
    }
}
```

#### Using _@Inject_ Property Wrapper

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
}

class Jam: Injectable {
    @Inject var fruit: Fruit
    @Inject var spice: Spice?

    required init() {
    }
}
```

### Child Containers

#### Creating From Another Container

```swift
let container = try Container { builer in
    // Some component registered here
}

let childContainerWithoutAdditionalComponents = container.createChildContainer()

let childContainerWithAdditionalComponents = try container.createChildContainer { builer in
    // Some additional components may be registered here
}

let namedChildContainer = container.createChildContainer(withName: "JuiceMaker")
```

#### Creating Within an Injectable Component

```swift
class SomeService : Injectable {
    
    @Inject var currentScope: CurrentScope
    
    required init() {

    }
    
    func doAThing() {
        let unitOfWorkContainer = try! currentScope.createChildContainer()
        let doerOfThings = try! unitOfWorkContainer.resolve(DoerOfThings.self)
        doerOfThings.doAThing()
    }    
}
```

#### Overriding a Service Registration

```swift
let containerWithOranges = try Container {
    $0.register(injectable: Orange.self)
            .instancePerDependency()
            .as(Fruit.self)
    $0.register(injectable: FreshJuice.self)
            .instancePerDependency()
            .asSelf()
}

let childContainerWithApples = try container.createChildContainer {
    $0.register(injectable: Apple.self)
            .instancePerDependency()
            .as(Fruit.self)
}

let appleJuice = try childContainerWithApples.resolve(FreshJuice.self)
```

## More Details

### Container build

The first step when working with the DI container is to set it up. At this point you need to register all required components, specify their lifetime scope and list services that they provide.
Component registration builder has a fluent interface that varies slightly depending on a kind of component that you are registering.
Let's look at the example of the component registration:

```swift
let container = try Container { builder in
    builder.register(injectable: Ramen.self)
        .instancePerDependency()
        .as(Soup.self)
        .as(Noodles.self)
        .injectDependency(into: \.soySouce)
        .injectOptionalDependency(into: \.miso)
   // ... other registrations
}
```

1. First, we define the type of the component that is going to be registered:

```swift
builder.register(injectable: Ramen.self)
```

Ramen could be both a class or a structure. An instance(s) of it will be created dynamically by the container. 

Apart from registering component by its type, you can also register:

- Factory methods or closures.
- External instances and values that are created outside of the container and have possibly a longer lifetime.

2. Second, we specify the lifetime scope of the Ramen component:

```swift
.instancePerDependency()
```

This make Ramen an _instance per dependency_ component, which means that the container will create a new instance of it each time when it needs to satisfy a dependency.
There are three more options available:

- _Single instance_,
- _Instance per container_,
- _Instance per named container_.

3. Next, we list all services provided by our component:

```swift
 .as(Soup.self)
 .as(Noodles.self)
```

Here we tell the container that Ramen could be resolved as Soup or as Noodles.

4. Finally, we have an option to instruct container to inject dependencies into Ramen properties of our choice:

```swift
.injectDependency(into: \.soySouce)
.injectOptionalDependency(into: \.miso)
```

After such set up, container will inject a required dependency into the _soySouce_ property and an optional dependency into the _miso_ property.

#### Registering an Injectable Type

You can register a class or structure by simply specifying it’s type if it conforms to the _Injectable_ protocol. The Injectable protocol has only one member: _required init()_ method without parameters, which tells the container how to create an instance of conforming type when it needs to.
If you want to use Initializer injection, you need to confirm your type to any of the _InjectabeWithParameter_ protocols instead:

```swift
class Cocktail: InjectableWithFourParameters {
    let fruitJuice: Juice
    let lime: Lime
    let sweetener: Sweetener
    let water: Water

    required init(_ fruitJuice: Juice,
                  _ lime: Lime,
                  _ sweetener: Sweetener,
                  _ water: Water) {
        self.fruitJuice = fruitJuice
        self.lime = lime
        self.sweetener = sweetener
        self.water = water
    }
}
```

#### Registering a Factory

You can register a factory function or a closure, that will be responsible for creation of a component instance at runtime. This approach could also be used when conformance to the Injectable protocol is not possible.
For example:

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

A factory closure receives a single parameter: _Scope_ that could be used to resolve required dependencies.

#### External Instances

In order to register an existing instance of class you use `register(instance:)` method:

```swift
let someExternalSingletonService = SingletonService.instance
        
let container = try Container { builder in
    builder.register(instance: someExternalSingletonService)
            .ownedExternally()
            .asSelf()
```

The `ownedExternally()` method tells the container to keep an unowned reference to the registered singleton. You may instead call `ownedByContainer()` method, to instruct container to take the ownership and keep a strong reference to it.

You can register an instance of struct by using `register(value:)` method:

```swift
 let devConfiguration = DatabaseConfiguration(host: "localhost", port: 3306, user: "username", password: "s3cr3t")
         
 let container = try Container { builder in
     builder.register(value: devConfiguration)
             .asSelf()
```

#### Lifetime scopes

For every injectable component, as well as for all components created by factories, you has to explicitly specify how their instances will be scoped. You do it by calling one of four methods of component registration builder:

- `instancePerDependency()`
- `singleInstance()`
- `instancePerContainer()`
- `instancePerContainer(withName:)`

As was mentioned before, for _instance per dependency_ components container creates a new instance each time when the component is injected as a dependency or the _resolve(…)_ method is called. These components are not stored in the container and user code is responsible for managing their lifetime. 

As the name suggests, only one instance is created for a _single instance_ component. This instance is also shared within a hierarchy of child containers.

_Instance per container_ and _ instance per named container_ components both act similar to _single instance components_, but with two differences:

1. For _instance per container_ components instances are not shared with child containers. Each of them creates its own instance. 
2. For _ instance per container named container_ – instances are created only in containers with matching name and are shared with child containers unless a child container has again a matching name  — that container will create a new instance of its own.

The container owns all _single instance_, _instance per container_ and matching _instance per named container_ components that were created during its lifetime and keeps a strong reference to them. It is supposed that they are deallocated together with the owning container. 

#### Declaring services

All services that component provides has to be declared explicitly by calling either `as()` or `asSelf()` method of component registration builder:

```swift
let container = try Container { builder in
    builder.register(injectable: Pear.self)
            .singleInstance()
            .asSelf()
            .as(Fruit.self)
// Pear was registered with two services
}
```

You has to specify at least one service for each component registered in the container. A registration without services is considered incomplete and invalid.
One component may be registered by several services. In contrast, you can not register two or more components by the same service in one container. This is not supported at the moment.

#### Listing writeable keypaths that are used for the property injection 

You instruct the container to inject dependencies into properties by calling `injectDependency(into:)` or `injectOptionalDependency(into:)` method of the registration builder.

All properties listed during component registration must be declared optional or implicitly unwrapped optional, and could not be private.

### Resolving a service

When the container is built and ready, you can start resolving services from it. 
For example:

```swift
        let container = try Container { builder in
           // ...
        }
        
        let appModule = try! container.resolve(AppModule.self)
        appModule.bootstrap()
        appModule.listen(atPort: 3000)
```

Most probably you will only resolve root services directly from the container and all other services will be injected automatically using _initializer injection_ or _property injection_.

Whenever you resolve services manually or not, the resolution process follows three simple steps:

1. First, Juice looks for a matching component registration, starting from the container you are resolving form and going up in the container hierarchy.
2. When a registration is found, Juice returns back to the container it started from and repeats the process but now looking for a correct container to create and store the component.
3. Finally, after it finds the matching storage, Juice resolves all component dependencies from it, and then creates an instance and, if needed, stores it in the container.

#### Resolving a Service With Additional Arguments

You can pass additional arguments, including specific dependencies, when resolving a component. For example:

```swift
let appleJuice = try container.resolve(Juice.self, withArguments: Argument<Fruit>(Apple.self))
```

All arguments are added to the _CurrentScope_ of resolved component and are used for the _Initializer injection_ and for the _property injection_. 
For _single instance_, _instance per container_ and _instance per named container_ components only first call to `container.resolve(:withArguments:)` actually has an effect. Subsequent calls will return existing instance, and all arguments will be ignored.

#### Initializer injection

When a component confirms to one of InjectableWithParameters protocols,  Juice resolves all parameters of the`init(...)` method and uses them to create an instance. When a component has too many dependencies, you can inject _CurrentScope_ protocol and resolve everything needed from it:

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

CurrentScope is a protocol that represents a scope that the component is resolved from. Behind CurrentScope could be a simple container wrapper or a parameterized container wrapper that holds additional arguments.
Your component may keep a reference to CurrentScope to resolve dependencies later on. It supposed that components have the same or shorter lifetime then the container, so keeping reference to CurrentScope should not be a problem. However, CurrentScope itself keeps a weak reference to the container. It means that if a component is designed to have a longer lifetime than the container, CurrentScope may become invalid and will throw an error if you try to resolve services from it. If this is the case, you need to check the _.isValid_ property of CurrentScope to determine if it still valid.

Please note that when a component keeps a reference to its CurrentScope, it also creates a references to all arguments in it, if any were passed.

CurrentScope could also be used to create a child container, using one of the _createChildContainer_ methods. In this case additional arguments that might  present in the CurrentScope are not inherited buy child containers, only component registrations are.

#### Property Injection

After the instance of injectable component is initialized, but before it becomes accessible to other components (could be injected or returned as a result of resolve method) the container injects all properties if any were registered for injection. 
You are free to combine initializer injection and property injection or you may use only one of them — it's up to you. However, you should keep in mind some limitations that come together with property injection: 

1. When using writeable keypaths, all properties that dependencies are injected into must be declared optional or implicitly unwrapped optional, and could not be private. 
2. @Inject wrapper allow you to inject dependencies even into private properties. However, classes and structures that use the @Inject wrapper can not be simply created by calling _init_ method, they can only be resolved from the container. Creating them in a traditional way will cause a runtime error.

#### Resolving an optional dependency

A service is considered optional if it is a normal situation when no components providing this service are registered in the container.
There are several way to resolve an optional service.

When using @Injectable property wrapper, you simple need to declare the property optional:
```swift
struct SushiRoll: Injectable {
    // Required stuff
    @Inject var tuna: Tuna
    @Inject var cucumber: Cucumber
    @Inject var mayo: Mayo
    // Really optional
    @Inject var omelette: Omelette?   
}
```

When using CurrentScope or Container, you call `resolveOptional()` method:
```swift
class SushiRoll: InjectableWithParameter {
    required init(_ currentScope: CurrentScope) throws {
        self.omelette = try currentScope.resolveOptional(Omlet.self)
        // ...
    }
    // ...
}
```

You can also resolve optional service by passing optional type to `resolve` method:
```swift
class SushiRoll: InjectableWithParameter {
    required init(_ currentScope: CurrentScope) throws {
        self.omelette = try currentScope.resolve(Omelette?.self)
        // ...
    }
    // ...
}
```

Or specifying optional parameter in init method of Injectable component:
```swift
class SushiRoll: InjectableWith4Parameters {    
    required init(_ tuna: Tuna,
                  _ cucumber: Cucumber,
                  _ majo: Majo,
                  _ optionalOmelette: Omelette?) {
        // ...
    }
}
```

Either way, Juice will resolve a service if it is registered or will put/return _nil_ if it is not.

There is one more situation to consider: when an optional service _is_ registered in the container, but it has missing dependencies (required). This situation is treated as a erroneous, and Juice does not try to hide it and, instead, reports an error.
For example:

```swift
class FreshJuice: InjectableWithParameter, Juice {
    let fruit: Fruit

    required init(_ fruit: Fruit) {
        self.fruit = fruit
    }
}

// ...

let container = try Container { builder in
            builder.register(injectable: FreshJuice.self)
                .instancePerDependency()
                .as(Juice.self)
        }

let freshJuice = try container.resolveOptional(Juice.self)
```

Here, _freshJuice_ is not set to _nil_, an error is thrown instead. If optional component’s init method throws an error it is also rethrown. 

Summarizing, Juice uses following algorithm when resolving an optional service:

1. Search for a registration. If not found - return nil. If found go to step 2.
2. Try to resolve registered component. Resolved successfully? Then return an instance of component; else throw an error.

### Containers Hierarchy 

A child container keeps a reference to its parent and inherits all component registrations. When creating a child container you can use a container builder to register additional components or override inherited registrations.
Parent container does not keep any reference to child container, and your code is fully responsible for managing its lifetime.

### Thread Safety

Thread safety is not implemented yet. All access to the container from multiple threads must be synchronized by calling code.

### Fail-fast

Any _resolve()_ method and many other methods working with container may throw a _ContainerError_ , that is because Juice follows [Fail-fast](https://en.wikipedia.org/wiki/Fail-fast) principle. When it can not find required dependencies, when a component registration is incomplete or incorrect or when any other possibly erroneous situation occurs it immediately reports the problem to the user code.

## Roadmap to Version 1.0

1. Modules.
2. Thread safety.
3. Defered resolution of dependencies with Defered\<T\>. @Inject(.deferred)
4. AutoFactory\<T\> – to simplify creating multiple child components with arguments.
5. Dynamic registrations.
6. Weak references to a single instance component.
7. Allow multiple components implementing the same service.

## License

This project is licensed under MIT License.
