//
//  Container.swift
//  blaze
//
//  Created by Andrey Shavelev on 21/05/2019.
//

public class Container {
    let registrations: [TypeKey : ServiceRegistration]
    
    init(_ buildFunc: (ContainerBuilder) -> Void) {
        let builder = ContainerBuilder()
        buildFunc(builder)
        
        self.registrations = builder.build()
    }
    
    func resolve<TService>(_ serviceType: TService.Type) throws -> TService {        
        return try ContextResolver(self).resolve(serviceType)
    }
}
