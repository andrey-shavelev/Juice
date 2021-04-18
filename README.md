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

### Lazy dependencies

```swift
class Egg: InjectableWithParameter {
    unowned var chicken: Chicken
    
    required init(_ chicken: Chicken) {
        self.chicken = chicken
    }
}

class Chicken: InjectableWithParameter {
    var egg: Lazy<Egg>
    
    required init(_ egg: Lazy<Egg>) {
        self.egg = egg
    }
}
```

### Auto factories

```swift
class RobotFactory: Injectable {
    
    @Inject var armFactory: FactoryWith2Parameters<Side, Equipment, Arm>
    @Inject var legFactory: FactoryWith2Parameters<Side, Equipment, Leg>
    
    required init() throws {
        
    }
    
    func makeRobot(withName name: String) throws -> Robot {
        return Robot(name: name,
                     leftArm: try armFactory.create(.left, .machineGun),
                     rightArm: try armFactory.create(.right, .lazer),
                     leftLeg: try legFactory.create(.left, .jumpJet),
                     rightLeg: try legFactory.create(.right, .jumpJet))
    }
```

### Modules

```swift
let container = try Container { builder in
    builder.register(module: FruitModule())
}

struct FruitModule : Module {
    func registerServices(into builder: ContainerBuilder) {
        builder.register(injectable: Apple.self)
            .instancePerDependency()
            .asSelf()
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

Component registration builder has a fluent interface that varies slightly depending on a kind of component that you are registering.

```swift
let container = try Container { builder in
    builder.register(injectable: Ramen.self)
        .instancePerDependency()
        .as(Soup.self)
        .injectDependency(into: \.soySouce)
        .injectOptionalDependency(into: \.miso)
   // ... other registrations
}
```
1. Here, we define the type of the component that is going to be registered:

```swift
builder.register(injectable: Ramen.self)
```

2. Next, we specify the lifetime for the Ramen component:

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

#### Component lifetime

For each injectable component, as well as for all components created by factories, you has to explicitly specify how their instances will be scoped. You do it by calling one of four methods of component registration builder:

- `instancePerDependency()`
- `singleInstance()`
- `instancePerContainer()`
- `instancePerContainer(withName:)`

The container owns all _single instance_, _instance per container_ and matching _instance per named container_ components that were created during its lifetime and keeps a strong reference to them. It is supposed that they are deallocated together with the owning container. 

#### Declaring services

]
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


#### Resolving a Service With Additional Arguments

You can pass additional arguments, including specific dependencies, when resolving a component. For example:

```swift
let appleJuice = try container.resolve(Juice.self, withArguments: Argument<Fruit>(Apple.self))
```

All arguments are added to the _CurrentScope_ of resolved component and are used for the _Initializer injection_ and for the _property injection_. 
For _single instance_, _instance per container_ and _instance per named container_ components only first call to `container.resolve(:withArguments:)` actually has an effect. Subsequent calls will return existing instance, and all arguments will be ignored.

#### Initializer injection

When a component confirms to one of InjectableWithParameters protocols,  Juice resolves all parameters of the`init(...)` method and uses them to create an instance. When a component has too many dependencies, it can inject _CurrentScope_ protocol and resolve everything needed from it:

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

### Lazy dependencies

_Lazy\<T\>_ allows to postpone resolution of service until the moment when it is  needed. For example:

```swift
class TripPlanningService: Injectable {
    @Inject var hotelBookingService: Lazy<HotelBookingService>

    required init() {
    }
    
    func planATrip(forDays days: Int) throws -> Trip {
        if (days > 1) {
            try hotelBookingService.getValue().makeBooking()
        }
		// more planing ...
    }    
}
```

### Auto factories

Auto factories provider a convenient way to create multiple child components within a parent component. 

```swift
class RobotFactory: Injectable {
    
    @Inject var armFactory: FactoryWith2Parameters<Side, Equipment, Arm>
    @Inject var legFactory: FactoryWith2Parameters<Side, Equipment, Leg>
    
    required init() throws {
        
    }
    
    func makeRobot(withName name: String) throws -> Robot {
        return Robot(name: name,
                     leftArm: try armFactory.create(.left, .machineGun),
                     rightArm: try armFactory.create(.right, .lazer),
                     leftLeg: try legFactory.create(.left, .jumpJet),
                     rightLeg: try legFactory.create(.right, .jumpJet))
    }
}
```

There are several generic _Factory_ types declared, depending on how many arguments you need to pass. There is no need to manually register _Factory_ types in container. They are registered and created dynamically when needed. 

Using _Factory_ is the same as using _resolve(\_:withArguments:)_ method of _CurrentScope_, with only difference that parameters’ types are specify in factory class generic arguments, not when _resolve_ method is called. 

```swift
let arm = try armFactory.create(.left, .machineGun)

let sameArm = try currentScope.resolve(Arm.self, withArguments: Argument<Side>(.left), Argument<Equipment>(.machineGun))
```

Here _arm_  and _sameArm_ are equivalent.

Please note that _Factory_ keeps a strong reference to _CurrentScope_ of the component that it is used within and, thus, references all parameters (if any) that may present in it.

### Modules

Modules helps to organize registration of components into structured and reusable units. In order to create a module, you need to conform to the Module protocol and define _registerServices(into builder: ContainerBuilder)_. For example:

```swift
struct FruitModule : Module {
    func registerServices(into builder: ContainerBuilder) {
        builder.register(injectable: Apple.self)
            .instancePerDependency()
            .asSelf()
    }
}
```

### Containers Hierarchy 

A child container keeps a reference to its parent and inherits all component registrations. When creating a child container you can use a container builder to register additional components or override inherited registrations.
Parent container does not keep any reference to child container, and your code is fully responsible for managing its lifetime.

### Thread Safety

Thread safety is not implemented yet. All access to the container from multiple threads must be synchronized by calling code.


## License

This project is licensed under MIT License.
