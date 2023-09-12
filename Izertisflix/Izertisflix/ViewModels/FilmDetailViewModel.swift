//
//  FilmDetailViewModel.swift
//  Izertisflix
//
//  Created by Pablo Álvarez Álvarez on 9/9/23.
//

/**
 Gestiona la viewModel que representa información detallada sobre una película en la vista 'FilmDetailView'.
 Otorga las propiedades para acceder a los detalles de la película y una función para cargar los detalles de la película desde el servidor.
 */

import Foundation
import Combine

class FilmDetailViewModel: ObservableObject {
    
    // Almacena el ID único de la película que se utilizará para obtener detalles de la película.
    private var id: String
    
    // Almacena una instancia de FilmDetail que representa los detalles de la película seleccionada.
    private var model: FilmDetail?

    private var subscriptions: [AnyCancellable] = []

    // Señala cuando se ha cargado correctamente la información de la película desde el servidor.
    @Published var isLoaded: Bool = false

    // Inicializa una instancia de 'FilmDetailViewModel' con un ID de película proporcionado. Crea una vista para una película específica.
    init(id: String) {
        self.id = id
    }

    // Representa detalles básicos de una película, como su título, año, idioma y URL del póster.
    var poster: String {
        model?.poster ?? ""
    }

    var title: String {
        model?.title ?? ""
    }

    var plot: String {
        model?.plot ?? "No details"
    }

    var type: String {
        model?.type.capitalized ?? "None"
    }
    
    var language: String {
        model?.language ?? "None"
    }

    var director: String {
        model?.director ?? "None"
    }

    var rating: String {
        "\(model?.rating ?? "0")/10"
    }

    var votes: String {
        "(votes \(model?.votes ?? "0"))"
    }

    var year: String {
        model?.year ?? "None"
    }

    /* Obtiene los datos del artículo del servidor. Utiliza el editor 'FilmDetail' para obtener los datos remotos, cuando están completos
      establece el caché del modelo y luego señala la vista con el campo publicado 'isLoaded'. */
    func load() {
        FilmDetail.publisher(id: self.id, store: &subscriptions)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        print("failed to get film detail: \(error)")
                    }
                },
                receiveValue: {
                    self.model = $0
                    self.isLoaded = true
                }
            )
            .store(in: &subscriptions)
    }

    // Vista previa para la interfaz de desarrollo.
    static var example: FilmDetailViewModel {
        let viewModel = FilmDetailViewModel(id: "")
        viewModel.model = .init(
            id: "",
            title: "ExampleTerminator Film Title",
            year: "2020",
            type: "movie",
            plot: "Description",
            language: "Spanish",
            director: "Jack",
            rating: "9",
            votes: "2323",
            poster: "")
        viewModel.isLoaded = true
        return viewModel
    }
}

