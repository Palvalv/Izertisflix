//
//  ServiceEndpoint.swift
//  Izertisflix
//
//  Created by Pablo Álvarez Álvarez on 9/9/23.
//

/**
 Define un 'enum' que proporciona una forma estructurada de construir 'URLs' que realizan llamadas al servidor remoto de 'OMDB AP'I.
 Las 'URLs' se construyen en función de los casos del 'enum', y se utiliza una clave de 'API' almacenada de forma privada para autenticar las solicitudes.
 */

import Foundation

// Define los posibles 'endpoints' que se pueden utilizar para realizar llamadas al servidor.
enum ServiceEndpoint {

    case search(text: String)
    case detail(id: String)

    // Devuelve una instancia de 'URL' basada en el tipo de solicitud del 'endpoint'. 'S' para search e 'I' para information.
    var url: URL {
        switch self {
        case .search(let text):
            return buildURL(key: "s", value: text)
        case .detail(let id):
            return buildURL(key: "i", value: id)
        }
    }

    /* Crea un componente de 'URL' a partir de una 'URL base' y agrega los parámetros de consulta necesarios, que incluyen la clave apikey.
    Luego, devuelve la 'URL' construida. */
    private func buildURL(key: String, value: String) -> URL {

        var components = URLComponents(string: baseURL.absoluteString)!
        components.queryItems = [
            .init(name: key, value: value),
            .init(name: "apikey", value: apiKey)
        ]
        return components.url!
    }

    // Define la 'URL base' para todas las llamadas al servidor.
    private var baseURL: URL { URL(string: "https://www.omdbapi.com/")! }


    /* Contiene la clave de 'API' necesaria para realizar llamadas a la 'API OMDB'. La clave de 'API' se obtiene desde una constante llamada 'Constants.apiKey', que generalmente se encuentra en un archivo separado.*/
    private var apiKey: String { Constants.apiKey }
}
