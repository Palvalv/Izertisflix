//
//  Film.swift
//  Izertisflix
//
//  Created by Pablo Álvarez Álvarez on 9/9/23.
//

/**
 Representa un modelo para un resultado de búsqueda de películas.
 La estructura es decodificable a partir de datos JSON y contiene propiedades que representan las características clave de una película.
 */

import Foundation

struct Film: Decodable, Identifiable {
    var id: String
    var title: String
    var year: String
    var type: String
    var poster: String
    
    // Especifica cómo se deben mapear las claves en los datos JSON a las propiedades de la estructura.
    private enum CodingKeys: String, CodingKey {
        case id = "imdbID"
        case title = "Title"
        case year = "Year"
        case type = "Type"
        case poster = "Poster"
    }
}
