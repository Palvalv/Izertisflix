//
//  FilmViewModel.swift
//  Izertisflix
//
//  Created by Pablo Álvarez Álvarez on 9/9/23.
//

/**
 Gestiona la viewModel que representa información de películas en una celda de lista (FilmListCellView).
 Proporciona propiedades calculadas para acceder a los detalles de una película y se utiliza para formatear y presentar estos detalles de manera adecuada en la interfaz de usuario.
 */

import Foundation

class FilmViewModel: Identifiable {
    
    // Representa detalles básicos de una película, como su título, año, idioma y URL del póster.
    private var film: Film
    
    // Propiedades
    var id: String {
        film.id
    }
    
    var title: String {
        film.title
    }

    var year: String {
        film.year
    }

    var type: String {
        film.type.capitalized
    }

    var poster: String {
        film.poster
    }

    // Inicia una instancia que se utiliza para crear una vista a partir de los datos de una película.
    init(film: Film) {
        self.film = film
    }
    
    // Vista previa para la interfaz de desarrollo.
    static var example: FilmViewModel {
        .init(film: .init(id: "1", title: "ExampleTerminator", year: "2020", type: "movie", poster: ""))
    }
}
