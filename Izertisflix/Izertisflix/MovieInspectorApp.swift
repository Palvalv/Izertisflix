//
//  MovieInspectorApp.swift
//  Izertisflix
//
//  Created by Pablo Álvarez Álvarez on 9/9/23.
//

/**
 Define la estructura de la aplicación, se inicia con un 'ViewModel' raíz llamado 'filmListViewModel', que se comparte con todas las vistas de la aplicación.
 La vista principal de la aplicación es 'FilmListView', que utiliza este 'ViewModel' para mostrar y gestionar la lista de películas y las búsquedas recientes.
 */

import SwiftUI

// El punto de entrada desde el cual se inicia la aplicación.
@main
struct MovieInspectorApp: App {
    @StateObject var filmListViewModel: FilmListViewModel

    init() {
        let viewModel = FilmListViewModel()
        _filmListViewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some Scene {
        WindowGroup {
            FilmListView()
                .environmentObject(filmListViewModel)
        }
    }
}
