//
//  Films.swift
//  Izertisflix
//
//  Created by Pablo Álvarez Álvarez on 9/9/23.
//

/**
 Struct para representar resultados de búsqueda de películas.
 Decodable permite que esta estructura se utilice para mapear datos JSON en objetos Swift de manera automática.
 Los resultados se almacenan en una propiedad llamada results.
 Se proporciona una personalización para la codificación y decodificación de datos JSON utilizando el enum CodingKeys.
 */

import Foundation

struct Films: Decodable {
    
    var results: [Film]
    
    private enum CodingKeys: String, CodingKey {
        case results = "Search"
    }
}
