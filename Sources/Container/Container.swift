//
//  Container.swift
//  blaze
//
//  Created by Andrey Shavelev on 21/05/2019.
//

public class Container {
    let registrations: [ServiceKey : ServiceRegistration]
    
    class func build(_ buildFunc: (ContainerBuilder) -> Void) -> Container {
        let builder = ContainerBuilder()
        buildFunc(builder)
        return builder.build()
    }
    
    init(_ registrations: [ServiceKey : ServiceRegistration]) {
        self.registrations = registrations
    }
    
    func resolve<TService>(_ serviceType: TService.Type) throws -> TService {        
        return try ContextResolver(self).resolve(serviceType)
    }
}
