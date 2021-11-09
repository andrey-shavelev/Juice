[![license-MIT](https://img.shields.io/badge/license-MIT-green)](https://opensource.org/licenses/MIT)
[![Swift-5.2](https://img.shields.io/badge/Swift-5.2-orange)](https://swift.org)
![Tests](https://github.com/andrey-shavelev/Juice/actions/workflows/tests.yml/badge.svg)


# Juice
Juice is a Swift dependency injection container. 

## Installing

With a swift package manager:

```swift
dependencies: [
        .package(url: "https://github.com/andrey-shavelev/Juice", from: "0.1.0")
//...
    ]
```

## Quick Start
###  Creating container and registering services

```swift
let container = try Container { builder in

// register a type that conforms to Injectable protocol

    builder.register(injectable: FreshJuice.self)
            .instancePerDependency()
            .as(Juice.self)

// register by initializer

    builder.register(initializer: Apple.init(color:))
        .instancePerDependency()
         .asSelf()

// register a custom factory

    builder.register { scope -> TeaBlend in
           let orange = try scope.resolve(Orange.self)
        let blackTea = try scope.resolve(BlackTea.self)
    
        return TeaBlend(fruit: orange, tea: blackTea)
    }
    .singleInstance()
    .asSelf()
}
```

### Resolving a Service

```swift
// required

let orangeJuice = try container.resolve(Juice.self)

// optional

let compot = try container.resolveOptional(Compot.self)
let tea = try container.resolve(Tea?.self)

// supplying arguments

let appleJuice = try container.resolve(
    Juice.self, 
    withArguments: Apple())

// or when you need to specify type directly

let appleJuice = try container.resolve(
    Juice.self, 
    withArguments: Argument<Fruit>(Apple()))

```

Arguments passed to `resolve` method are matched with initializer parameters by their type and take precedence over services registered in container.

### Dependency Injection

#### Initializer
For services that conform to one of `Injectable` protocols or are registered by their `init` method, parameters of the initializer are filled in by `Container`.

```swift
class IcyLemonade: InjectableWithFiveParameters {
    let fruitJuice: Juice
    let lemon: Lemon
    let optionalSweetener: Sweetener?
    let water: Water
    let ice: Ice

    // All parameters will be filled by Container from resolution scope.
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

### Property
Alternatively, dependencies could be injected into properties.

```swift
// Using Inject property wrapper

class Jam {
    @Inject var fruit: Fruit
    @Inject var spice: Spice?

    init() {
    }
}

// Or without wrapper

struct TeaBlend {
    var fruit: Fruit!
    var spice: Spice?

       init() {
    }
}

// In this case you need to specify properties for injection when registering a service

let container = try Container { builder in
    builder.register(injectable: Jam.self)
            .singleInstance()
            .asSelf()
            .injectDependency(into: \.fruit)
            .injectDependency(into: \.spice)
}
```

### Lazy dependencies

```swift
class Egg {
    unowned var chicken: Chicken
    
    required init(_ chicken: Chicken) {
        self.chicken = chicken
    }
}

class Chicken {
    var egg: Lazy<Egg>
    
    required init(_ egg: Lazy<Egg>) {
        self.egg = egg
    }
}

/* 
 * Lazy<T> - is a wrapper that delays actual resolution 
 * until its value is requested. 
 * For this purpose it keeps a strong reference to a resolution 
 * context of the owning instance, 
 * including all arguments (if any) that were passed to it.
*/
```

### Modules

```swift
let container = try Container { builder in
    builder.register(module: FruitModule())
}

// Module allows to group registrations
struct FruitModule : Module {
    func registerServices(into builder: ContainerBuilder) {
        builder.register(injectable: Apple.self)
            .instancePerDependency()
            .asSelf()
        builder.register(injectable: Orange.self)
            .instancePerDependency()
            .as(Fruit.self)
    }
}
```

### Child Containers

```swift
let container = try Container { builer in
    // Some types are registered here
}

let childContainer = try container.createChildContainer { builer in
    // Additional types are be registered here
    // Registrations from the parent container could be overriden  
}
```

### Thread Safety

Current version of Juice does not support resolving services from concurrent threads. 

## Registration options

```swift
let container = try Container { builder in

// Instance per depenedency
    builder.register(injectable: Banana.self)
      .singleInstance()
      .asSelf()
// Each time Banana is resolved, container will return the same instance. Container will keep strong reference to it.

// Single instance
    builder.register(initializer: Apple.init(color:))
      .instancePerDependency()
         .asSelf()
// Each time Apples is resolved, container will create a new instance. Container will not keep reference to any of it.

// External singletons
let someExternalSingleton = SingletonService.instance
        
builder.register(instance: someExternalSingleton)
  .ownedExternally()
  .asSelf()
// For instances registered as ownedExternally() container will keep an unowned reference.

let anotherExternalSingleton = AnotherSingletonService.instance
        
builder.register(instance: anotherExternalSingleton)
  .ownedByContainer()
  .asSelf()
// For instances registered as ownedByContainer() container will keep a strong reference.
}

```

## License

This project is licensed under MIT License.
