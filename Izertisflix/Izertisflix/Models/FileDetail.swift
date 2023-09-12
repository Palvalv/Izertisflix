//
//  FileDetail.swift
//  Izertisflix
//
//  Created by Pablo Álvarez Álvarez on 9/9/23.
//

/**
 Representa un modelo para los detalles de una sola película.
 */

import Foundation

struct FilmDetail: Decodable, Identifiable {
    var id: String
    var title: String
    var year: String
    var type: String
    var plot: String
    var language: String
    var director: String
    var rating: String
    var votes: String
    var poster: String
    
    private enum CodingKeys: String, CodingKey {
        case id = "imdbID"
        case title = "Title"
        case year = "Year"
        case type = "Type"
        case plot = "Plot"
        case language = "Language"
        case director = "Director"
        case rating = "imdbRating"
        case votes = "imdbVotes"
        case poster = "Poster"
    }
}
