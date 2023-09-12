//
//  Films+Publisher.swift
//  Izertisflix
//
//  Created by Pablo Álvarez Álvarez on 9/9/23.
//

/**
 Extension para realizar búsquedas de películas utilizando Combine y gestionar los resultados y errores.
 */

import Foundation
import Combine

extension Films {
    
    // Representa un flujo de valores de tipo [Film] o errores de tipo Error.
    static func publisher(text: String, store: inout [AnyCancellable]) -> AnyPublisher<[Film], Error> {
        
        // PassthroughSubject, punto de entrada para emitir valores (en este caso, [Film]) o errores a través de Combine.
        let publisher = PassthroughSubject<[Film], Error>()
        let url = ServiceEndpoint.search(text: text).url
        
        // Solicitud de red a la URL construida anteriormente
        // Mapeo de los datos recibidos (.map(\.data)) y se decodifican 'JSONDecoder'.
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: Self.self, decoder: JSONDecoder())
        
        // Suscribe al flujo de valores y errores que se obtienen de la solicitud de red.
        // Cuando completa la solicitud o recibe un valor, se envian los resultados al PassthroughSubject.
        // Los resultados se envían a través del publisher.
            .sink(
                receiveCompletion: { completed in publisher.send(completion: completed) },
                receiveValue: { result in publisher.send(result.results) })
        
        // Las suscripciones se almacenan en array 'store' proporcionado como parámetro en la función.
            .store(in: &store)
        
        // Emite resultados y errores de la solicitud de red.
        // Permite que el código que llama a este método se suscriba a él y reciba los resultados de la búsqueda.
        return publisher.eraseToAnyPublisher()
    }
}
