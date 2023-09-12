//
//  FilmDetail+Publisher.swift
//  Izertisflix
//
//  Created by Pablo Álvarez Álvarez on 9/9/23.
//

/**
 Extension para obtener los detalles de una película utilizando Combine y gestionar los resultados y errores.
 */

import Foundation
import Combine

extension FilmDetail {
    
    // Representa un flujo de valores de tipo FilmDetail o errores de tipo Error.
    static func publisher(id: String, store: inout[AnyCancellable]) -> AnyPublisher<FilmDetail, Error> {
        
        // PassthroughSubject, punto de entrada para emitir valores (en este caso, [FilmDetail]) o errores a través de Combine.
        let publisher = PassthroughSubject<FilmDetail, Error>()
        let url = ServiceEndpoint.detail(id: id).url
        
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
                receiveValue: { result in publisher.send(result) })
        
        // Las suscripciones se almacenan en array 'store' proporcionado como parámetro en la función.
            .store(in: &store)
        
        // Emite resultados y errores de la solicitud de red.
        // Permite que el código que llama a este método se suscriba a él y reciba los resultados de la búsqueda.
        return publisher.eraseToAnyPublisher()
    }
}
